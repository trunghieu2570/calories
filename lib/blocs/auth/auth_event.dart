import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}
class AppLoggedIn extends AuthEvent {}
class AppLoggedOut extends AuthEvent {}
class UpdateUserInfo extends AuthEvent {
  final User user;
  const UpdateUserInfo(this.user);
  @override
  List<Object> get props => [user];
  @override
  String toString() {
    return "UpdateUser $user";
  }
}
