import 'package:calories/models/models.dart';

abstract class UserInfoRepository {
  Future<void> deleteUser(User user);

  Future<void> addUser(User user);

  Future<void> updateUser(User user);

  Stream<List<User>> getUsers();

  Stream<List<String>> getUserFavoriteFoods(String uid);

  Stream<List<String>> getUserFavoriteRecipes(String uid);
  
  Stream<List<String>> getUserFavoriteMeals(String uid);

  Future<User> getUserById(String uid);
}
