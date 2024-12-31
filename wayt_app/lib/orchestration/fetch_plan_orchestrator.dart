import 'package:flext/flext.dart';
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

  /// The widget repository.
  final WidgetRepository widgetRepository;

  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// Creates a new instance of [FetchPlanOrchestrator].
  FetchPlanOrchestrator({
    required PlanRepository planRepository,
    required this.widgetRepository,
    required this.travelItemRepository,
  }) : planRepository = planRepository as PlanRepositoryWithDataSource;

  /// Fetches a plan by its [planId].
  Future<PlanEntity> fetchPlan({
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
      } else if (cachedPlan is PlanEntity) {
        // Check that all the items of the plan are in the repository.
        final repoItems = travelItemRepository
            .getAllOfPlan(planId)
            .map((item) => item.id)
            .toSet();
        final planItems = cachedPlan.itemIds.toSet();
        if (const SetEquality<String>().equals(repoItems, planItems)) {
          logger.i(
            '${cachedPlan.toShortString()} found in repository cache. No need '
            'to fetch it. It will be used as is',
          );
          planRepository.add(cachedPlan, shouldEmit: true);
          return cachedPlan;
        } else {
          logger.v(
            'Plan with id $planId found in repository cache but it is '
            'not a PlanEntity or its items are not loaded into the items '
            'repository. It will be fully fetched',
          );
        }
      } else {
        logger.v(
          'Plan with id $planId found in repository cache but it is '
          'not a PlanEntity. It will be fully fetched',
        );
      }
    }

    logger.v('Fetching plan $planId from the data source');
    final response = await planRepository.dataSource.readById(planId);
    final (:plan, :travelItems) = response;

    logger.i('${plan.toShortString()} fetched from the data source');
    final widgets =
        travelItems.where((item) => !item.isFolderWidget).cast<WidgetEntity>();
    // No need to emit the state here as the plan has just been fetched.
    widgetRepository.addAll(widgets, shouldEmit: false);

    // TODO: add widget folders to repository
    // final widgetFolders = travelItems
    //     .where((item) => item.isFolderWidget)
    //     .cast<WidgetFolderEntity>();
    // No need to emit the state here as the plan has just been fetched.
    // widgetFolderRepository.addAll(widgetFolders, shouldEmit: false);

    // NB: The plan is added to the repository after the widgets and widget
    // folders as it will trigger a state change in the repository.
    // The emission of the state is the trigger to update the UI.
    planRepository.add(plan, shouldEmit: true);

    return plan;
  }
}
