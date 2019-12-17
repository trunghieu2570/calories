import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object> get props => [];
}

class GoalsLoading extends GoalState {}

class GoalAdded extends GoalState {
  final Goal goal;

  const GoalAdded(this.goal);

  @override
  List<Object> get props => [goal];

  @override
  String toString() {
    return "GoalAdded $goal";
  }
}

class GoalsLoaded extends GoalState {
  final List<Goal> goals;

  const GoalsLoaded(this.goals);

  @override
  List<Object> get props => [goals];

  @override
  String toString() {
    return "GoalsLoaded $goals";
  }
}

class GoalNotLoad extends GoalState {}
