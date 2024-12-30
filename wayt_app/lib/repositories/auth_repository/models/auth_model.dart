import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

class AuthModel extends Model implements AuthEntity {
  @override
  final UserEntity? user;

  const AuthModel({
    required this.user,
  });

  @override
  Map<String, dynamic> $toMap() => {
        'user': user?.id,
      };

  @override
  List<Object?> get props => [user];

  AuthModel copyWith({
    Optional<UserEntity?> user = const Optional.absent(),
  }) {
    return AuthModel(
      user: user.orElseIfAbsent(this.user),
    );
  }
}
