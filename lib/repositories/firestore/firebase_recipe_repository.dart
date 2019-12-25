import 'package:calories/entities/entities.dart';
import 'package:calories/models/recipe_model.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRecipeRepository extends RecipeRepository {
  final recipeCollection = Firestore.instance.collection("recipes");

  @override
  Future<String> addNewRecipe(Recipe recipe) async {
    final doc = await recipeCollection.add(recipe.toEntity().toDocument());
    return doc.documentID;
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) async {
    return recipeCollection.document(recipe.id).delete();
  }

  @override
  Stream<List<Recipe>> getRecipes() {
    return recipeCollection.snapshots().map((snapshot) => snapshot.documents
        .map((doc) => Recipe.fromEntity(RecipeEntity.fromSnapshot(doc)))
        .toList());
  }

  @override
  Future<void> updateRecipe(Recipe recipe) {
    return recipeCollection
        .document(recipe.id)
        .updateData(recipe.toEntity().toDocument());
  }
}
