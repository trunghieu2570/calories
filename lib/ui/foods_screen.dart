import 'package:cached_network_image/cached_network_image.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_bloc.dart';
import 'package:calories/blocs/favorite_recipes/favorite_recipes_state.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_state.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_state.dart';
import 'package:calories/models/meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/food/create_edit_food_screen.dart';
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
        onPressed: _onPressedCreateMealButton,
        tooltip: 'Tạo đồ bữa ăn mới',
        icon: Icon(Icons.add),
        label: Text("Create meal".toUpperCase()),
      ),
      FloatingActionButton.extended(
        onPressed: _onPressedCreateRecipeButton,
        tooltip: 'Tạo công thức nấu ăn mới',
        icon: Icon(Icons.add),
        label: Text("Create recipe".toUpperCase()),
      ),
      FloatingActionButton.extended(
        onPressed: _onPressedCreateFoodButton,
        tooltip: 'Tạo thực phẩm mới',
        icon: Icon(Icons.add),
        label: Text("Create food".toUpperCase()),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
        headerSliverBuilder: (_, bool) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: true,
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
                indicatorColor: Colors.white,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                indicatorWeight: 3,
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
            _buildMealsView(),
            _buildRecipesView(),
            _buildFoodsView(),
          ],
        ),
      ),
      floatingActionButton: AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 100),
          child: _floatingButtons.elementAt(_selectedTab)),
    );
  }

  Widget _buildFoodsView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
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
              if (favoriteFoods.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text("No favorite food")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    try {
                      final favoriteFood = foods.firstWhere(
                          (food) => food.id == favoriteFoods[index]);
                      return _buildItemWidget(
                          context: context,
                          onTap: () => Navigator.pushNamed(
                              context, FoodDetailScreen.routeName,
                              arguments:
                                  FoodDetailArgument(food: favoriteFood)),
                          photoUrl: favoriteFood.photoUrl,
                          title: favoriteFood.name,
                          subtitle: favoriteFood.brand);
                    } catch (ex) {
                      print(ex);
                      return Container();
                    }
                  },
                  childCount: favoriteFoods.length,
                ),
              );
            }
            return SliverFillRemaining(
              child: Center(child: Text("Cannot load favorite food")),
            );
          }),
        ],
      );

  Widget _buildMealsView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
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
              if (favoriteMeals.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text("No favorite meal")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    try {
                      final favoriteMeal =
                          meals.firstWhere((r) => r.id == favoriteMeals[index]);
                      return _buildItemWidget(
                        context: context,
                        title: favoriteMeal.name,
                        photoUrl: favoriteMeal.photoUrl,
                        onTap: () => Navigator.pushNamed(
                          context,
                          MealDetailScreen.routeName,
                          arguments: MealDetailArgument(meal: favoriteMeal),
                        ),
                      );
                    } catch (ex) {
                      print(ex);
                      return Container();
                    }
                  },
                  childCount: favoriteMeals.length,
                ),
              );
            }
            return SliverFillRemaining(
              child: Center(child: Text("Cannot load favorite meal")),
            );
          }),
        ],
      );

  Widget _buildRecipesView() => CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
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
              if (favoriteRecipes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text("No favorite recipe")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    try {
                      final favoriteRecipe = recipes
                          .firstWhere((r) => r.id == favoriteRecipes[index]);
                      return _buildItemWidget(
                        context: context,
                        title: favoriteRecipe.title,
                        subtitle: favoriteRecipe.numberOfServings.toString() +
                            " serving(s)",
                        photoUrl: favoriteRecipe.photoUrl,
                        onTap: () => Navigator.pushNamed(
                            context, RecipeDetailScreen.routeName,
                            arguments:
                                RecipeDetailArgument(recipe: favoriteRecipe)),
                      );
                    } catch (err) {
                      return Container();
                    }
                  },
                  childCount: favoriteRecipes.length,
                ),
              );
            }
            return SliverFillRemaining(
              child: Center(child: Text("Cannot load favorite recipe")),
            );
          }),
        ],
      );

  Widget _buildItemWidget(
      {BuildContext context,
      String title,
      String subtitle,
      String photoUrl,
      Function() onTap}) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: 70,
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withAlpha(40),
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Ink.image(
                width: 100,
                image: CachedNetworkImageProvider(
                    photoUrl ?? 'https://via.placeholder.com/100x70?text=PHOTO',
                    errorListener: () => print('no image')),
                fit: BoxFit.cover,
              ),
              Expanded(
                child: ListTile(
                  title: title != null ? Text(title) : null,
                  subtitle: subtitle != null ? Text(subtitle) : null,
                ),
              ),
            ],
          ),
        ),
      ),
      elevation: 0,
    );
  }
}
