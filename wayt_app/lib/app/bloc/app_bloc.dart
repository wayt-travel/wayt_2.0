import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../error/error.dart';
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
/// If the app is not upto date the UpdateAppModal is shown before checking
/// the states of the user.
class AppBloc extends Bloc<AppEvent, AppState> with LoggerMixin {
  AppBloc({
    required AuthRepository authRepo,
    required UserRepository userRepo,
  })  : _authRepository = authRepo,
        _userRepository = userRepo,
        super(const AppState.unknown()) {
    on<_AuthenticationStatusChanged>(_onAuthenticationStateChanged);
    // TODO:
    _setUpListeners();
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<AuthRepositoryState> _authSubscription;

  final UserRepository _userRepository;

  /// Calls this method when the initialization of the app is completed.
  /// This method should be called after that `state.isAppToDate` is set.
  void _setUpListeners() {
    _authSubscription = _authRepository.listen(
      (state) => add(
        _AuthenticationStatusChanged(state),
      ),
    );
    _authRepository.init();
  }

  Future<UserEntity?> _tryFetchUser() async {
    try {
      await _userRepository.fetch();
      return _userRepository.item;
    } catch (e, _) {
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
              emit(
                state.authenticated(user),
              );
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
        _userRepository.reset();

        return emit(state.unauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
