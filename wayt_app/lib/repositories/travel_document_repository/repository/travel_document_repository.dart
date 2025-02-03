import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';

import '../../repositories.dart';

part '_travel_document_repository_impl.dart';
part 'travel_document_repository_state.dart';

/// The repository for travel documents (journals and plans).
abstract interface class TravelDocumentRepository extends Repository<String,
    TravelDocumentEntity, TravelDocumentRepositoryState> {
  /// Creates a new instance of [TravelDocumentRepository] that uses the
  /// provided data source.
  factory TravelDocumentRepository({
    required TravelDocumentDataSource dataSource,
    required SummaryHelperRepository summaryHelperRepository,
  }) =>
      _TravelDocumentRepositoryImpl(dataSource, summaryHelperRepository);

  /// Creates a new Plan.
  Future<PlanEntity> createPlan(CreatePlanInput input);

  /// Fetches all plan of a user.
  Future<List<PlanEntity>> fetchAllPlansOfUser(String userId);

  /// Fetches a full travel document by its [id].
  ///
  /// The document is returned with its items.
  Future<TravelDocumentWrapper> fetchOne(String id);

  /// Deletes a travel document by its [id].
  Future<void> delete(String id);

  /// Adds a travel document to the repository without fetching it from the data
  /// source and without triggering a state change.
  ///
  /// If [shouldEmit] is `true`, the repository will emit a state change.
  ///
  /// See also [addAll].
  void add(TravelDocumentEntity travelDocument, {bool shouldEmit = true});

  /// Adds multiple travel documents to the repository without fetching them
  /// from the data source and without triggering a state change.
  ///
  /// If [shouldEmit] is `true`, the repository will emit a state change.
  ///
  /// See also [add].
  void addAll(
    Iterable<TravelDocumentEntity> travelDocuments, {
    bool shouldEmit = true,
  });

  /// Gets all travel documents of a user.
  List<TravelDocumentEntity> getAllOfUser(String userId);
}
