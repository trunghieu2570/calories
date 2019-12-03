import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class FavoriteRecipesBloc extends Bloc<FavoriteRecipesEvent, FavoriteRecipesState> {
  final AuthRepository _authRepository;
  final UserInfoRepository _userInfoRepository;
  StreamSubscription _streamSubscription;

  FavoriteRecipesBloc(
      {@required UserInfoRepository userInfoRepository,
        @required AuthRepository authRepository})
      : assert(userInfoRepository != null),
        assert(authRepository != null),
        _userInfoRepository = userInfoRepository,
        _authRepository = authRepository;

  @override
  FavoriteRecipesState get initialState => FavoriteRecipesLoading();

  @override
  Stream<FavoriteRecipesState> mapEventToState(
      FavoriteRecipesEvent event,
      ) async* {
    if (event is LoadFavoriteRecipes) {
      yield* _mapLoadFavoriteRecipesToState(event);
    } else if (event is AddFavoriteRecipe) {
      yield* _mapAddFavoriteRecipeToState(event);
    } else if (event is DeleteFavoriteRecipe) {
      yield* _mapDeleteFavoriteRecipeToState(event);
    } else if (event is FavoriteRecipesUpdated) {
      yield* _mapFavoriteRecipesUpdatedToState(event);
    }
  }

  Stream<FavoriteRecipesState> _mapLoadFavoriteRecipesToState(
      LoadFavoriteRecipes event) async* {
    final user = await _authRepository.getUser();
    _streamSubscription?.cancel();
    _streamSubscription = _userInfoRepository
        .getUserFavoriteRecipes(user.uid)
        .listen((ffs) => add(FavoriteRecipesUpdated(ffs)));
  }

  Stream<FavoriteRecipesState> _mapAddFavoriteRecipeToState(
      AddFavoriteRecipe event) async* {
    final user = await _authRepository.getUser();
    User userInfo = await _userInfoRepository.getUserById(user.uid);
    List<String> favoriteRecipes = userInfo.favoriteRecipes;
    favoriteRecipes.add(event.recipeId);
    _userInfoRepository.updateUser(userInfo.copyWith(favoriteRecipes: favoriteRecipes));
  }

  Stream<FavoriteRecipesState> _mapDeleteFavoriteRecipeToState(
      DeleteFavoriteRecipe event) async* {
    final user = await _authRepository.getUser();
    User userInfo = await _userInfoRepository.getUserById(user.uid);
    List<String> favoriteRecipes = userInfo.favoriteRecipes;
    if (favoriteRecipes.contains(event.recipeId)) {
      favoriteRecipes.removeWhere((item) => item == event.recipeId);
      _userInfoRepository
          .updateUser(userInfo.copyWith(favoriteRecipes: favoriteRecipes));
    }
  }

  Stream<FavoriteRecipesState> _mapFavoriteRecipesUpdatedToState(
      FavoriteRecipesUpdated event) async* {
    yield FavoriteRecipesLoaded(event.favoriteRecipes);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
