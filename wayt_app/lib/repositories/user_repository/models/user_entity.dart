import 'package:a2f_sdk/a2f_sdk.dart';

abstract interface class UserEntity
    implements Entity, UniquelyIdentifiableEntity {
  /// The user's first name.
  String get firstName;

  /// The user's last name.
  String get lastName;

  /// The user's email.
  String get email;
}
