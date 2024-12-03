import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../user_repository/user_repository.dart';

class MockUserDataSource extends Mock implements UserDataSource {}

class MockUser extends Mock implements UserEntity {}

void main() {
  late MockUserDataSource mockUserDataSource;
  late UserRepository repo;

  setUp(() {
    mockUserDataSource = MockUserDataSource();
    repo = UserRepository(mockUserDataSource);

    registerFallbackValue(MockUser());
  });
}
