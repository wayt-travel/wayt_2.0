import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

abstract interface class AuthEntity implements Entity {
  UserEntity? get user;
}
