import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

/// {@template auth_model}
/// Model that represents the authenticated user.
///
/// This model is used to store the authenticated user in the
/// [AuthRepository].
///
/// {@endtemplate}
class AuthModel extends Model implements AuthEntity {
  @override
  final UserEntity? user;

  /// {@macro auth_model}
  const AuthModel({
    required this.user,
  });

  @override
  Map<String, dynamic> $toMap() => {
        'user': user?.id,
      };

  @override
  List<Object?> get props => [user];

  /// Creates a new instance of [AuthModel] with the same properties as this
  /// instance, but with the [user] property replaced by the given [user].
  AuthModel copyWith({
    Optional<UserEntity?> user = const Optional.absent(),
  }) {
    return AuthModel(
      user: user.orElseIfAbsent(this.user),
    );
  }
}
