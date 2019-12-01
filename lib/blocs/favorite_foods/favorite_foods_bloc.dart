import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/foundation.dart';

import './bloc.dart';

class FavoriteFoodsBloc extends Bloc<FavoriteFoodsEvent, FavoriteFoodsState> {
  final UserInfoRepository _userInfoRepository;
  StreamSubscription _streamSubscription;

  FavoriteFoodsBloc({@required UserInfoRepository userInfoRepository})
      : assert(userInfoRepository != null),
        _userInfoRepository = userInfoRepository;

  @override
  FavoriteFoodsState get initialState => FavoriteFoodsLoading();

  @override
  Stream<FavoriteFoodsState> mapEventToState(
    FavoriteFoodsEvent event,
  ) async* {
    if (event is LoadFavoriteFoods) {
      yield* _mapLoadFavoriteFoodsToState(event);
    } else if (event is AddFavoriteFood) {
      yield* _mapAddFavoriteFoodToState(event);
    } else if (event is DeleteFavoriteFood) {
      yield* _mapDeleteFavoriteFoodToState(event);
    } else if (event is FavoriteFoodsUpdated) {
      yield* _mapFavoriteFoodsUpdatedToState(event);
    }
  }

  Stream<FavoriteFoodsState> _mapLoadFavoriteFoodsToState(
      LoadFavoriteFoods event) async* {
    _streamSubscription?.cancel();
    _streamSubscription = _userInfoRepository
        .getUserFavoriteFoods(event.userId)
        .listen((ffs) => add(FavoriteFoodsUpdated(ffs)));
  }

  Stream<FavoriteFoodsState> _mapAddFavoriteFoodToState(
      AddFavoriteFood event) async* {
    User user = await _userInfoRepository.getUserById(event.userId);
    List<String> favoriteFoods = user.favoriteFoods;
    favoriteFoods.add(event.foodId);
    _userInfoRepository.updateUser(user.copyWith(favoriteFoods: favoriteFoods));
  }

  Stream<FavoriteFoodsState> _mapDeleteFavoriteFoodToState(
      DeleteFavoriteFood event) async* {
    User user = await _userInfoRepository.getUserById(event.userId);
    List<String> favoriteFoods = user.favoriteFoods;
    if (favoriteFoods.contains(event.foodId)) {
      favoriteFoods.remove(event.foodId);
      _userInfoRepository
          .updateUser(user.copyWith(favoriteFoods: favoriteFoods));
    }
  }

  Stream<FavoriteFoodsState> _mapFavoriteFoodsUpdatedToState(
      FavoriteFoodsUpdated event) async* {
    yield FavoriteFoodsLoaded(event.favoriteFoods);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
