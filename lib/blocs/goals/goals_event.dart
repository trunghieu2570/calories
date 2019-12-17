import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}

class AddGoal extends GoalEvent {
  final Goal goal;

  const AddGoal(this.goal);

  @override
  List<Object> get props => [goal];

  @override
  String toString() {
    return "Add goal $goal";
  }
}

class DeleteGoal extends GoalEvent {
  final Goal goal;

  const DeleteGoal(this.goal);

  @override
  List<Object> get props => [goal];

  @override
  String toString() {
    return "Delete goal $goal";
  }
}

class UpdateGoal extends GoalEvent {
  final Goal goal;

  const UpdateGoal(this.goal);

  @override
  List<Object> get props => [goal];

  @override
  String toString() {
    return "Update goal $goal";
  }
}

class GoalsUpdated extends GoalEvent {
  final List<Goal> goals;

  const GoalsUpdated(this.goals);

  @override
  List<Object> get props => [goals];
}

class LoadGoals extends GoalEvent {}