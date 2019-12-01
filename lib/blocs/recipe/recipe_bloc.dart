import 'dart:async';
import 'package:bloc/bloc.dart';
import 'recipe_event.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import './bloc.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository _recipeRepository;
  StreamSubscription _recipesSubscription;

  RecipeBloc({@required RecipeRepository recipeRepository})
      : assert(recipeRepository != null),
        _recipeRepository = recipeRepository;

  @override
  RecipeState get initialState => RecipesLoading();

  @override
  Stream<RecipeState> mapEventToState(
    RecipeEvent event,
  ) async* {
    if (event is LoadRecipes) {
      yield* _mapLoadRecipesToState();
    } else if (event is AddNewRecipe) {
      yield* _mapAddNewRecipeToState(event);
    } else if (event is DeleteRecipe) {
      yield* _mapDeleteRecipeToState(event);
    } else if (event is UpdateRecipe) {
      yield* _mapUpdateRecipeToState(event);
    } else if (event is UpdateRecipes) {
      yield* _mapUpdateRecipesToState(event);
    }
  }

  Stream<RecipeState> _mapLoadRecipesToState() async* {
    _recipesSubscription?.cancel();
    _recipesSubscription = _recipeRepository
        .getRecipes()
        .listen((recipes) => add(UpdateRecipes(recipes)));
  }

  Stream<RecipeState> _mapAddNewRecipeToState(AddNewRecipe event) async* {
    _recipeRepository.addNewRecipe(event.recipe);
  }

  Stream<RecipeState> _mapDeleteRecipeToState(DeleteRecipe event) async* {
    _recipeRepository.addNewRecipe(event.recipe);
  }

  Stream<RecipeState> _mapUpdateRecipeToState(UpdateRecipe event) async* {
    _recipeRepository.addNewRecipe(event.recipe);
  }

  Stream<RecipeState> _mapUpdateRecipesToState(UpdateRecipes event) async* {
    yield RecipesLoaded(event.recipes);
  }
}
