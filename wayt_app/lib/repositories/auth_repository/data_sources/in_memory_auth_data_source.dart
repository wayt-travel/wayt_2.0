import 'package:flext/flext.dart';

import '../../../error/exceptions/sign_in_failed_exception.dart';
import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// In-memory implementation of the Auth data source.
final class InMemoryAuthDataSource implements AuthDataSource {
  final InMemoryData _data;

  InMemoryAuthDataSource(this._data);

  @override
  Future<AuthEntity> signIn({
    required String email,
    required String password,
  }) async =>
      _data.users.values
          .firstWhere(
            (e) => e.email == email,
            orElse: () => throw SignInFailedException(),
          )
          .let((user) => AuthModel(user: user));

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
