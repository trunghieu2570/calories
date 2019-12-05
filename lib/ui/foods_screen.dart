import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_state.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/food/create_food_screen.dart';
import 'screens/food/food_detail_screen.dart';
import 'screens/food/food_search_screen.dart';
import 'screens/meal/create_meal_screen.dart';
import 'screens/meal/meal_detail_screen.dart';
import 'screens/meal/meal_search_screen.dart';
import 'screens/recipe/create_recipe_screen.dart';
import 'screens/recipe/recipe_detail_screen.dart';
import 'screens/recipe/recipe_search_screen.dart';

class FoodsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FoodsScreenState();
}

class FoodsScreenState extends State<FoodsScreen>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  TabController _tabController;
  FoodBloc _foodBloc;
  RecipeBloc _recipeBloc;
  MealBloc _mealBloc;
  MaterialColor _color = Colors.red;

  Future<void> _onPressedCreateFoodButton() async {
    return Navigator.pushNamed(context, CreateFoodScreen.routeName);
  }

  Future<void> _onPressedCreateRecipeButton() async {
    return Navigator.pushNamed(context, CreateRecipeScreen.routeName);
  }

  Future<void> _onPressedCreateMealButton() async {
    return Navigator.pushNamed(context, CreateMealScreen.routeName);
  }

  void _onTabIndexChanged() {
    setState(() {
      _selectedTab = _tabController.index;
      switch (_selectedTab) {
        case 0:
          _color = Colors.red;
          break;
        case 1:
          _color = Colors.green;
          break;
        case 2:
          _color = Colors.blue;
          break;
      }
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabIndexChanged);
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _mealBloc = BlocProvider.of<MealBloc>(context);
    super.initState();
  }

  Future<void> onSearchIconPressed(BuildContext context) async {
    switch (_selectedTab) {
      case 0:
        return Navigator.pushNamed(context, MealSearchScreen.routeName);
      case 1:
        return Navigator.pushNamed(context, RecipeSearchScreen.routeName);
      case 2:
        return Navigator.pushNamed(context, FoodSearchScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _floatingButtons = [
      FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: _onPressedCreateMealButton,
        tooltip: 'Tạo đồ bữa ăn mới',
        icon: Icon(Icons.add),
        label: Text("TẠO BỮA ĂN"),
      ),
      FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: _onPressedCreateRecipeButton,
        tooltip: 'Tạo công thức nấu ăn mới',
        icon: Icon(Icons.add),
        label: Text("TẠO CÔNG THỨC"),
      ),
      FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: _onPressedCreateFoodButton,
        tooltip: 'Tạo thực phẩm mới',
        icon: Icon(Icons.add),
        label: Text("TẠO THỰC PHẨM"),
      ),
    ];
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, bool) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: true,
              backgroundColor: _color,
              title: Text(
                "Favorites",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    tooltip: "Tìm kiếm",
                    onPressed: () => onSearchIconPressed(context)),
                IconButton(
                  icon: Icon(Icons.mic_none),
                  tooltip: "Tìm kiếm bằng giọng nói",
                  onPressed: () => {},
                ),
              ],
              bottom: TabBar(
                //isScrollable: true,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: 'Meals',
                  ),
                  Tab(
                    text: 'Recipes',
                  ),
                  Tab(
                    text: 'Foods',
                  )
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            buildMealsView(),
            buildRecipesView(),
            buildFoodsView(),
          ],
        ),
      ),
      floatingActionButton: _floatingButtons.elementAt(_selectedTab),
    );
  }

  Widget buildFoodsView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              /*ListTile(
                onTap: () => {},
                title: Text(
                  'Danh mục các loại thực phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => new Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://placeimg.com/640/480/any?dummy=$index`'),
                                fit: BoxFit.fill)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                title: Text(
                                  'Title',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(0),
                              ),
                            )
                          ],
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                ),
              ),*/
              ListTile(
                title: Text(
                  'Your favorite foods',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'OpenSans'),
                ),
                trailing: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          BlocBuilder<FavoriteFoodsBloc, FavoriteFoodsState>(
              builder: (context, state) {
            final FoodState foodState = _foodBloc.state;
            if (state is FavoriteFoodsLoaded && foodState is FoodLoaded) {
              final favoriteFoods = state.foodIds;
              final foods = foodState.foods;
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  final currentFavoriteFood = favoriteFoods[index];
                  final favoriteFood = foods
                      .where((food) => food.id == currentFavoriteFood)
                      .first;
                  return Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 70,
                      child: ListTile(
                        title: Text(favoriteFood.name),
                        onTap: () => Navigator.pushNamed(
                            context, FoodDetailScreen.routeName,
                            arguments: FoodDetailArgument(food: favoriteFood)),
                        subtitle: Text(favoriteFood.brand),
                      ),
                    ),
                  );
                },
                childCount: favoriteFoods.length,
              ));
            }
            return SliverToBoxAdapter(
              child: Text("You have no favorite food"),
            );
          }),
        ],
      );

  Widget buildMealsView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              /*ListTile(
                onTap: () => {},
                title: Text(
                  'Được lựa chọn dành cho bạn',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      width: 150,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://placeimg.com/640/480/any?dummy=$index'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: ListTile(
                              title: Text('Title'),
                              subtitle: Text('Subtitle'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                ),
              ),*/
              ListTile(
                title: Text(
                  'Your favorite meals',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'OpenSans'),
                ),
                trailing: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          BlocBuilder<FavoriteMealsBloc, FavoriteMealsState>(
              builder: (context, state) {
            final MealState mealState = _mealBloc.state;
            if (state is FavoriteMealsLoaded && mealState is MealsLoaded) {
              final favoriteMeals = state.mealIds;
              final meals = mealState.meals;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    try {
                      final favoriteMeal = meals
                          .where((r) => r.id == favoriteMeals[index])
                          .first;
                      return Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          height: 70,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image(
                                image: NetworkImage(
                                    'https://placeimg.com/640/480/any'),
                                fit: BoxFit.fill,
                              ),
                              Expanded(
                                child: ListTile(
                                  onTap: () => Navigator.pushNamed(
                                      context, RecipeDetailScreen.routeName,
                                      arguments: MealDetailArgument(
                                          meal: favoriteMeal)),
                                  title: Text(favoriteMeal.name),
                                ),
                              ),
                            ],
                          ),
                        ),
                        elevation: 1,
                      );
                    } catch (StateError) {
                      return Container();
                    }
                  },
                  childCount: favoriteMeals.length,
                ),
              );
            }
            return SliverToBoxAdapter(
              child: Text("No favorite"),
            );
          }),
        ],
      );

  Widget buildRecipesView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              /*ListTile(
                onTap: () => {},
                title: Text(
                  'Công thức nấu ăn từ cộng đồng',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => new Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://placeimg.com/640/480/any'),
                                fit: BoxFit.fill)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: ListTile(
                                title: Text(
                                  'Title',
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Subtitle',
                                  style: TextStyle(color: Colors.white38),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(0),
                              ),
                            )
                          ],
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                ),
              ),*/
              ListTile(
                title: Text(
                  'Your favorite recipes',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'OpenSans'),
                ),
                trailing: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                ),
              ),
            ]),
          ),
          BlocBuilder<FavoriteRecipesBloc, FavoriteRecipesState>(
              builder: (context, state) {
            final RecipeState recipeState = _recipeBloc.state;
            if (state is FavoriteRecipesLoaded &&
                recipeState is RecipesLoaded) {
              final favoriteRecipes = state.recipeIds;
              final recipes = recipeState.recipes;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    try {
                      final favoriteRecipe = recipes
                          .where((r) => r.id == favoriteRecipes[index])
                          .first;
                      return Card(
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          height: 70,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image(
                                image: NetworkImage(
                                    'https://placeimg.com/640/480/any'),
                                fit: BoxFit.fill,
                              ),
                              Expanded(
                                child: ListTile(
                                  onTap: () => Navigator.pushNamed(
                                      context, RecipeDetailScreen.routeName,
                                      arguments: RecipeDetailArgument(
                                          recipe: favoriteRecipe)),
                                  title: Text(favoriteRecipe.title),
                                  subtitle: Text(favoriteRecipe.numberOfServings
                                          .toString() +
                                      " serving(s)"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        elevation: 1,
                      );
                    } catch (StateError) {
                      return Container();
                    }
                  },
                  childCount: favoriteRecipes.length,
                ),
              );
            }
            return SliverToBoxAdapter(
              child: Text("No favorite"),
            );
          }),
        ],
      );
}
