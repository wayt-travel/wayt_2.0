import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/error/error.dart';
import 'package:wayt_app/orchestration/orchestration.dart';
import 'package:wayt_app/repositories/repositories.dart';

import '../test_helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;
  late TravelItemRepository travelItemRepository;
  late AuthRepository authRepository;
  late TravelDocumentId travelDocumentId;
  late DummyTestData dummyTestData;

  setUpAll(() {
    travelDocumentId = TravelDocumentId.plan(const Uuid().v4());
    dummyTestData = DummyTestData(travelDocumentId);
    registerFallbackValue(const Uuid().v4());
    registerFallbackValue(travelDocumentId);
    registerFallbackValue(dummyTestData.buildFolderWidget());
    registerFallbackValue(dummyTestData.buildTextWidget());
    registerFallbackValue(dummyTestData.buildPhotoWidget());
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
    travelDocumentLocalMediaDataSource =
        MockTravelDocumentLocalMediaDataSource();
  });

  group('DeleteTravelItemOrchestrator', () {
    test('should delete a widget if it has no media', () async {
      final widget = dummyTestData.buildTextWidget();
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

    // The media does not exist but the deletion should never raise an error,
    // so it will look like the media was deleted.
    test('should delete a widget and its media', () async {
      final widget = dummyTestData.buildPhotoWidget();
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
      () async {
        final folder = dummyTestData.buildFolderWidget();
        final textWidget = dummyTestData.buildTextWidget(folderId: folder.id);
        final photoWidget = dummyTestData.buildPhotoWidget(folderId: folder.id);
        when(
          () => travelItemRepository.deleteItem(
            any(that: anyOf(folder.id, textWidget.id, photoWidget.id)),
          ),
        ).thenAnswer((_) => WTaskEither.right(null));
        final orchestrator = DeleteTravelItemOrchestrator(
          travelItemRepository: travelItemRepository,
          travelDocumentLocalMediaDataSource:
              travelDocumentLocalMediaDataSource,
          travelItem: folder,
        );
        final result = await orchestrator.task().run();
        expect(result.isRight(), isTrue);
        verify(() => travelItemRepository.deleteItem(folder.id)).called(1);
        verifyNever(() => travelItemRepository.deleteItem(textWidget.id));
        verifyNever(() => travelItemRepository.deleteItem(photoWidget.id));
        verify(
          () => travelDocumentLocalMediaDataSource.buildMediaPath(
            travelDocumentId: travelDocumentId,
            folderId: folder.id,
            suffix: any(named: 'suffix'),
            userId: any(named: 'userId'),
          ),
        ).called(1);
      },
    );

    // Untestable
    test(
      'should do a best effort to delete all media of the widget even if '
      'some failed',
      () async {},
      skip: true,
    );

    test(
      'should not delete any media and return an error if the item delete '
      'fails in the repository',
      () async {
        final widget = dummyTestData.buildPhotoWidget();
        when(() => travelItemRepository.deleteItem(widget.id))
            .thenAnswer((_) => WTaskEither.left($errors.core.badState));
        final orchestrator = DeleteTravelItemOrchestrator(
          travelItemRepository: travelItemRepository,
          travelDocumentLocalMediaDataSource:
              travelDocumentLocalMediaDataSource,
          travelItem: widget,
        );
        final result = await orchestrator.task().run();
        expect(result.isLeft(), isTrue);
        expect(
          result.getLeft().getOrElse(() => throw Exception()),
          $errors.core.badState,
        );
        verifyNever(
          () => travelDocumentLocalMediaDataSource.getMediaPath(
            travelDocumentId: travelDocumentId,
            folderId: widget.folderId,
            mediaWidgetFeatureId: widget.id,
            mediaExtension: widget.mediaExtension,
          ),
        );
      },
    );
  });
}
