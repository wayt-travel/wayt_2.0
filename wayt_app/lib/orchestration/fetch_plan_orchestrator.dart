import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../repositories/repositories.dart';

/// Orchestrates the fetching of a [PlanEntity].
///
/// This class is responsible for orchestrating the fetching of a [PlanEntity]:
/// 1. It fetches the plan from the plan data source.
/// 2. It adds the plan to the plan repository.
/// 3. It adds the widgets contained in the plan to the widget repository.
/// 4. It adds the widget folders contained in the plan to the widget folder.
final class FetchPlanOrchestrator with LoggerMixin {
  /// The plan repository.
  final PlanRepositoryWithDataSource planRepository;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The summary helper repository.
  final SummaryHelperRepository summaryHelperRepository;

  /// Creates a new instance of [FetchPlanOrchestrator].
  FetchPlanOrchestrator({
    required PlanRepository planRepository,
    required this.travelItemRepository,
    required this.summaryHelperRepository,
  }) : planRepository = planRepository as PlanRepositoryWithDataSource;

  /// Fetches a plan by its [planId].
  Future<void> fetchPlan({
    required String planId,
    required bool force,
  }) async {
    logger.d('Fetching plan with id: $planId [force=$force]');
    if (!force) {
      final cachedPlan = planRepository.cache.get(planId);
      if (cachedPlan == null) {
        logger.d(
          'Plan with id $planId not found in repository. It will be fetched',
        );
      } else if (!summaryHelperRepository
          .isFullyLoaded(TravelDocumentId.plan(planId))) {
        logger.v(
          'Plan with id $planId found in repository cache but it is '
          'not fully loaded, it will be fully fetched',
        );
      } else {
        logger.i(
          '${cachedPlan.toShortString()} found in repository cache. No need '
          'to fetch it. It will be used as is',
        );
        // Readd the plan to the repository to trigger a state change.
        planRepository.add(cachedPlan, shouldEmit: true);
        return;
      }
    }

    logger.v('Fetching plan $planId from the data source');
    final wrapper = await planRepository.dataSource.readById(planId);
    final plan = wrapper.travelDocument;
    final travelItems = wrapper.travelItems;

    logger.i(
      '${plan.toShortString()} and ${travelItems.length} travel items fetched '
      'from the data source',
    );

    // No need to emit the state here as the plan has just been fetched.
    travelItemRepository.addAll(
      travelDocumentId: TravelDocumentId.plan(planId),
      travelItems: wrapper.travelItems,
      shouldEmit: false,
    );

    // NB: The plan is added to the repository after the widgets and widget
    // folders as it will trigger a state change in the repository.
    // The emission of the state is the trigger to update the UI and the
    // UI should be updated only after all the data has been fetched and loaded.
    planRepository.add(plan, shouldEmit: true);
  }
}
