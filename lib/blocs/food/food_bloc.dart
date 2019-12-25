import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';

import './bloc.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository _foodRepository;
  final UserInfoRepository _userInfoRepository;
  final AuthRepository _authRepository;
  StreamSubscription _foodsSubscription;

  FoodBloc(
      {@required FoodRepository foodRepository,
      @required UserInfoRepository userInfoRepository,
      @required AuthRepository authRepository})
      : assert(foodRepository != null),
        assert(authRepository != null),
        assert(userInfoRepository != null),
        _foodRepository = foodRepository,
        _authRepository = authRepository,
        _userInfoRepository = userInfoRepository;

  @override
  FoodState get initialState => FoodLoading();

  @override
  Stream<FoodState> mapEventToState(
    FoodEvent event,
  ) async* {
    if (event is LoadFoods) {
      yield* _mapLoadFoodsToState();
    } else if (event is AddFood) {
      yield* _mapAddFoodToState(event);
    } else if (event is DeleteFood) {
      yield* _mapDeleteFoodToState(event);
    } else if (event is UpdateFood) {
      yield* _mapUpdateFoodToState(event);
    } else if (event is FoodsUpdated) {
      yield* _mapFoodsUpdateToState(event);
    }
  }

  Stream<FoodState> _mapLoadFoodsToState() async* {
    _foodsSubscription?.cancel();
    _foodsSubscription =
        _foodRepository.getFoods().listen((foods) => add(FoodsUpdated(foods)));
  }

  Stream<FoodState> _mapAddFoodToState(AddFood event) async* {
    final newFoodId = await _foodRepository.addNewFood(event.food);
    final user = await _authRepository.getUser();
    User userInfo = await _userInfoRepository.getUserById(user.uid);
    List<String> favoriteFoods = userInfo.favoriteFoods;
    favoriteFoods.add(newFoodId);
    _userInfoRepository
        .updateUser(userInfo.copyWith(favoriteFoods: favoriteFoods));
  }

  Stream<FoodState> _mapDeleteFoodToState(DeleteFood event) async* {
    _foodRepository.deleteFood(event.food);
  }

  Stream<FoodState> _mapUpdateFoodToState(UpdateFood event) async* {
    _foodRepository.updateFood(event.food);
  }

  Stream<FoodState> _mapFoodsUpdateToState(FoodsUpdated event) async* {
    yield FoodLoaded(event.foods);
  }

  @override
  Future<void> close() {
    _foodsSubscription?.cancel();
    return super.close();
  }
}
