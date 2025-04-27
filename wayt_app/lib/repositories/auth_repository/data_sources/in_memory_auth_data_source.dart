import '../../../error/exceptions/sign_in_failed_exception.dart';
import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// {@template in_memory_auth_data_source}
/// In-memory implementation of the Auth data source.
/// {@endtemplate}
final class InMemoryAuthDataSource implements AuthDataSource {
  final InMemoryDataHelper _dataHelper;

  /// {@macro in_memory_auth_data_source}
  InMemoryAuthDataSource(this._dataHelper);

  @override
  Future<AuthEntity> signIn({
    required String email,
    required String password,
  }) async {
    final user = _dataHelper.tryGetUserByEmail(email);
    if (user == null) {
      throw SignInFailedException();
    }
    return AuthModel(user: user);
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
