import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';

import './bloc.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository _mealRepository;
  final UserInfoRepository _userInfoRepository;
  StreamSubscription _streamSubscription;

  MealBloc(
      {@required UserInfoRepository userInfoRepository,
      @required MealRepository mealRepository})
      : assert(mealRepository != null),
        assert(userInfoRepository != null),
        _userInfoRepository = userInfoRepository,
        _mealRepository = mealRepository;

  @override
  MealState get initialState => MealsLoading();

  @override
  Stream<MealState> mapEventToState(
    MealEvent event,
  ) async* {
    if (event is LoadMeals) {
      yield* _mapLoadMealsToState();
    } else if (event is AddMeal) {
      yield* _mapAddMealToState(event);
    } else if (event is DeleteMeal) {
      yield* _mapDeleteMealToState(event);
    } else if (event is UpdateMeal) {
      yield* _mapUpdateMealToState(event);
    } else if (event is MealsUpdated) {
      yield* _mapMealUpdatedToState(event);
    }
  }

  Stream<MealState> _mapLoadMealsToState() async* {
    _streamSubscription?.cancel();
    _streamSubscription =
        _mealRepository.getMeals().listen((meals) => add(MealsUpdated(meals)));
  }

  Stream<MealState> _mapAddMealToState(AddMeal event) async* {
    _mealRepository.addNewMeal(event.meal);
  }

  Stream<MealState> _mapDeleteMealToState(DeleteMeal event) async* {
    _mealRepository.deleteMeal(event.meal);
  }

  Stream<MealState> _mapUpdateMealToState(UpdateMeal event) async* {
    _mealRepository.updateMeal(event.meal);
  }

  Stream<MealState> _mapMealUpdatedToState(MealsUpdated event) async* {
    yield MealsLoaded(event.meals);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
