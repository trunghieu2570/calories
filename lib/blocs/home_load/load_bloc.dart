import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/blocs/daily_meals/bloc.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/favorite_recipes/bloc.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/blocs/goals/bloc.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/bloc.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';

class HomeLoadBloc extends Bloc<HomeLoadEvent, HomeLoadState> {
  StreamSubscription<bool> _streamSubscription;
  final FoodBloc foodBloc;
  final RecipeBloc recipeBloc;
  final MealBloc mealBloc;
  final GoalBloc goalBloc;
  final DailyMealBloc dailyMealBloc;
  final FavoriteFoodsBloc favoriteFoodsBloc;
  final FavoriteMealsBloc favoriteMealsBloc;
  final FavoriteRecipesBloc favoriteRecipesBloc;

  HomeLoadBloc(
      {this.foodBloc,
      this.recipeBloc,
      this.mealBloc,
      this.goalBloc,
      this.dailyMealBloc,
      this.favoriteFoodsBloc,
      this.favoriteMealsBloc,
      this.favoriteRecipesBloc});

  @override
  HomeLoadState get initialState => InitLoadState();

  @override
  Stream<HomeLoadState> mapEventToState(
    HomeLoadEvent event,
  ) async* {
    if (event is StartHomeLoad) {
      yield* _mapStartHomeLoadToState();
    } else if (event is HomeLoaded) {
      yield* _mapHomeLoadedToState();
    }
  }

  Stream<HomeLoadState> _mapStartHomeLoadToState() async* {
    _streamSubscription?.cancel();
    _streamSubscription = Observable.combineLatest8(
      foodBloc,
      recipeBloc,
      mealBloc,
      goalBloc,
      dailyMealBloc,
      favoriteFoodsBloc,
      favoriteRecipesBloc,
      favoriteMealsBloc,
      (food, recipe, meal, goal, dailyMeal, favFood, favRecipe, favMeal) {
        return food is FoodLoaded &&
            recipe is RecipesLoaded &&
            meal is MealsLoaded &&
            goal is GoalsLoaded &&
            dailyMeal is DailyMealsLoaded &&
            favFood is FavoriteFoodsLoaded &&
            favMeal is FavoriteMealsLoaded &&
            favRecipe is FavoriteRecipesLoaded;
      },
    ).listen((isOk) {
      if (isOk) return add(HomeLoaded());
    });
  }

  Stream<HomeLoadState> _mapHomeLoadedToState() async* {
    yield HomeLoadedState();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
