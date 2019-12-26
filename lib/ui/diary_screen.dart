import 'package:calories/blocs/daily_meals/daily_meals_bloc.dart';
import 'package:calories/blocs/daily_meals/daily_meals_event.dart';
import 'package:calories/blocs/daily_meals/daily_meals_state.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/blocs/goals/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/goal/edit_goal_screen.dart';
import 'package:calories/ui/screens/meal/meal_detail_screen.dart';
import 'package:calories/ui/screens/meal/meal_search_screen.dart';
import 'package:calories/ui/widgets/donut_chart.dart';
import 'package:calories/ui/widgets/meal_no_item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pop_with_result.dart';
import '../util.dart';
import 'screens/food/food_detail_screen.dart';
import 'screens/food/food_search_screen.dart';
import 'screens/recipe/recipe_detail_screen.dart';
import 'screens/recipe/recipe_search_screen.dart';
import 'widgets/daily_meal_item_card_widget.dart';

class DiaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DiaryScreenState();
}

class DiaryScreenState extends State<DiaryScreen> {
  String _pageTitle = "Today";
  PageController _pageController;
  FoodBloc _foodBloc;
  RecipeBloc _recipeBloc;
  DailyMealBloc _dailyMealBloc;

  @override
  void initState() {
    super.initState();
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _dailyMealBloc = BlocProvider.of<DailyMealBloc>(context);
    _pageController = new PageController(
      initialPage: getIndexFromDate(DateTime.now()),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      var todayIndex = getIndexFromDate(DateTime.now());
      if (index == todayIndex) {
        _pageTitle = "Today";
      } else if (index == todayIndex - 1) {
        _pageTitle = "Yesterday";
      } else if (index == todayIndex + 1) {
        _pageTitle = "Tomorrow";
      } else {
        _pageTitle = getDateString(index);
      }
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _changePageByDate(picked);
    }
  }

  Future<Null> _nextPage() async {
    _pageController.nextPage(
      curve: Curves.linear,
      duration: kTabScrollDuration,
    );
  }

  Future<Null> _prevPage() async {
    _pageController.previousPage(
      curve: Curves.linear,
      duration: kTabScrollDuration,
    );
  }

  void _changePageByDate(DateTime date) {
    var index = getIndexFromDate(date);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
        headerSliverBuilder: (_, bool h) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: 0.1,
              ),
            ),
          ];
        },
        body: PageView.custom(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildPageView(index);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showChooseSectionBottomSheet(
            getDateFromIndex(_pageController.page.toInt())),
        icon: Icon(Icons.add),
        label: Text("Add to diary".toUpperCase()),
      ),
    );
  }

  Widget _buildPageView(int index) {
    final foodState = _foodBloc.state;
    final recipeState = _recipeBloc.state;
    if (foodState is FoodLoaded && recipeState is RecipesLoaded) {
      final recipes = recipeState.recipes;
      final foods = foodState.foods;
      return BlocBuilder<DailyMealBloc, DailyMealState>(
        builder: (context, state) {
          if (state is DailyMealsLoaded) {
            final dailyMeals = state.dailyMeals;
            final todayMeals =
                dailyMeals.where((e) => e.date == getDateFromIndex(index));
            final nutrition =
                _calculateSummaryNutrition(todayMeals, foods, recipes);
            final water = _calculateWater(todayMeals);
            return BlocBuilder<GoalBloc, GoalState>(
              builder: (context, state) {
                if (state is GoalsLoaded) {
                  final goals = state.goals;
                  final currentDayGoal =
                      _getGoalByDate(goals, getDateFromIndex(index));
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_left),
                            onPressed: () => _prevPage(),
                          ),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            onPressed: () => _nextPage(),
                          )
                        ],
                        title: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () => _selectDate(context),
                          child: Text(
                            _pageTitle,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        expandedHeight: 350,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: AppBar().preferredSize.height,
                                ),
                                Expanded(
                                  child: DonutChart(
                                    showValue: double.parse(nutrition.calories),
                                    maxValue: 3000,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Calories Intake",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "OpenSans",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            nutrition.calories,
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: "OpenSans",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {},
                                    ),
                                    FlatButton(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Water Intake",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "OpenSans",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${(water / 1000.0).toStringAsFixed(2)}L",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: "OpenSans",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {},
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 15,
                                  color: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "FATS",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "${nutrition.fats}mg",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {},
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "CARB",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "${nutrition.carbohydrates}mg",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {},
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "PROTEIN",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "${nutrition.protein}mg",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            currentDayGoal != null
                                ? _buildGoalCard(currentDayGoal.items,
                                    getDateFromIndex(index), nutrition, water)
                                : Container(),
                            Column(
                              children: <Widget>[
                                _buildDiarySection(
                                  date: getDateFromIndex(index),
                                  section: DailyMealSection.BREAKFAST,
                                  foods: foods,
                                  recipes: recipes,
                                  todayMeals: todayMeals,
                                ),
                                _buildDiarySection(
                                  date: getDateFromIndex(index),
                                  section: DailyMealSection.LUNCH,
                                  foods: foods,
                                  recipes: recipes,
                                  todayMeals: todayMeals,
                                ),
                                _buildDiarySection(
                                  date: getDateFromIndex(index),
                                  section: DailyMealSection.DINNER,
                                  foods: foods,
                                  recipes: recipes,
                                  todayMeals: todayMeals,
                                ),
                                _buildDiarySection(
                                  date: getDateFromIndex(index),
                                  section: DailyMealSection.SNACK,
                                  foods: foods,
                                  recipes: recipes,
                                  todayMeals: todayMeals,
                                ),
                              ],
                            ),
                            Container(height: 80),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      );
    } else {
      return Expanded(
        child: Center(child: Text("Cannot load diary")),
      );
    }
  }

  Widget _buildDiarySection({
    final DateTime date,
    final String section,
    final Iterable<DailyMeal> todayMeals,
    final List<Food> foods,
    final List<Recipe> recipes,
  }) =>
      Builder(
        builder: (context) {
          try {
            final List<MealItem> items =
                todayMeals.firstWhere((e) => e.section == section).items;
            /* if (items.length == 0) {
              return MealNoItemCard(
                title: section,
                onTap: () => _showBottomSheet(todayMeals, date, section),
              );
            } */
            return Center(
              child: DailyMealItemCard(
                items: items,
                recipes: recipes,
                foods: foods,
                title: section,
                onRemoveButtonPressed: (i) => _showDeleteDialog().then((r) =>
                    r ? _removeMealItem(todayMeals, date, section, i) : null),
                onAddButtonPressed: () =>
                    _showBottomSheet(todayMeals, date, section),
              ),
            );
          } catch (err) {
            return MealNoItemCard(
              title: section,
              onTap: () => _showBottomSheet(todayMeals, date, section),
            );
          }
        },
      );

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dContext) {
        return AlertDialog(
          title: Text('Confirm delete'),
          content: Text('Do you want delete this item?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'.toUpperCase()),
              onPressed: () => Navigator.pop(dContext, false),
            ),
            FlatButton(
              child: Text('Delete'.toUpperCase()),
              onPressed: () {
                Navigator.pop(dContext, true);
              },
            )
          ],
        );
      },
    );
  }

  NutritionInfo _calculateSummaryNutrition(
    Iterable<DailyMeal> todayMeals,
    List<Food> foods,
    List<Recipe> recipes,
  ) {
    var sum = NutritionInfo.empty();
    if (todayMeals != null) {
      todayMeals.forEach((f) {
        sum += f.getSummaryNutrition(foods, recipes);
      });
    }
    return sum;
  }

  double _calculateWater(
    Iterable<DailyMeal> todayMeals,
  ) {
    var sum = 0.0;
    if (todayMeals != null) {
      todayMeals.forEach((f) {
        sum += f.getWater();
      });
    }
    return sum;
  }

  Goal _getGoalByDate(Iterable<Goal> goals, DateTime date) {
    try {
      final beforeGoals = goals
          .where((g) =>
              g.startDate.isBefore(date) || g.startDate.isAtSameMomentAs(date))
          .toList();
      beforeGoals.sort();
      return beforeGoals.last;
    } catch (err) {
      return null;
    }
  }

  Widget _buildGoalCard(Iterable<GoalItem> goalItems, DateTime currentDate,
      NutritionInfo nutrition, double water) {
    return Card(
      elevation: 0,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[400]),
      ),
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: Text(
              "Your Goal",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "OpenSans"),
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: goalItems.length,
            itemBuilder: (_, int index) {
              switch (goalItems.elementAt(index).type) {
                case GoalItemType.CALORIES:
                  return _buildGoalListItem(goalItems.elementAt(index),
                      nutrition.calories, currentDate);
                case GoalItemType.WATER:
                  return _buildGoalListItem(goalItems.elementAt(index),
                      water.toString(), currentDate);
                case GoalItemType.PROTEIN:
                  return _buildGoalListItem(goalItems.elementAt(index),
                      nutrition.protein, currentDate);
                case GoalItemType.CARBOHYDRATE:
                  return _buildGoalListItem(goalItems.elementAt(index),
                      nutrition.carbohydrates, currentDate);
                case GoalItemType.LIPID:
                  return _buildGoalListItem(
                      goalItems.elementAt(index), nutrition.fats, currentDate);
                default:
                  return Container();
              }
            },
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit your goal'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditGoalScreen(
                        startDate: currentDate,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalListItem(GoalItem item, String value, DateTime currentDate) {
    final action = _goalActions[item.type];
    var goalState = _GoalState.NONE;
    if (currentDate.isBefore(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      if (item.max != null && item.min != null) {
        if (double.parse(value) >= double.parse(item.min) &&
            double.parse(value) <= double.parse(item.max)) {
          goalState = _GoalState.FINISHED;
        } else {
          goalState = _GoalState.FAILED;
        }
      } else if (item.max == null && item.min != null) {
        if (double.parse(value) >= double.parse(item.min)) {
          goalState = _GoalState.FINISHED;
        } else {
          goalState = _GoalState.FAILED;
        }
      } else if (item.max != null && item.min == null) {
        if (double.parse(value) <= double.parse(item.max)) {
          goalState = _GoalState.FINISHED;
        } else {
          goalState = _GoalState.FAILED;
        }
      } else {
        goalState = _GoalState.NONE;
      }
    } else {
      if (item.max != null && item.min != null) {
        if (double.parse(value) < double.parse(item.min)) {
          goalState = _GoalState.DOING;
        } else if (double.parse(value) >= double.parse(item.min) &&
            double.parse(value) <= double.parse(item.max)) {
          goalState = _GoalState.FINISHED;
        } else {
          goalState = _GoalState.FAILED;
        }
      } else if (item.max == null && item.min != null) {
        if (double.parse(value) < double.parse(item.min)) {
          goalState = _GoalState.DOING;
        } else {
          goalState = _GoalState.FINISHED;
        }
      } else if (item.max != null && item.min == null) {
        if (double.parse(value) <= double.parse(item.max)) {
          goalState = _GoalState.FINISHED;
        } else {
          goalState = _GoalState.FAILED;
        }
      } else {
        goalState = _GoalState.NONE;
      }
    }

    Widget icon;
    Widget status;

    switch (goalState) {
      case _GoalState.DOING:
        icon = Icon(
          Icons.panorama_fish_eye,
          color: Colors.green,
          size: 12,
        );
        status = Text(
          '(Doing)',
          style:
              TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
        );
        break;
      case _GoalState.FINISHED:
        icon = Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 12,
        );
        status = Text(
          '(Finished)',
          style:
              TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
        );
        break;
      case _GoalState.FAILED:
        icon = Icon(
          Icons.cancel,
          color: Colors.red,
          size: 12,
        );
        status = Text(
          '(Failed)',
          style:
              TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
        );
        break;
      default:
        icon = Icon(
          Icons.pause_circle_filled,
          color: Colors.yellow,
          size: 12,
        );
        status = Text(
          '',
          style:
              TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
        );
        break;
    }

    return Builder(
      builder: (context) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[icon],
                ),
                Flexible(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        if (item.min != null && item.max != null)
                          return Text(
                            "\t${action.action} from ${item.min} to ${item.max} ${action.unit} ${item.type}. ",
                          );
                        if (item.min != null && item.max == null)
                          return Text(
                              "\t${action.action} more than ${item.min} ${action.unit} ${item.type}. ");
                        else if (item.min == null && item.max != null)
                          return Text(
                              "\t${action.action} less than ${item.min} ${action.unit} ${item.type}. ");
                        else
                          return Container();
                      },
                    ),
                    status,
                  ],
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showChooseSectionBottomSheet(DateTime date) async {
    final state = _dailyMealBloc.state;
    if (state is DailyMealsLoaded) {
      final todayMeals = state.dailyMeals.where((e) => e.date == date);
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text("Breakfast"),
                onTap: () => Navigator.pop(context, DailyMealSection.BREAKFAST),
              ),
              ListTile(
                title: Text("Lunch"),
                onTap: () => Navigator.pop(context, DailyMealSection.LUNCH),
              ),
              ListTile(
                title: Text("Dinner"),
                onTap: () => Navigator.pop(context, DailyMealSection.DINNER),
              ),
              ListTile(
                title: Text("Snack"),
                onTap: () => Navigator.pop(context, DailyMealSection.SNACK),
              ),
            ],
          ),
        ),
      ).then((item) =>
          item != null ? _showBottomSheet(todayMeals, date, item) : null);
    }
  }

  Future<void> _showBottomSheet(
      Iterable<DailyMeal> todayMeals, DateTime date, String section) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: Wrap(
          children: <Widget>[
            ListTile(
              title: Text("Add water"),
              onTap: () => _onAddWaterTapped(todayMeals, date, section),
            ),
            ListTile(
              title: Text("Add meal"),
              onTap: () => _onAddMealTapped(todayMeals, date, section),
            ),
            ListTile(
              title: Text("Add food"),
              onTap: () => _onAddFoodTapped(todayMeals, date, section),
            ),
            ListTile(
              title: Text("Add recipe"),
              onTap: () => _onAddRecipeTapped(todayMeals, date, section),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onAddFoodTapped(
      Iterable<DailyMeal> todayMeals, DateTime date, String section) async {
    Navigator.pop(context);
    Navigator.pushNamed(context, FoodSearchScreen.routeName,
            arguments: FoodSearchArgument(action: FoodAction.ADD_TO_DIARY))
        .then((result) {
      if (result is PopWithResults) {
        if (result.toPage == "/") {
          final item = MealItem(
            result.results['foodId'] as String,
            MealItemType.FOOD,
            result.results['quantity'] as String,
          );
          _addMealItem(todayMeals, date, section, item);
        }
      }
    });
  }

  Future<void> _onAddWaterTapped(
      Iterable<DailyMeal> todayMeals, DateTime date, String section) async {
    Navigator.pop(context);
    final item = MealItem(
      'WATER',
      MealItemType.WATER,
      '250',
    );
    _addMealItem(todayMeals, date, section, item);
  }

  Future<void> _onAddRecipeTapped(
      Iterable<DailyMeal> todayMeals, DateTime date, String section) async {
    Navigator.pop(context);
    Navigator.pushNamed(context, RecipeSearchScreen.routeName,
            arguments: RecipeSearchArgument(action: RecipeAction.ADD_TO_DIARY))
        .then((result) {
      if (result is PopWithResults) {
        if (result.toPage == "/") {
          final item = MealItem(
            result.results["recipeId"] as String,
            MealItemType.RECIPE,
            result.results["quantity"] as String,
          );
          _addMealItem(todayMeals, date, section, item);
        }
      }
    });
  }

  Future<void> _onAddMealTapped(
      Iterable<DailyMeal> todayMeals, DateTime date, String section) async {
    Navigator.pop(context);
    Navigator.pushNamed(context, MealSearchScreen.routeName,
            arguments: MealSearchArgument(action: MealAction.ADD_TO_DIARY))
        .then((r) {
      if (r is PopWithResults) {
        if (r.toPage == "/") {
          final items = r.results['items'] as List<MealItem>;
          _addMultipleMealItems(todayMeals, date, section, items);
        }
      }
    });
  }

  void _addMealItem(Iterable<DailyMeal> todayMeals, DateTime date,
      String section, MealItem item) {
    DailyMeal oldMeal;
    try {
      oldMeal =
          todayMeals.firstWhere((t) => t.section == section && t.date == date);
    } catch (err) {
      print(err);
    }
    if (oldMeal == null) {
      DailyMeal newMeal =
          DailyMeal(section: section, date: date, items: [item]);
      setState(() {
        _dailyMealBloc.add(AddDailyMeal(newMeal));
      });
    } else {
      final newMealItems = oldMeal.items;
      newMealItems.add(item);
      DailyMeal newMeal =
          oldMeal.copyWith(section: section, date: date, items: newMealItems);
      setState(() {
        _dailyMealBloc.add(UpdateDailyMeal(newMeal));
      });
    }
  }

  void _addMultipleMealItems(Iterable<DailyMeal> todayMeals, DateTime date,
      String section, Iterable<MealItem> items) {
    if (items == null) return;
    DailyMeal oldMeal;
    try {
      oldMeal =
          todayMeals.firstWhere((t) => t.section == section && t.date == date);
    } catch (err) {
      print(err);
    }
    if (oldMeal == null) {
      DailyMeal newMeal = DailyMeal(section: section, date: date, items: items);
      setState(() {
        _dailyMealBloc.add(AddDailyMeal(newMeal));
      });
    } else {
      final newMealItems = oldMeal.items;
      newMealItems.addAll(items);
      DailyMeal newMeal =
          oldMeal.copyWith(section: section, date: date, items: newMealItems);
      setState(() {
        _dailyMealBloc.add(UpdateDailyMeal(newMeal));
      });
    }
  }

  void _removeMealItem(Iterable<DailyMeal> todayMeals, DateTime date,
      String section, MealItem mealItem) {
    DailyMeal oldMeal;
    try {
      oldMeal =
          todayMeals.firstWhere((t) => t.section == section && t.date == date);
      final newMealItems = oldMeal.items;
      newMealItems.remove(mealItem);
      if (newMealItems.length == 0) {
        setState(() {
          _dailyMealBloc.add(DeleteDailyMeal(oldMeal));
        });
      } else {
        DailyMeal newMeal =
            oldMeal.copyWith(section: section, date: date, items: newMealItems);
        setState(() {
          _dailyMealBloc.add(UpdateDailyMeal(newMeal));
        });
      }
    } catch (err) {
      print(err);
    }
  }

  static final Map<String, GoalAction> _goalActions = {
    GoalItemType.CALORIES: GoalAction('Eat', 'kcal'),
    GoalItemType.WATER: GoalAction('Drink', 'ml'),
    GoalItemType.PROTEIN: GoalAction('Eat', 'mg'),
    GoalItemType.LIPID: GoalAction('Eat', 'mg'),
    GoalItemType.CARBOHYDRATE: GoalAction('Eat', 'mg')
  };
}

enum _GoalState { DOING, FINISHED, FAILED, NONE }

class GoalAction {
  final String action;
  final String unit;
  const GoalAction(this.action, this.unit);
}
