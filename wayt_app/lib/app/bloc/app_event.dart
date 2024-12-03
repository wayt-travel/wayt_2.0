part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppVersionChecked extends AppEvent {
  const AppVersionChecked();
}

final class _AuthenticationStatusChanged extends AppEvent {
  const _AuthenticationStatusChanged(this.state);

  /// The auth repository's state.
  final AuthRepositoryState state;
}
