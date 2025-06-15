import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../repositories.dart';

/// {@template user_entity_json_converter}
/// A [JsonConverter] for [UserEntity].
/// It converts JSON to [UserEntity] and vice versa.
/// {@endtemplate}
class UserEntityJsonConverter extends JsonConverter<UserEntity, Json> {
  /// {@macro user_entity_json_converter}
  const UserEntityJsonConverter();

  @override
  UserEntity fromJson(Map<String, dynamic> json) => UserModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserEntity object) =>
      (object as UserModel).toJson();
}

/// The entity that represents an user in the application.
abstract interface class UserEntity
    implements Entity, UniquelyIdentifiableEntity {
  /// The user's first name.
  String get firstName;

  /// The user's last name.
  String get lastName;

  /// The user's email.
  String get email;
}
