import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../repositories.dart';

part 'auth_model.gen.g.dart';

/// {@template auth_model}
/// Model that represents the authenticated user.
///
/// This model is used to store the authenticated user in the
/// [AuthRepository].
///
/// {@endtemplate}
@JsonSerializable()
class AuthModel extends Model implements AuthEntity {
  @override
  @UserEntityJsonConverter()
  final UserEntity? user;

  /// {@macro auth_model}
  const AuthModel({
    required this.user,
  });

  /// Creates a new instance of the [AuthModel] from a JSON map.
  factory AuthModel.fromJson(Json json) => _$AuthModelFromJson(json);

  /// Converts this instance to a JSON map.
  Json toJson() => _$AuthModelToJson(this);

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
