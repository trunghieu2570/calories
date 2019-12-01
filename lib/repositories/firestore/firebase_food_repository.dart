import 'package:calories/entities/entities.dart';
import 'package:calories/models/food_model.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFoodRepository extends FoodRepository {
  final foodCollection = Firestore.instance.collection("foods");

  @override
  Future<String> addNewFood(Food food) async {
    DocumentReference doc = await foodCollection.add(food.toEntity().toDocument());
    return doc.documentID;
  }

  @override
  Future<void> deleteFood(Food food) async {
    return foodCollection.document(food.id).delete();
  }

  @override
  Stream<List<Food>> getFoods() {
    return foodCollection.snapshots().map((snapshot) => snapshot.documents
        .map((e) => Food.fromEntity(FoodEntity.fromSnapshot(e)))
        .toList());
  }

  @override
  Future<void> updateFood(Food food) {
    return foodCollection
        .document(food.id)
        .updateData(food.toEntity().toDocument());
  }
}
