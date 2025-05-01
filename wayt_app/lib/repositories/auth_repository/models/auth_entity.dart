import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

/// The entity that represents the authenticated user.
abstract interface class AuthEntity implements Entity {
  /// The authenticated user.
  UserEntity? get user;
}
