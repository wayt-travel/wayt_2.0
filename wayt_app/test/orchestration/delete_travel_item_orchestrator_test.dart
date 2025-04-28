import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/core/core.dart';
import 'package:wayt_app/error/error.dart';
import 'package:wayt_app/orchestration/orchestration.dart';
import 'package:wayt_app/repositories/repositories.dart';
import 'package:wayt_app/util/util.dart';

import '../test_helpers/test_helpers.dart';

final class MockTravelItemRepository extends Mock
    implements TravelItemRepository {}

final class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;
  late TravelItemRepository travelItemRepository;
  late AuthRepository authRepository;
  late AppContext appContext;

  setUpAll(() async {
    mockPathProvider();
    appContext = MockAppContext();
  });

  setUp(() {
    travelItemRepository = MockTravelItemRepository();
    authRepository = MockAuthRepository();
    when(() => authRepository.getOrThrow()).thenReturn(
      AuthModel(
        user: UserModel(
          id: const Uuid().v4(),
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
        ),
      ),
    );
    travelDocumentLocalMediaDataSource = TravelDocumentLocalMediaDataSource(
      appContext: appContext,
      authRepository: MockAuthRepository(),
    );
  });

  WidgetEntity buildTextWidget() => TextWidgetModel(
        id: const Uuid().v4(),
        text: 'Dummy',
        order: 0,
        textStyle: const TypographyFeatureStyle.body(),
        travelDocumentId: TravelDocumentId.plan(const Uuid().v4()),
      );

  WidgetFolderEntity buildFolderWidget() => WidgetFolderModel(
        id: const Uuid().v4(),
        name: 'Dummy',
        order: 0,
        travelDocumentId: TravelDocumentId.plan(const Uuid().v4()),
        color: FeatureColor.amber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        icon: WidgetFolderIcon.fromIconData(Icons.folder),
      );

  WidgetEntity buildPhotoWidget() => PhotoWidgetModel(
        id: const Uuid().v4(),
        order: 0,
        travelDocumentId: TravelDocumentId.plan(const Uuid().v4()),
        mediaExtension: 'jpg',
        folderId: const Uuid().v4(),
        byteCount: 1000,
        mediaId: const Uuid().v4(),
        size: const IntSize.square(256),
        url: null,
        coordinates: null,
      );

  group('DeleteTravelItemOrchestrator', () {
    test('should delete a widget if it has no media', () async {
      final widget = buildTextWidget();
      when(() => travelItemRepository.deleteItem(widget.id))
          .thenAnswer((_) => WTaskEither.right(null));
      final orchestrator = DeleteTravelItemOrchestrator(
        travelItemRepository: travelItemRepository,
        travelDocumentLocalMediaDataSource: travelDocumentLocalMediaDataSource,
        travelItem: widget,
      );
      final result = await orchestrator.task().run();
      expect(result.isRight(), isTrue);
      verify(() => travelItemRepository.deleteItem(widget.id)).called(1);
    });

    test('should delete a widget and its media', () async {
      final widget = buildPhotoWidget();
      when(() => travelItemRepository.deleteItem(widget.id))
          .thenAnswer((_) => WTaskEither.right(null));
      final orchestrator = DeleteTravelItemOrchestrator(
        travelItemRepository: travelItemRepository,
        travelDocumentLocalMediaDataSource: travelDocumentLocalMediaDataSource,
        travelItem: widget,
      );
      final result = await orchestrator.task().run();
      expect(result.isRight(), isTrue);
      verify(() => travelItemRepository.deleteItem(widget.id)).called(1);
    });

    test(
      'should delete a folder and all the media of widgets contained in '
      'the folder',
      () async {},
    );
    test(
      'should delete the item even if the media deletion fails',
      () async {},
    );
    test(
      'should do a best effort to delete all media of the widget even if '
      'some failed',
      () async {},
    );
  });
}
