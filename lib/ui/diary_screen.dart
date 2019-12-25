import 'package:calories/blocs/daily_meals/daily_meals_bloc.dart';
import 'package:calories/blocs/daily_meals/daily_meals_event.dart';
import 'package:calories/blocs/daily_meals/daily_meals_state.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/blocs/goals/goals_bloc.dart';
import 'package:calories/blocs/goals/goals_state.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/screens/goal/edit_goal_screen.dart';
import 'package:calories/ui/widgets/donut_chart.dart';
import 'package:calories/ui/widgets/meal_item_card_widget.dart';
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
      print("page $todayIndex changed to $index");
      if (index == todayIndex) {
        _pageTitle = "Today";
      } else if (index == todayIndex - 1) {
        _pageTitle = "Yesterday";
      } else if (index == todayIndex + 1) {
        _pageTitle = "Tomorrow";
      } else {
        _pageTitle = getDateString(index);
      }
      print(" Page title: $_pageTitle");
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
        tooltip: 'Thêm vào nhật ký',
        icon: Icon(Icons.add),
        label: Text("Add to diary".toUpperCase()),
      ),
    );
  }

  Widget _buildPageView(int index) => CustomScrollView(
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
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: AppBar().preferredSize.height,
                    ),
                    Expanded(
                      child: DonutChart(
                        value: 40,
                        animate: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "2630",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: "OpenSans",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Calo đã nạp",
                                style: TextStyle(
                                  fontSize: 18,
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
                                "2.5L",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: "OpenSans",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Nước đã uống",
                                style: TextStyle(
                                  fontSize: 18,
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
                      height: 20,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "FATS",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "60g",
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "CARB",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "210g",
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "PROTEIN",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "60g",
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
                _buildGoalCard(getDateFromIndex(index)),
                BlocBuilder<DailyMealBloc, DailyMealState>(
                  builder: (context, state) {
                    final foodState = _foodBloc.state;
                    final recipeState = _recipeBloc.state;
                    if (state is DailyMealsLoaded &&
                        foodState is FoodLoaded &&
                        recipeState is RecipesLoaded) {
                      final recipes = recipeState.recipes;
                      final foods = foodState.foods;
                      final dailyMeals = state.dailyMeals;
                      final todayMeals = dailyMeals
                          .where((e) => e.date == getDateFromIndex(index));
                      return Column(
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
                      );
                    } else {
                      return Expanded(
                        child: Center(child: Text("Cannot load diary")),
                      );
                    }
                  },
                ),
                Container(height: 80),
              ],
            ),
          ),
        ],
      );

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
        });
  }

  Widget _buildGoalCard(final DateTime date) =>
      BlocBuilder<GoalBloc, GoalState>(builder: (context, state) {
        if (state is GoalsLoaded) {
          final goals = state.goals;
          final beforeGoals = goals
              .where((g) =>
                  g.startDate.isBefore(date) ||
                  g.startDate.isAtSameMomentAs(date))
              .toList();
          beforeGoals.sort();
          try {
            final goal = beforeGoals.last;
            final goalItems = goal.items;
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
                      return _buildGoalListItem(goalItems[index]);
                    },
                  ),
                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Edit your goal'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditGoalScreen(
                                startDate: date,
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
          } catch (err) {
            return Container();
          }
        } else {
          return Container();
        }
      });

  Widget _buildGoalListItem(GoalItem item) {
    final action = _goalActions[item.type];
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.panorama_fish_eye,
                  color: Colors.green,
                  size: 12,
                ),
              ],
            ),
            Flexible(
              child: Builder(builder: (context) {
                if (item.min != null && item.max != null)
                  return Text(
                    "\t${action.action} from ${item.min} to ${item.max} ${action.unit} ${item.type}.",
                  );
                if (item.min != null && item.max == null)
                  return Text(
                      "\t${action.action} more than ${item.min} ${action.unit} ${item.type}.");
                else if (item.min == null && item.max != null)
                  return Text(
                      "\t${action.action} less than ${item.min} ${action.unit} ${item.type}.");
                else
                  return Container();
              }),
            ),
          ],
        ),
      ),
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
      _dailyMealBloc.add(AddDailyMeal(newMeal));
    } else {
      final newMealItems = oldMeal.items;
      newMealItems.add(item);
      DailyMeal newMeal =
          oldMeal.copyWith(section: section, date: date, items: newMealItems);
      _dailyMealBloc.add(UpdateDailyMeal(newMeal));
    }
  }

  void _removeMealItem(Iterable<DailyMeal> todayMeals, DateTime date,
      String section, String itemId) {
    DailyMeal oldMeal;
    try {
      oldMeal =
          todayMeals.firstWhere((t) => t.section == section && t.date == date);
      final newMealItems = oldMeal.items;
      newMealItems.removeWhere((t) => t.itemId == itemId);
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
    GoalItemType.WATER: GoalAction('Drink', 'litter'),
    GoalItemType.PROTEIN: GoalAction('Eat', 'mg'),
    GoalItemType.LIPID: GoalAction('Eat', 'mg'),
    GoalItemType.CARBOHYDRATE: GoalAction('Eat', 'mg')
  };
}

class GoalAction {
  final String action;
  final String unit;
  const GoalAction(this.action, this.unit);
}
