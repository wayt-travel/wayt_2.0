import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../error/error.dart';
import '../../../../orchestration/fetch_plan_orchestrator.dart';
import '../../../../repositories/repositories.dart';

part 'fetch_plan_state.dart';

class FetchPlanCubit extends Cubit<FetchPlanState> with LoggerMixin {
  final String planId;
  final PlanRepository planRepository;
  final WidgetRepository widgetRepository;
  final FetchPlanOrchestrator fetchPlanOrchestrator;
  StreamSubscription<PlanRepositoryState>? _planSubscription;

  FetchPlanCubit({
    required this.planId,
    required this.planRepository,
    required this.widgetRepository,
  })  : fetchPlanOrchestrator = FetchPlanOrchestrator(
          planRepository: planRepository,
          widgetRepository: widgetRepository,
        ),
        super(const FetchPlanState.initial()) {
    _planSubscription = planRepository.listen((repoState) {
      if (repoState is PlanRepositoryPlanFetched &&
          repoState.item.id == planId) {
        emit(
          state.copyWith(
            status: StateStatus.success,
            plan: Optional(repoState.item),
          ),
        );
      }
    });
  }

  Future<void> fetch({required bool force}) async {
    logger.v('Fetching plan $planId');
    emit(state.copyWith(status: StateStatus.progress));
    try {
      await fetchPlanOrchestrator.fetchPlan(planId: planId, force: force);
      logger.d(
        'Plan $planId fetched. The new state will be emitted via the repo '
        'listener',
      );
    } catch (e, s) {
      logger.e('Failed to fetch plan $planId', e, s);
      emit(state.copyWithError(e.errorOrGeneric));
    }
  }

  @override
  Future<void> close() {
    _planSubscription?.cancel().ignore();
    return super.close();
  }
}
