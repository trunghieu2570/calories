import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/foundation.dart';

import './bloc.dart';

class FavoriteMealsBloc extends Bloc<FavoriteMealsEvent, FavoriteMealsState> {
  final AuthRepository _authRepository;
  final UserInfoRepository _userInfoRepository;
  StreamSubscription _streamSubscription;

  FavoriteMealsBloc(
      {@required UserInfoRepository userInfoRepository,
      @required AuthRepository authRepository})
      : assert(userInfoRepository != null),
        assert(authRepository != null),
        _userInfoRepository = userInfoRepository,
        _authRepository = authRepository;

  @override
  FavoriteMealsState get initialState => FavoriteMealsLoading();

  @override
  Stream<FavoriteMealsState> mapEventToState(
    FavoriteMealsEvent event,
  ) async* {
    if (event is LoadFavoriteMeals) {
      yield* _mapLoadFavoriteMealsToState(event);
    } else if (event is AddFavoriteMeal) {
      yield* _mapAddFavoriteMealToState(event);
    } else if (event is DeleteFavoriteMeal) {
      yield* _mapDeleteFavoriteMealToState(event);
    } else if (event is FavoriteMealsUpdated) {
      yield* _mapFavoriteMealsUpdatedToState(event);
    }
  }

  Stream<FavoriteMealsState> _mapLoadFavoriteMealsToState(
      LoadFavoriteMeals event) async* {
    final user = await _authRepository.getUser();
    _streamSubscription?.cancel();
    _streamSubscription = _userInfoRepository
        .getUserFavoriteMeals(user.uid)
        .listen((ffs) => add(FavoriteMealsUpdated(ffs)));
  }

  Stream<FavoriteMealsState> _mapAddFavoriteMealToState(
      AddFavoriteMeal event) async* {
    final user = await _authRepository.getUser();
    User userInfo = await _userInfoRepository.getUserById(user.uid);
    List<String> favoriteMeals = userInfo.favoriteMeals;
    favoriteMeals.add(event.mealId);
    _userInfoRepository
        .updateUser(userInfo.copyWith(favoriteMeals: favoriteMeals));
  }

  Stream<FavoriteMealsState> _mapDeleteFavoriteMealToState(
      DeleteFavoriteMeal event) async* {
    final user = await _authRepository.getUser();
    User userInfo = await _userInfoRepository.getUserById(user.uid);
    List<String> favoriteMeals = userInfo.favoriteMeals;
    if (favoriteMeals.contains(event.mealId)) {
      favoriteMeals.removeWhere((item) => item == event.mealId);
      _userInfoRepository
          .updateUser(userInfo.copyWith(favoriteMeals: favoriteMeals));
    }
  }

  Stream<FavoriteMealsState> _mapFavoriteMealsUpdatedToState(
      FavoriteMealsUpdated event) async* {
    yield FavoriteMealsLoaded(event.favoriteMeals);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
