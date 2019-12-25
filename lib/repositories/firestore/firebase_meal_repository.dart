import 'package:calories/entities/entities.dart';
import 'package:calories/models/meal_model.dart';
import 'package:calories/repositories/meal_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMealRepository extends MealRepository {
  final _mealCollection = Firestore.instance.collection("meals");

  @override
  Future<String> addNewMeal(Meal meal) async {
    final doc = await _mealCollection.add(meal.toEntity().toDocument());
    return doc.documentID;
  }

  @override
  Future<void> deleteMeal(Meal meal) async {
    return _mealCollection.document(meal.id).delete();
  }

  @override
  Stream<List<Meal>> getMeals() {
    return _mealCollection.snapshots().map((snapshot) => snapshot.documents
        .map((e) => Meal.fromEntity(MealEntity.fromSnapshot(e)))
        .toList());
  }

  @override
  Future<void> updateMeal(Meal meal) {
    return _mealCollection
        .document(meal.id)
        .updateData(meal.toEntity().toDocument());
  }
}
