import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../error/errors.dart';
import '../../../../orchestration/fetch_travel_document_orchestrator.dart';
import '../../../../repositories/repositories.dart';

part 'travel_document_state.dart';

/// Cubit for the travel document screen.
class TravelDocumentCubit<T extends TravelDocumentEntity>
    extends Cubit<TravelDocumentState<T>> with LoggerMixin {
  /// The ID of the travel document.
  final TravelDocumentId travelDocumentId;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document repository.
  final TravelDocumentRepository travelDocumentRepository;

  /// The orchestrator for fetching the travel document.
  final FetchTravelDocumentOrchestrator fetchTravelDocumentOrchestrator;

  /// The subscription to the [travelDocumentRepository].
  StreamSubscription<TravelDocumentRepositoryState>?
      _travelDocumentSubscription;

  /// The subscription to the [travelItemRepository].
  StreamSubscription<TravelItemRepositoryState>? _travelItemRepoSub;

  /// Creates a [TravelDocumentCubit].
  TravelDocumentCubit({
    required this.travelDocumentId,
    required this.travelDocumentRepository,
    required this.travelItemRepository,
    required SummaryHelperRepository summaryHelperRepository,
  })  : fetchTravelDocumentOrchestrator = FetchTravelDocumentOrchestrator(
          travelDocumentRepository: travelDocumentRepository,
          travelItemRepository: travelItemRepository,
          summaryHelperRepository: summaryHelperRepository,
        ),
        super(TravelDocumentInitial()) {
    // Listen to the travel document repository and update the state accordingly
    _travelDocumentSubscription = travelDocumentRepository.listen((repoState) {
      if (isClosed) return;
      if (repoState is TravelDocumentRepositoryItemFetched &&
          repoState.item is T &&
          repoState.item.tid == travelDocumentId) {
        emit(
          TravelDocumentFetchSuccess(
            TravelDocumentWrapper(
              travelDocument: repoState.item as T,
              travelItems: travelItemRepository.getAllOf(travelDocumentId),
            ),
          ),
        );
      } else if (repoState is TravelDocumentRepositoryItemUpdated &&
          repoState.updatedItem is T &&
          repoState.updatedItem.tid == travelDocumentId) {
        emit(
          TravelDocumentSummaryUpdateSuccess(
            TravelDocumentWrapper(
              travelDocument: repoState.updatedItem as T,
              travelItems: T is PlanEntity
                  ? travelItemRepository.getAllOfPlan(travelDocumentId.id)
                  : travelItemRepository.getAllOfJournal(travelDocumentId.id),
            ),
          ),
        );
      }
    });

    // Listen to the travel items repository and update the state accordingly
    _travelItemRepoSub = travelItemRepository.listen((repoState) {
      // Whether a new item has been added to the travel document.
      final hasAddedWidget = repoState is TravelItemRepositoryTravelItemAdded &&
          repoState.item.value.travelDocumentId == travelDocumentId;
      // Whether an item has been deleted from the travel document.
      final hasDeletedWidget =
          repoState is TravelItemRepositoryTravelItemDeleted &&
              repoState.item.value.travelDocumentId == travelDocumentId;
      // Whether the collection of travel items has been fetched.
      final hasFetchedCollection =
          repoState is TravelItemRepositoryTravelItemCollectionFetched &&
              repoState.items.any(
                (widget) => widget.value.travelDocumentId == travelDocumentId,
              );
      // If any of the above conditions is true, emit a new state to update
      // the travel document items list.
      if (hasAddedWidget || hasDeletedWidget || hasFetchedCollection) {
        emit(
          TravelDocumentItemListUpdateSuccess(
            TravelDocumentWrapper(
              travelDocument:
                  travelDocumentRepository.getOrThrow(travelDocumentId.id) as T,
              travelItems: T is PlanEntity
                  ? travelItemRepository.getAllOfPlan(travelDocumentId.id)
                  : travelItemRepository.getAllOfJournal(travelDocumentId.id),
            ),
          ),
        );
      }
    });
  }

  /// Fetches the travel document with id=[travelDocumentId].
  ///
  /// If [force] is true, the travel document will be fetched even if it is
  /// already fully loaded in the repository. This parameter is passed to the
  /// orchestrator.
  Future<void> fetch({required bool force}) async {
    logger.v('Fetching $travelDocumentId');
    emit(TravelDocumentFetchInProgress());
    try {
      await fetchTravelDocumentOrchestrator.fetchTravelDocument(
        travelDocumentId: travelDocumentId,
        force: force,
      );
      logger.d(
        '$travelDocumentId fetched. The new state will be emitted via the repo '
        'listener',
      );
    } catch (e, s) {
      logger.e('Failed to fetch $travelDocumentId', e, s);
      emit(TravelDocumentFetchFailure(e.errorOrGeneric));
    }
  }

  @override
  Future<void> close() {
    _travelDocumentSubscription?.cancel().ignore();
    _travelItemRepoSub?.cancel().ignore();
    return super.close();
  }
}
