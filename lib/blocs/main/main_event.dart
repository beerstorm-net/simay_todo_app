part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
  @override
  List<Object> get props => [];
}

class AppStartedEvent extends MainEvent {}

class LoginEvent extends MainEvent {
  final String username;
  final String password;

  const LoginEvent({this.username, this.password});

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'LoginEvent { username: $username, password: $password }';
}

class LogoutEvent extends MainEvent {}
