import 'package:equatable/equatable.dart';

import '../../repositories.dart';

abstract interface class AuthEntity implements Equatable {
  UserEntity? get user;
}
