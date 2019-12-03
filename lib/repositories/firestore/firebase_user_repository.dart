import 'package:calories/entities/entities.dart';
import 'package:calories/models/user_model.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserRepository extends UserInfoRepository {
  final userCollection = Firestore.instance.collection("users");

  @override
  Future<void> addUser(User user) {
    return userCollection
        .document(user.uid)
        .setData(user.toEntity().toDocument(), merge: true);
  }

  @override
  Future<void> deleteUser(User user) async {
    return userCollection.document(user.uid).delete();
  }

  @override
  Stream<List<User>> getUsers() {
    return userCollection.snapshots().map((snapshot) => snapshot.documents
        .map((e) => User.fromEntity(UserEntity.fromSnapshot(e)))
        .toList());
  }

  @override
  Stream<List<String>> getUserFavoriteFoods(String uid) {
    return userCollection.document(uid).snapshots().map((snap) => List<String>.from(snap.data["favoriteFoods"]));
  }

  @override
  Stream<List<String>> getUserFavoriteRecipes(String uid) {
    return userCollection.document(uid).snapshots().map((snap) => List<String>.from(snap.data["favoriteRecipes"]));
  }

  @override
  Stream<List<String>> getUserFavoriteMeals(String uid) {
    return userCollection.document(uid).snapshots().map((snap) => List<String>.from(snap.data["favoriteMeals"]));
  }

  @override
  Future<void> updateUser(User user) {
    return userCollection
        .document(user.uid)
        .updateData(user.toEntity().toDocument());
  }

  @override
  Future<User> getUserById(String uid) async {
    DocumentSnapshot doc = await userCollection.document(uid).get();
    if (doc.data == null) return null;
    return (User.fromEntity(
        UserEntity.fromSnapshot(doc)));
  }
}
