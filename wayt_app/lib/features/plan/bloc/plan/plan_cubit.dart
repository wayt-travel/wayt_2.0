import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../error/errors.dart';
import '../../../../orchestration/fetch_plan_orchestrator.dart';
import '../../../../repositories/repositories.dart';

part 'plan_state.dart';

/// Cubit for the plan screen.
///
/// TODO: turn it into a TravelItemCubit that supports plans and journals as
/// well
class PlanCubit extends Cubit<PlanState> with LoggerMixin {
  /// The ID of the plan.
  final String planId;

  final TravelItemRepository travelItemRepository;
  final PlanRepository planRepository;
  final FetchPlanOrchestrator fetchPlanOrchestrator;

  /// The subscription to the [planRepository].
  StreamSubscription<PlanRepositoryState>? _planSubscription;

  /// The subscription to the [travelItemRepository].
  StreamSubscription<TravelItemRepositoryState>? _travelItemRepoSub;

  /// Creates a [PlanCubit].
  PlanCubit({
    required this.planId,
    required this.planRepository,
    required this.travelItemRepository,
    required SummaryHelperRepository summaryHelperRepository,
  })  : fetchPlanOrchestrator = FetchPlanOrchestrator(
          planRepository: planRepository,
          travelItemRepository: travelItemRepository,
          summaryHelperRepository: summaryHelperRepository,
        ),
        super(PlanInitial()) {
    // Listen to the plan repository and update the state accordingly
    _planSubscription = planRepository.listen((repoState) {
      if (isClosed) return;
      if (repoState is PlanRepositoryPlanFetched &&
          repoState.item.id == planId) {
        emit(
          PlanFetchSuccess(
            plan: repoState.item,
            travelItems: travelItemRepository.getAllOfPlan(planId),
          ),
        );
      } else if (repoState is PlanRepositoryPlanUpdated &&
          repoState.updatedItem.id == planId) {
        emit(
          PlanSummaryUpdateSuccess(
            plan: repoState.updatedItem,
            travelItems: travelItemRepository.getAllOfPlan(planId),
          ),
        );
      }
    });

    // Listen to the widget repository and update the state accordingly
    _travelItemRepoSub = travelItemRepository.listen((repoState) {
      // Whether a new widget has been added to the plan.
      final hasAddedWidget = repoState is TravelItemRepositoryTravelItemAdded &&
          repoState.item.value.travelDocumentId.id == planId;
      // Whether a widget has been deleted from the plan.
      final hasDeletedWidget =
          repoState is TravelItemRepositoryTravelItemDeleted &&
              repoState.item.value.travelDocumentId.id == planId;
      // Whether the collection of widgets has been fetched.
      final hasFetchedCollection =
          repoState is TravelItemRepositoryTravelItemCollectionFetched &&
              repoState.items
                  .any((widget) => widget.value.travelDocumentId.id == planId);
      // If any of the above conditions is true, emit a new state to update
      // the plan items list.
      if (hasAddedWidget || hasDeletedWidget || hasFetchedCollection) {
        emit(
          PlanItemListUpdateSuccess(
            plan: planRepository.getOrThrow(planId),
            travelItems: travelItemRepository.getAllOfPlan(planId),
          ),
        );
      }
    });
  }

  /// Fetches the plan with id=[planId].
  ///
  /// If [force] is true, the plan will be fetched even if it is already fully
  /// loaded in the repository. This parameter is passed to the orchestrator.
  Future<void> fetch({required bool force}) async {
    logger.v('Fetching plan $planId');
    emit(PlanFetchInProgress());
    try {
      await fetchPlanOrchestrator.fetchPlan(planId: planId, force: force);
      logger.d(
        'Plan $planId fetched. The new state will be emitted via the repo '
        'listener',
      );
    } catch (e, s) {
      logger.e('Failed to fetch plan $planId', e, s);
      emit(PlanFetchFailure(e.errorOrGeneric));
    }
  }

  @override
  Future<void> close() {
    _planSubscription?.cancel().ignore();
    _travelItemRepoSub?.cancel().ignore();
    return super.close();
  }
}
