import 'package:calories/models/models.dart';

abstract class GoalsRepository {
  Future<String> addNewGoal(String uid, Goal goal);

  Future<void> updateGoal(String uid, Goal goal);

  Future<void> deleteGoal(String uid, Goal goal);

  Stream<List<Goal>> getGoals(String uid);
}
