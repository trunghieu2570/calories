import 'package:flutter/cupertino.dart';

@immutable
class LoginState {
  final bool isSuccess;

  LoginState({@required this.isSuccess}) : assert(isSuccess != null);

  factory LoginState.empty() {
    return LoginState(isSuccess: false);
  }

  factory LoginState.success() {
    return LoginState(isSuccess: true);
  }

  factory LoginState.failure() {
    return LoginState(isSuccess: false);
  }
}
