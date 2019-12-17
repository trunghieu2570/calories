import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/models/models.dart';
import 'package:calories/repositories/auth_repository.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';

import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserInfoRepository _userInfoRepository;

  AuthBloc(
      {@required AuthRepository userRepository,
      @required UserInfoRepository userInfoRepository})
      : assert(userRepository != null),
        assert(userInfoRepository != null),
        _authRepository = userRepository,
        _userInfoRepository = userInfoRepository;

  @override
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AppLoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is AppLoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      final firebaseUser = await _authRepository.getUser();
      User user = await _userInfoRepository.getUserById(firebaseUser.uid);
      if (user == null) {
        user = User(
            uid: firebaseUser.uid,
            fullName: firebaseUser.displayName,
            email: firebaseUser.email,
            favoriteFoods: [],
            favoriteMeals: [],
            favoriteRecipes: [],
            photoUrl: firebaseUser.photoUrl);
        _userInfoRepository.addUser(user);
      }
      yield Authenticated(user);
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      final firebaseUser = await _authRepository.getUser();
      User user = await _userInfoRepository.getUserById(firebaseUser.uid);
      if (user == null) {
        user = User(
            uid: firebaseUser.uid,
            fullName: firebaseUser.displayName,
            email: firebaseUser.email,
            favoriteFoods: [],
            favoriteMeals: [],
            favoriteRecipes: [],
            photoUrl: firebaseUser.photoUrl);
        _userInfoRepository.addUser(user);
      }
      yield Authenticated(user);
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    await _authRepository.signOut();
  }
}
