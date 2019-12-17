import 'package:calories/blocs/daily_meals/daily_meals_bloc.dart';
import 'package:calories/blocs/daily_meals/daily_meals_state.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/blocs/goals/goals_bloc.dart';
import 'package:calories/blocs/goals/goals_state.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/models.dart';
import 'package:calories/ui/widgets/donut_chart.dart';
import 'package:calories/ui/widgets/meal_item_card_widget.dart';
import 'package:calories/ui/widgets/meal_no_item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../util.dart';

class DiaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DiaryScreenState();
}

class DiaryScreenState extends State<DiaryScreen> {
  String _pageTitle = "Hôm nay";
  PageController _pageController;
  FoodBloc _foodBloc;
  RecipeBloc _recipeBloc;

  @override
  void initState() {
    super.initState();
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _pageController = new PageController(
      initialPage: getIndexFromDate(DateTime.now()),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      var todayIndex = getIndexFromDate(DateTime.now());
      print("page $todayIndex changed to $index");
      if (index == todayIndex) {
        _pageTitle = "Hôm nay";
      } else if (index == todayIndex - 1) {
        _pageTitle = "Hôm qua";
      } else if (index == todayIndex + 1) {
        _pageTitle = "Ngày mai";
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
      body: NestedScrollView(
        headerSliverBuilder: (_, bool h) {
          return <Widget>[
            SliverToBoxAdapter(child: Container(height: 0.1,),),
            /*SliverAppBar(
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
              expandedHeight: 400,
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
                        child: DonutChart(),
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
                                  "CHẤT BÉO",
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
                                  "TINH BỘT",
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
                                  "CHẤT ĐẠM",
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
            ),*/
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
        onPressed: () {},
        tooltip: 'Thêm vào nhật ký',
        icon: Icon(Icons.add),
        label: Text("THÊM"),
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
                      child: DonutChart(value: 40,animate: true,),
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
                                "CHẤT BÉO",
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
                                "TINH BỘT",
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
                                "CHẤT ĐẠM",
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
                _buildGoalCard(DateTime(1900).add(Duration(days: index))),
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
                          .where((e) => e.date == getDateString(index));
                      return Column(
                        children: <Widget>[
                          _buildDiarySection(
                            section: DailyMealSection.BREAKFAST,
                            foods: foods,
                            recipes: recipes,
                            todayMeals: todayMeals,
                          ),
                          _buildDiarySection(
                            section: DailyMealSection.LUNCH,
                            foods: foods,
                            recipes: recipes,
                            todayMeals: todayMeals,
                          ),
                          _buildDiarySection(
                            section: DailyMealSection.DINNER,
                            foods: foods,
                            recipes: recipes,
                            todayMeals: todayMeals,
                          ),
                          _buildDiarySection(
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
            return Center(
              child: MealItemCard(
                  items: items, recipes: recipes, foods: foods, title: section),
            );
          } catch (StateError) {
            return MealNoItemCard(title: section);
          }
        },
      );

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
                      "Mục tiêu hằng ngày ${goal.startDate}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: "OpenSans"),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.panorama_fish_eye,
                            color: Colors.green,
                            size: 12,
                          ),
                          Text("\tUống đủ 2 lít nước."),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 12,
                          ),
                          Text("\tĂn đủ 2600 calo."),
                          Text(
                            "\t(Đã hoàn thành)",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.panorama_fish_eye,
                            color: Colors.green,
                            size: 12,
                          ),
                          Text("\tĂn dưới 60 gram chất béo"),
                          Text(
                            "\t(25g còn lại)",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Bỏ qua'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                        FlatButton(
                          child: const Text('Chỉnh sửa mục tiêu'),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } catch (StateError) {
            return Container();
          }
        } else {
          return Container();
        }
      });
}
