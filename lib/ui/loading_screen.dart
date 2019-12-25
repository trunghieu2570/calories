
import 'package:calories/blocs/daily_meals/daily_meals_bloc.dart';
import 'package:calories/blocs/daily_meals/daily_meals_event.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/favorite_recipes/bloc.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_event.dart';
import 'package:calories/blocs/goals/goals_bloc.dart';
import 'package:calories/blocs/goals/goals_event.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/recipe_bloc.dart';
import 'package:calories/blocs/recipe/recipe_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  FoodBloc _foodBloc;
  RecipeBloc _recipeBloc;
  MealBloc _mealBloc;
  GoalBloc _goalBloc;
  DailyMealBloc _dailyMealBloc;
  FavoriteFoodsBloc _favoriteFoodsBloc;
  FavoriteMealsBloc _favoriteMealsBloc;
  FavoriteRecipesBloc _favoriteRecipesBloc;

  @override
  void initState() {
    _foodBloc = BlocProvider.of<FoodBloc>(context);
    _recipeBloc = BlocProvider.of<RecipeBloc>(context);
    _mealBloc = BlocProvider.of<MealBloc>(context);
    _goalBloc = BlocProvider.of<GoalBloc>(context);
    _dailyMealBloc = BlocProvider.of<DailyMealBloc>(context);
    _favoriteMealsBloc = BlocProvider.of<FavoriteMealsBloc>(context);
    _favoriteFoodsBloc = BlocProvider.of<FavoriteFoodsBloc>(context);
    _favoriteRecipesBloc = BlocProvider.of<FavoriteRecipesBloc>(context);
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    _foodBloc.add(LoadFoods());
    _recipeBloc.add(LoadRecipes());
    _mealBloc.add(LoadMeals());
    _goalBloc.add(LoadGoals());
    _dailyMealBloc.add(LoadDailyMeals());
    _favoriteRecipesBloc.add(LoadFavoriteRecipes());
    _favoriteFoodsBloc.add(LoadFavoriteFoods());
    _favoriteMealsBloc.add(LoadFavoriteMeals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "calories",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w600,
              ),
            ),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
          ],
        ),
      ),

    );
  }
}
