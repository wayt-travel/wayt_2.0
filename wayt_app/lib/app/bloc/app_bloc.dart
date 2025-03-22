import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../error/errors.dart';
import '../../repositories/repositories.dart';

part 'app_event.dart';
part 'app_state.dart';

/// This bloc is in charge of redirecting user to the right page.
///
/// It is created with `AppState.status.unknown`.
///
/// When the app has finished checking the version, listener is set to direct
/// the user to the correct page. If user is logged in their are redirected to
/// HomePage, otherwise to the LoginPage.
///
/// If the app is not u pto date the UpdateAppModal is shown before checking
/// the states of the user.
class AppBloc extends Bloc<AppEvent, AppState> with LoggerMixin {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<AuthRepositoryState> _authSubscription;

  /// Creates a new instance of [AppBloc].
  AppBloc({
    required AuthRepository authRepo,
    required UserRepository userRepo,
  })  : _authRepository = authRepo,
        _userRepository = userRepo,
        super(const AppState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStateChanged);
    _setUpListeners();
  }

  void _setUpListeners() {
    _authSubscription = _authRepository.listen(
      (state) => add(_AuthenticationStatusChanged(state)),
    );
  }

  /// Initializes the app state. Call it only when the app initialization is
  /// completed.
  Future<void> init() async {
    // await _authRepository.init();
    await _authRepository.signIn(
      email: 'john.doe@example.com',
      password: 'password',
    );
  }

  Future<UserEntity?> _tryFetchUser() async {
    try {
      return _userRepository.fetchMe();
    } catch (_) {
      return null;
    }
  }

  Future<void> _onAuthenticationStateChanged(
    _AuthenticationStatusChanged event,
    Emitter<AppState> emit,
  ) async {
    switch (event.state.status) {
      case AuthenticationStatus.authenticated:
        {
          try {
            final user = await _tryFetchUser();
            if (user != null) {
              emit(state.authenticated(user));
              return;
            }
            emit(state.unauthenticated());
          } catch (e, s) {
            logger.e(e.toString(), e, s);
            emit(state.unauthenticated(error: e.errorOrGeneric));
          }
        }
      case AuthenticationStatus.unauthenticated:
        // TODO: reset all repositories
        // _userRepository.reset();

        return emit(state.unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
