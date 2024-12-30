import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';

abstract interface class UserEntity
    implements Equatable, UniquelyIdentifiableEntity {
  /// The user's first name.
  String get firstName;

  /// The user's last name.
  String get lastName;

  /// The user's email.
  String get email;
}
