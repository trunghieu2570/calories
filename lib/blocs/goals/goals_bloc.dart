import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final AuthRepository _authRepository;
  final GoalsRepository _goalsRepository;
  StreamSubscription _streamSubscription;

  GoalBloc(
      {@required GoalsRepository goalsRepository,
        @required AuthRepository authRepository})
      : assert(goalsRepository != null),
        assert(authRepository != null),
        _goalsRepository = goalsRepository,
        _authRepository = authRepository;

  @override
  GoalState get initialState => GoalsLoading();

  @override
  Stream<GoalState> mapEventToState(
      GoalEvent event,
      ) async* {
    if (event is LoadGoals) {
      yield* _mapLoadGoalsToState(event);
    } else if (event is AddGoal) {
      yield* _mapAddGoalToState(event);
    } else if (event is DeleteGoal) {
      yield* _mapDeleteGoalToState(event);
    } else if (event is UpdateGoal) {
      yield* _mapUpdateGoalToState(event);
    } else if (event is GoalsUpdated) {
      yield* _mapGoalsUpdatedToState(event);
    }
  }

  Stream<GoalState> _mapLoadGoalsToState(
      LoadGoals event) async* {
    final user = await _authRepository.getUser();
    _streamSubscription?.cancel();
    _streamSubscription = _goalsRepository
        .getGoals(user.uid)
        .listen((dms) => add(GoalsUpdated(dms)));
  }

  Stream<GoalState> _mapAddGoalToState(AddGoal event) async* {
    final user = await _authRepository.getUser();
    _goalsRepository.addNewGoal(user.uid, event.goal);
  }

  Stream<GoalState> _mapDeleteGoalToState(
      DeleteGoal event) async* {
    final user = await _authRepository.getUser();
    _goalsRepository.deleteGoal(user.uid, event.goal);
  }

  Stream<GoalState> _mapUpdateGoalToState(
      UpdateGoal event) async* {
    final user = await _authRepository.getUser();
    _goalsRepository.updateGoal(user.uid, event.goal);
  }

  Stream<GoalState> _mapGoalsUpdatedToState(
      GoalsUpdated event) async* {
    yield GoalsLoaded(event.goals);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}