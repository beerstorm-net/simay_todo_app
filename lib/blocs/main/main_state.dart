part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class InitialMainState extends MainState {}

class LoginState extends MainState {
  final AppUser appUser;
  final Map<String, String> detail;

  const LoginState({this.appUser, this.detail});

  @override
  List<Object> get props => [appUser, detail];

  @override
  String toString() => 'LoginState { appUser: $appUser, detail: $detail }';
}
