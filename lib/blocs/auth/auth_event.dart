import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}
class AppLoggedIn extends AuthEvent {}
class AppLoggedOut extends AuthEvent {}
