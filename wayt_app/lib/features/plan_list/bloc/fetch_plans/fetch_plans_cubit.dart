import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../core/context/context.dart';
import '../../../../error/error.dart';
import '../../../../repositories/repositories.dart';

part 'fetch_plans_state.dart';

class FetchPlansCubit extends Cubit<FetchPlansState> with LoggerMixin {
  final PlanRepository planRepository;
  StreamSubscription<RepositoryState<PlanSummaryEntity>>? _plansSubscription;
  FetchPlansCubit({
    required this.planRepository,
  }) : super(const FetchPlansState.initial()) {
    _plansSubscription = planRepository.listen((repoState) {
      if (isClosed) return;
      if (repoState is PlanRepositoryPlanCollectionFetched) {
        emit(
          state.copyWith(
            status: StateStatus.success,
            plans: repoState.items,
          ),
        );
      }
    });
  }

  Future<void> fetch() async {
    logger.v('Fetching plans');
    emit(state.copyWith(status: StateStatus.progress));
    final user = $.repo.auth().item?.user;
    if (user == null) {
      logger.e('The user is not authenticated. Cannot fetch plans');
      emit(state.copyWithError($.errors.auth.unauthenticated));
      return;
    }
    try {
      await planRepository.fetchAllOfUser(user.id);
    } catch (e, s) {
      logger.e('Failed to fetch plans of user $user', e, s);
      emit(state.copyWithError(e.errorOrGeneric));
    }
  }

  @override
  Future<void> close() {
    _plansSubscription?.cancel().ignore();
    return super.close();
  }
}
