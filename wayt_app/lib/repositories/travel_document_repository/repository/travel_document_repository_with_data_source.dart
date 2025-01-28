import '../../repositories.dart';

/// Interface that exposes the [TravelDocumentDataSource] instance of the
/// repository.
abstract interface class TravelDocumentRepositoryWithDataSource
    implements TravelDocumentRepository {
  /// The data source of the repository.
  TravelDocumentDataSource get dataSource;
}
