part of 'app_bloc.dart';

/// Events for the [AppBloc].
sealed class AppEvent {
  const AppEvent();
}

/// Event to check the app version.
final class AppVersionChecked extends AppEvent {
  /// Creates a new instance of [AppVersionChecked].
  const AppVersionChecked();
}

final class _AuthenticationStatusChanged extends AppEvent {
  const _AuthenticationStatusChanged(this.state);

  /// The auth repository's state.
  final AuthRepositoryState state;
}
