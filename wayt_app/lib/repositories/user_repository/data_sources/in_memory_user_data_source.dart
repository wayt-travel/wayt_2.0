import 'package:get_it/get_it.dart';

import '../../../error/error.dart';
import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// In-memory implementation of the User data source.
final class InMemoryUserDataSource implements UserDataSource {
  final InMemoryDataHelper _dataHelper;

  /// Creates a new instance of [InMemoryUserDataSource].
  InMemoryUserDataSource(this._dataHelper);

  @override
  Future<UserModel> read(String id) async => _dataHelper.getUser(id);

  @override
  Future<UserEntity> readMe() async {
    final authUser = GetIt.I.get<AuthRepository>().item;
    if (authUser == null || authUser.user == null) {
      throw UnauthenticatedException();
    }
    return authUser.user!;
  }
}
