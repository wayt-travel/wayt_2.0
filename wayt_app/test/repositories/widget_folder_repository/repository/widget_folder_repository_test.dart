import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wayt_app/repositories/widget_folder_repository/widget_folder_repository.dart';

class MockWidgetFolderDataSource extends Mock
    implements WidgetFolderDataSource {}

class MockWidgetFolder extends Mock implements WidgetFolderEntity {}

void main() {
  late MockWidgetFolderDataSource mockWidgetFolderDataSource;
  // ignore: unused_local_variable
  late WidgetFolderRepository repo;

  setUp(() {
    mockWidgetFolderDataSource = MockWidgetFolderDataSource();
    repo = WidgetFolderRepository(mockWidgetFolderDataSource);

    registerFallbackValue(MockWidgetFolder());
  });
}
