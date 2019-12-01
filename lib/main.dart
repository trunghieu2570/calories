import 'package:calories/blocs/favorite_foods/bloc.dart';
import 'package:calories/blocs/food/food_bloc.dart';
import 'package:calories/blocs/food/food_event.dart';
import 'package:calories/repositories/firestore/firebase_food_repository.dart';
import 'package:calories/repositories/auth_repository.dart';
import 'package:calories/repositories/firestore/firebase_user_repository.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:calories/ui/calories_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories/blocs/simple_bloc_delegate.dart';
import 'package:bloc/bloc.dart';

import 'blocs/auth/bloc.dart';
import 'blocs/login/bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final _authRepository = AuthRepository();
  final _foodRepositiory = FirebaseFoodRepository();
  final _userRepository = FirebaseUserRepository();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
        builder: (context) => AuthBloc(userRepository: _authRepository, userInfoRepository: _userRepository)..add(AppStarted()),
      ),
      BlocProvider<LoginBloc>(
        builder: (context) => LoginBloc(userRepository: _authRepository),
      ),
      BlocProvider<FoodBloc>(
        builder: (context) => FoodBloc(foodRepository: _foodRepositiory)..add(LoadFoods()),
      ),
      BlocProvider<FavoriteFoodsBloc>(
        builder:  (context) => FavoriteFoodsBloc(userInfoRepository: _userRepository),
      ),
    ],
    child: MyApp(userRepository: _authRepository,),
  ));
}
