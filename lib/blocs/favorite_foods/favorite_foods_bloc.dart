import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/foundation.dart';

import './bloc.dart';

class FavoriteFoodsBloc extends Bloc<FavoriteFoodsEvent, FavoriteFoodsState> {
  final AuthRepository _authRepository;
  final UserInfoRepository _userInfoRepository;
  StreamSubscription _streamSubscription;

  FavoriteFoodsBloc(
      {@required UserInfoRepository userInfoRepository,
        @required AuthRepository authRepository})
      : assert(userInfoRepository != null),
        assert(authRepository != null),
        _userInfoRepository = userInfoRepository,
        _authRepository = authRepository;

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
    final user = await _authRepository.getUser();
    _streamSubscription?.cancel();
    _streamSubscription = _userInfoRepository
        .getUserFavoriteFoods(user.uid)
        .listen((ffs) => add(FavoriteFoodsUpdated(ffs)));
  }

  Stream<FavoriteFoodsState> _mapAddFavoriteFoodToState(
      AddFavoriteFood event) async* {
    final user = await _authRepository.getUser();
    User userInfo = await _userInfoRepository.getUserById(user.uid);
    List<String> favoriteFoods = userInfo.favoriteFoods;
    favoriteFoods.add(event.foodId);
    _userInfoRepository.updateUser(userInfo.copyWith(favoriteFoods: favoriteFoods));
  }

  Stream<FavoriteFoodsState> _mapDeleteFavoriteFoodToState(
      DeleteFavoriteFood event) async* {
    final user = await _authRepository.getUser();
    User userInfo = await _userInfoRepository.getUserById(user.uid);
    List<String> favoriteFoods = userInfo.favoriteFoods;
    if (favoriteFoods.contains(event.foodId)) {
      favoriteFoods.removeWhere((item) => item == event.foodId);
      _userInfoRepository
          .updateUser(userInfo.copyWith(favoriteFoods: favoriteFoods));
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