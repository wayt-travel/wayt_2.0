import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/orchestration/orchestration.dart';
import 'package:wayt_app/repositories/repositories.dart';

import '../test_helpers/test_helpers.dart';

void main() {
  late TravelDocumentId travelDocumentId;
  late TravelItemRepository travelItemRepository;
  late TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;
  late DummyTestData dummyTestData;

  setUp(() {
    travelDocumentId = TravelDocumentId.journal(const Uuid().v4());
    dummyTestData = DummyTestData(travelDocumentId);
    travelItemRepository = MockTravelItemRepository();
    travelDocumentLocalMediaDataSource =
        MockTravelDocumentLocalMediaDataSource();
  });

  MoveTravelMediaOrchestrator getOrchestrator({
    required List<TravelItemEntity> travelItemsToMove,
    required String? destinationFolderId,
  }) =>
      MoveTravelMediaOrchestrator(
        travelItemRepository: travelItemRepository,
        travelDocumentLocalMediaDataSource: travelDocumentLocalMediaDataSource,
        travelItemsToMove: travelItemsToMove,
        destinationFolderId: destinationFolderId,
        travelDocumentId: travelDocumentId,
      );

  group('MoveTravelMediaOrchestrator.getMediaList', () {
    test('should ignore folders', () async {
      final travelItemsToMove = [
        dummyTestData.buildFolderWidget(),
        dummyTestData.buildPhotoWidget(),
        dummyTestData.buildPhotoWidget(),
      ];

      final mediaList = getOrchestrator(
        travelItemsToMove: travelItemsToMove,
        destinationFolderId: null,
      ).getMediaList();

      expect(mediaList, hasLength(2));
    });

    test('should extract media features only', () async {
      final travelItemsToMove = [
        dummyTestData.buildTextWidget(),
        dummyTestData.buildTextWidget(),
        dummyTestData.buildTextWidget(),
        dummyTestData.buildTextWidget(),
        dummyTestData.buildTextWidget(),
        dummyTestData.buildPhotoWidget(),
        dummyTestData.buildPhotoWidget(),
      ];

      final mediaList = getOrchestrator(
        travelItemsToMove: travelItemsToMove,
        destinationFolderId: null,
      ).getMediaList();

      expect(mediaList, hasLength(2));
      expect(
        mediaList,
        everyElement(
          predicate<({String destination, String source})>(
            (element) =>
                element.source.isNotEmpty && element.destination.isNotEmpty,
          ),
        ),
      );
    });
  });
}
