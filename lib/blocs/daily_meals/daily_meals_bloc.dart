import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calories/repositories/daily_meal_repository.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/foundation.dart';

import './bloc.dart';

class DailyMealBloc extends Bloc<DailyMealEvent, DailyMealState> {
  final AuthRepository _authRepository;
  final DailyMealsRepository _dailyMealsRepository;
  StreamSubscription _streamSubscription;

  DailyMealBloc(
      {@required DailyMealsRepository dailyMealsRepository,
      @required AuthRepository authRepository})
      : assert(dailyMealsRepository != null),
        assert(authRepository != null),
        _dailyMealsRepository = dailyMealsRepository,
        _authRepository = authRepository;

  @override
  DailyMealState get initialState => DailyMealsLoading();

  @override
  Stream<DailyMealState> mapEventToState(
    DailyMealEvent event,
  ) async* {
    if (event is LoadDailyMeals) {
      yield* _mapLoadDailyMealsToState(event);
    } else if (event is AddDailyMeal) {
      yield* _mapAddDailyMealToState(event);
    } else if (event is DeleteDailyMeal) {
      yield* _mapDeleteDailyMealToState(event);
    } else if (event is UpdateDailyMeal) {
      yield* _mapUpdateDailyMealToState(event);
    } else if (event is DailyMealsUpdated) {
      yield* _mapDailyMealsUpdatedToState(event);
    }
  }

  Stream<DailyMealState> _mapLoadDailyMealsToState(
      LoadDailyMeals event) async* {
    final user = await _authRepository.getUser();
    _streamSubscription?.cancel();
    _streamSubscription = _dailyMealsRepository
        .getDailyMeals(user.uid)
        .listen((dms) => add(DailyMealsUpdated(dms)));
  }

  Stream<DailyMealState> _mapAddDailyMealToState(AddDailyMeal event) async* {
    final user = await _authRepository.getUser();
    _dailyMealsRepository.addNewDailyMeal(user.uid, event.dailyMeal);
  }

  Stream<DailyMealState> _mapDeleteDailyMealToState(
      DeleteDailyMeal event) async* {
    final user = await _authRepository.getUser();
    _dailyMealsRepository.deleteDailyMeal(user.uid, event.dailyMeal);
  }

  Stream<DailyMealState> _mapUpdateDailyMealToState(
      UpdateDailyMeal event) async* {
    final user = await _authRepository.getUser();
    _dailyMealsRepository.updateDailyMeal(user.uid, event.dailyMeal);
  }

  Stream<DailyMealState> _mapDailyMealsUpdatedToState(
      DailyMealsUpdated event) async* {
    yield DailyMealsLoaded(event.dailyMeals);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
