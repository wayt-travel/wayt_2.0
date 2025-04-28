import 'package:a2f_sdk/a2f_sdk.dart';

import 'models.dart';

/// The model that represents a user in the application.
class UserModel extends Model implements UserEntity {
  @override
  final String id;

  @override
  final String email;

  @override
  final String firstName;

  @override
  final String lastName;

  /// Creates a new instance of [UserModel].
  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
      };

  @override
  List<Object?> get props => [id, email, firstName, lastName];

  /// Creates a new instance of [UserModel] with the same properties as this
  /// instance replaced by the given properties.
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}
