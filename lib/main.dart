import 'package:bloc/bloc.dart';
import 'package:calories/blocs/daily_meals/daily_meals_bloc.dart';
import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/favorite_meals/bloc.dart';
import 'package:calories/blocs/favorite_recipes/bloc.dart';
import 'package:calories/blocs/food/bloc.dart';
import 'package:calories/blocs/goals/goals_bloc.dart';
import 'package:calories/blocs/meal/bloc.dart';
import 'package:calories/blocs/recipe/bloc.dart';
import 'package:calories/blocs/simple_bloc_delegate.dart';
import 'package:calories/repositories/auth_repository.dart';
import 'package:calories/repositories/firestore/firebase_daily_meal_repository.dart';
import 'package:calories/repositories/firestore/firebase_food_repository.dart';
import 'package:calories/repositories/firestore/firebase_goal_repository.dart';
import 'package:calories/repositories/firestore/firebase_meal_repository.dart';
import 'package:calories/repositories/firestore/firebase_recipe_repository.dart';
import 'package:calories/repositories/firestore/firebase_user_repository.dart';
import 'package:calories/ui/calories_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/bloc.dart';
import 'blocs/home_load/bloc.dart';
import 'blocs/login/bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final _authRepository = AuthRepository();
  final _foodRepository = FirebaseFoodRepository();
  final _userRepository = FirebaseUserRepository();
  final _recipeRepository = FirebaseRecipeRepository();
  final _mealRepository = FirebaseMealRepository();
  final _dailyMealRepository = FirebaseDailyMealRepository();
  final _goalRepository = FirebaseGoalRepository();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
            userRepository: _authRepository,
            userInfoRepository: _userRepository)
          ..add(AppStarted()),
      ),
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _authRepository),
      ),
      BlocProvider<FoodBloc>(
        create: (context) => FoodBloc(
            foodRepository: _foodRepository,
            authRepository: _authRepository,
            userInfoRepository: _userRepository),
      ),
      BlocProvider<RecipeBloc>(
        create: (context) => RecipeBloc(
            recipeRepository: _recipeRepository,
            authRepository: _authRepository,
            userInfoRepository: _userRepository),
      ),
      BlocProvider<FavoriteFoodsBloc>(
        create: (context) => FavoriteFoodsBloc(
            userInfoRepository: _userRepository,
            authRepository: _authRepository),
      ),
      BlocProvider<FavoriteRecipesBloc>(
        create: (context) => FavoriteRecipesBloc(
            userInfoRepository: _userRepository,
            authRepository: _authRepository),
      ),
      BlocProvider<MealBloc>(
        create: (context) => MealBloc(
            userInfoRepository: _userRepository,
            mealRepository: _mealRepository,
            authRepository: _authRepository),
      ),
      BlocProvider<FavoriteMealsBloc>(
        create: (context) => FavoriteMealsBloc(
            userInfoRepository: _userRepository,
            authRepository: _authRepository),
      ),
      BlocProvider<DailyMealBloc>(
        create: (context) => DailyMealBloc(
            dailyMealsRepository: _dailyMealRepository,
            authRepository: _authRepository),
      ),
      BlocProvider<GoalBloc>(
        create: (context) => GoalBloc(
          authRepository: _authRepository,
          goalsRepository: _goalRepository,
        ),
      ),
    ],
    child: MyApp(),
  ));
}
