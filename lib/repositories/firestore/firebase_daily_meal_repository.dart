import 'package:calories/entities/entities.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/daily_meal_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDailyMealRepository extends DailyMealsRepository {
  final usersCollection = Firestore.instance.collection("users");

  @override
  Future<String> addNewDailyMeal(String uid, DailyMeal dailyMeal) async {
    final doc = await usersCollection
        .document(uid)
        .collection("dailyMeals")
        .add(dailyMeal.toEntity().toDocument());
    return doc.documentID;
  }

  @override
  Future<void> deleteDailyMeal(String uid, DailyMeal dailyMeal) async {
    return usersCollection
        .document(uid)
        .collection("dailyMeals")
        .document(dailyMeal.id)
        .delete();
  }

  @override
  Stream<List<DailyMeal>> getDailyMeals(String uid) {
    return usersCollection
        .document(uid)
        .collection("dailyMeals")
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((e) => DailyMeal.fromEntity(DailyMealEntity.fromSnapshot(e)))
            .toList());
  }

  @override
  Future<void> updateDailyMeal(String uid, DailyMeal dailyMeal) {
    return usersCollection
        .document(uid)
        .collection("dailyMeals")
        .document(dailyMeal.id)
        .updateData(dailyMeal.toEntity().toDocument());
  }
}
