import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wayt_app/repositories/auth_repository/auth_repository.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockAuth extends Mock implements AuthEntity {}

void main() {
  late MockAuthDataSource mockAuthDataSource;
  late AuthRepository repo;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    repo = AuthRepository(mockAuthDataSource);

    registerFallbackValue(MockAuth());
  });
}
