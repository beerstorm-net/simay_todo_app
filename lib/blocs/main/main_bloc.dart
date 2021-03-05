import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simay_todo_app/models/app_user.dart';
import 'package:simay_todo_app/models/user_repository.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final UserRepository _userRepository;

  MainBloc({UserRepository userRepository})
      : _userRepository = userRepository,
        super(InitialMainState());

  MainState get initialState => InitialMainState();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is LoginEvent) {
      yield* _mapLoginEventToState(event);
    } else if (event is LogoutEvent) {
      _userRepository.signOut();
      yield LoginState(appUser: null, detail: {"STATE": "LOGOUT"});
    }
  }

  Stream<MainState> _mapAppStartedToState() async* {
    try {
      if (_userRepository.isSignedIn()) {
        final AppUser appUser = _userRepository.hiveStore.readAppUser();

        yield LoginState(appUser: appUser);
      } else {
        yield LoginState(appUser: null, detail: {"STATE": "NO_SIGNIN"});
      }
    } catch (_) {
      yield LoginState(appUser: null, detail: {"STATE": "ERROR_SIGNIN"});
    }
  }

  Stream<MainState> _mapLoginEventToState(LoginEvent event) async* {
    AppUser appUser = await _userRepository.signIn(
        username: event.username, password: event.password);

    yield LoginState(appUser: appUser);
  }
}
