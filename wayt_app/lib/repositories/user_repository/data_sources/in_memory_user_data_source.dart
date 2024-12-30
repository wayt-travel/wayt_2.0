import 'package:get_it/get_it.dart';

import '../../../error/error.dart';
import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// In-memory implementation of the User data source.
final class InMemoryUserDataSource implements UserDataSource {
  final InMemoryData _data;

  InMemoryUserDataSource(this._data);

  @override
  Future<UserModel> read(String id) async => _data.users.getOrThrow(id);

  @override
  Future<UserEntity> readMe() async {
    final authUser = GetIt.I.get<AuthRepository>().item;
    if (authUser == null || authUser.user == null) {
      throw UnauthenticatedException();
    }
    return authUser.user!;
  }
}
