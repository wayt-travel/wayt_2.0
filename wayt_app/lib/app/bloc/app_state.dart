part of 'app_bloc.dart';

/// The authentication status of the app.
enum AppStatus {
  /// The user is authenticated.
  authenticated,

  /// The user is not authenticated.
  unauthenticated,

  /// This status is used when the app is launched.
  unknown;

  /// Whether the app status is authenticated.
  bool get isAuthenticated => this == authenticated;

  /// Whether the app status is unauthenticated.
  bool get isUnauthenticated => this == unauthenticated;

  /// Whether the app status is unknown.
  bool get isUnknown => this == unknown;
}

/// The state of the app.
final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.isUpToDate,
    this.user,
    this.error,
    DateTime? dateTime,
  }) : _dateTime = dateTime;

  /// It is the initial state of the application.
  const AppState.unknown()
      : this._(
          status: AppStatus.unknown,
        );

  /// Copies the current state and replaces the provided fields.
  AppState copyWith({
    bool? isUpToDate,
    UserEntity? user,
    AppStatus? status,
    WError? Function()? error,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error != null ? error() : this.error,
      isUpToDate: isUpToDate ?? this.isUpToDate,
    );
  }

  /// Creates a new instance of [AppState] with the [AppStatus.unauthenticated]
  /// status.
  AppState unauthenticated({WError? error}) {
    return AppState._(
      status: AppStatus.unauthenticated,
      error: error,
      isUpToDate: isUpToDate,
      dateTime: DateTime.now().toUtc(),
    );
  }

  /// Creates a new instance of [AppState] with the [AppStatus.authenticated]
  AppState authenticated(UserEntity user) {
    return AppState._(
      status: AppStatus.authenticated,
      isUpToDate: isUpToDate,
      user: user,
      dateTime: DateTime.now().toUtc(),
    );
  }

  /// The current status of the app.
  final AppStatus status;

  /// The current user.
  final UserEntity? user;

  /// The state error.
  final WError? error;

  /// Indicates if the app is up to date.
  ///
  /// If [isUpToDate] is null, the app is still checking the current version.
  /// A splash screen will be shown.
  final bool? isUpToDate;

  /// This field is used only to differentiate states, especially in
  /// cases of `unauthenticated` state.
  final DateTime? _dateTime;

  @override
  List<Object?> get props => [
        status,
        user,
        error,
        _dateTime,
      ];
}
