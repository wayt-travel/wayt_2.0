import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../repositories/repositories.dart';

/// Orchestrates the fetching of a [TravelDocumentEntity].
///
/// This class is responsible for orchestrating the fetching of a
/// [TravelDocumentEntity]:
/// 1. It fetches the travel document from the travel document data source.
/// 2. It adds the travel document to the travel document repository.
/// 3. It adds the widgets/folder contained in the travel document to the travel
///    item repository.
final class FetchTravelDocumentOrchestrator with LoggerMixin {
  /// The travel document repository.
  final TravelDocumentRepositoryWithDataSource travelDocumentRepository;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The summary helper repository.
  final SummaryHelperRepository summaryHelperRepository;

  /// Creates a new instance of [FetchTravelDocumentOrchestrator].
  FetchTravelDocumentOrchestrator({
    required TravelDocumentRepository travelDocumentRepository,
    required this.travelItemRepository,
    required this.summaryHelperRepository,
  }) : travelDocumentRepository =
            travelDocumentRepository as TravelDocumentRepositoryWithDataSource;

  /// Fetches a travel document by its [travelDocumentId].
  Future<void> fetchTravelDocument({
    required TravelDocumentId travelDocumentId,
    required bool force,
  }) async {
    logger.d('Fetching $travelDocumentId [force=$force]');
    if (!force) {
      final cachedTd = travelDocumentRepository.cache.get(travelDocumentId.id);
      if (cachedTd == null) {
        logger.d(
          'Travel document with id $travelDocumentId not found in repository. '
          'It will be fetched',
        );
      } else if (!summaryHelperRepository.isFullyLoaded(travelDocumentId)) {
        logger.v(
          '$travelDocumentId found in repository cache but it is '
          'not fully loaded, it will be fully fetched',
        );
      } else {
        logger.i(
          '${cachedTd.toShortString()} found in repository cache. No need '
          'to fetch it. It will be used as is',
        );
        // Readd the travel document to the repository to trigger a state
        // change.
        travelDocumentRepository.add(cachedTd, shouldEmit: true);
        return;
      }
    }

    logger.v('Fetching $travelDocumentId from the data source');
    final wrapper =
        await travelDocumentRepository.dataSource.readById(travelDocumentId.id);
    final travelDocument = wrapper.travelDocument;
    final travelItems = wrapper.travelItems;

    logger.i(
      '${travelDocument.toShortString()} and ${travelItems.length} travel '
      'items fetched from the data source',
    );

    // No need to emit the state here as the travel document has just been
    // fetched.
    await travelItemRepository.addSequentialAndWait<void>(
      TravelItemRepoItemsAddedEvent(
        shouldEmit: false,
        travelItems: travelItems,
      ),
    );

    // The travel document has been fully fetched and its items have been
    // loaded completely.
    summaryHelperRepository.setFullyLoaded(travelDocumentId);

    // NB: The travel document is added to the repository after the widgets and
    // widget folders as it will trigger a state change in the repository. The
    // emission of the state is the trigger to update the UI and the UI should
    // be updated only after all the data has been fetched and loaded.
    travelDocumentRepository.add(travelDocument, shouldEmit: true);
  }
}
