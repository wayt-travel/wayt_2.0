import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../auth_repository/auth_repository.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockCredentials extends Mock implements CredentialsEntity {}

void main() {
  late MockAuthDataSource mockAuthDataSource;
  late AuthRepository repo;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    repo = AuthRepository(mockAuthDataSource);

    registerFallbackValue(MockCredentials());
  });
}
