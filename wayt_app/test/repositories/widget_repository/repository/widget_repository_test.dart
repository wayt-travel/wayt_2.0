import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wayt_app/repositories/widget_repository/widget_repository.dart';

class MockWidgetDataSource extends Mock implements WidgetDataSource {}

class MockWidget extends Mock implements WidgetEntity {}

void main() {
  // ignore: unused_local_variable
  late MockWidgetDataSource mockWidgetDataSource;
  // ignore: unused_local_variable
  late WidgetRepository repo;

  setUp(() {
    mockWidgetDataSource = MockWidgetDataSource();

    registerFallbackValue(MockWidget());
  });
}
