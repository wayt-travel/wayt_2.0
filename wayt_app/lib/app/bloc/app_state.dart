part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,

  /// This status is used when the app is launched.
  unknown;

  bool get isAuthenticated => this == authenticated;
  bool get isUnauthenticated => this == unauthenticated;
  bool get isUnknown => this == unknown;
}

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

  AppState copyWith({
    bool? isUpToDate,
    UserEntity? user,
    AppStatus? status,
    MphError? Function()? error,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error != null ? error() : this.error,
      isUpToDate: isUpToDate ?? this.isUpToDate,
    );
  }

  AppState unauthenticated({MphError? error}) {
    return AppState._(
      status: AppStatus.unauthenticated,
      error: error,
      isUpToDate: isUpToDate,
      dateTime: DateTime.now(),
    );
  }

  AppState authenticated(UserEntity user) {
    return AppState._(
      status: AppStatus.authenticated,
      isUpToDate: isUpToDate,
      user: user,
      dateTime: DateTime.now(),
    );
  }

  final AppStatus status;
  final UserEntity? user;
  final MphError? error;

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
