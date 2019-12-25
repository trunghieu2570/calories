import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthState {}
class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated $user';
}

class Unauthenticated extends AuthState {}
