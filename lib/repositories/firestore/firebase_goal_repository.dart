import 'package:calories/entities/entities.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/daily_meal_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../goal_repository.dart';

class FirebaseGoalRepository extends GoalsRepository {
  final usersCollection = Firestore.instance.collection("users");

  @override
  Future<String> addNewGoal(String uid, Goal goal) async {
    final doc = await usersCollection
        .document(uid)
        .collection("goals")
        .add(goal.toEntity().toDocument());
    return doc.documentID;
  }

  @override
  Future<void> deleteGoal(String uid, Goal goal) async {
    return usersCollection
        .document(uid)
        .collection("goals")
        .document(goal.id)
        .delete();
  }

  @override
  Stream<List<Goal>> getGoals(String uid) {
    return usersCollection
        .document(uid)
        .collection("goals")
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((e) => Goal.fromEntity(GoalEntity.fromSnapshot(e)))
            .toList());
  }

  @override
  Future<void> updateGoal(String uid, Goal goal) {
    return usersCollection
        .document(uid)
        .collection("goals")
        .document(goal.id)
        .updateData(goal.toEntity().toDocument());
  }
}
