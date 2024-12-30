import 'package:a2f_sdk/a2f_sdk.dart';

import 'models.dart';

class UserModel extends Model implements UserEntity {
  @override
  final String id;

  @override
  final String email;

  @override
  final String firstName;

  @override
  final String lastName;

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
