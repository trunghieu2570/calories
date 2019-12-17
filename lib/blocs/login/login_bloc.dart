import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:calories/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({@required AuthRepository userRepository})
      : assert(userRepository != null),
        _authRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGGPressToState();
    }
  }

  Stream<LoginState> _mapLoginWithGGPressToState() async* {
    try {
      final _googleSignIn = await _authRepository.signIn();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }

  }
}
