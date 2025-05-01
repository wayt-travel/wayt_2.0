import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:wayt_app/repositories/repositories.dart';

import 'mock_path_provider.dart';

final class MockTravelItemRepository extends Mock
    implements TravelItemRepository {}

final class MockAuthRepository extends Mock implements AuthRepository {}

final class MockTravelDocumentLocalMediaDataSource extends Mock
    implements TravelDocumentLocalMediaDataSource {
  MockTravelDocumentLocalMediaDataSource() {
    registerFallbackValue(const Uuid().v4());
    registerFallbackValue(TravelDocumentId.journal(const Uuid().v4()));
    when(
      () => getMediaPath(
        folderId: any(named: 'folderId'),
        travelDocumentId: any(named: 'travelDocumentId'),
        mediaExtension: any(named: 'mediaExtension'),
        mediaWidgetFeatureId: any(named: 'mediaWidgetFeatureId'),
      ),
    ).thenReturn(join(kVeryRandomRoot, const Uuid().v4()));
    when(
      () => buildMediaPath(
        travelDocumentId: any(named: 'travelDocumentId'),
        folderId: any(named: 'folderId'),
        suffix: any(named: 'suffix'),
        userId: any(named: 'userId'),
      ),
    ).thenReturn(join(kVeryRandomRoot, const Uuid().v4()));
  }
}
