import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../core/context/context.dart';
import '../../../../error/errors.dart';
import '../../../../repositories/repositories.dart';

part 'plan_list_state.dart';

/// Cubit for managing the list of plans.
class PlanListCubit extends Cubit<PlanListState> with LoggerMixin {
  /// The plan repository.
  final TravelDocumentRepository travelDocumentRepository;

  /// The authentication repository.
  final AuthRepository authRepository;

  StreamSubscription<TravelDocumentRepositoryState>? _plansSubscription;

  /// Creates a new instance of [PlanListCubit].
  PlanListCubit({
    required this.travelDocumentRepository,
    required this.authRepository,
  }) : super(const PlanListState.initial()) {
    _plansSubscription = travelDocumentRepository.listen((repoState) {
      if (isClosed) return;
      final isFetched = repoState is TravelDocumentRepositoryItemFetched;
      final isUpdated = repoState is TravelDocumentRepositoryItemUpdated;
      final isDeleted = repoState is TravelDocumentRepositoryItemDeleted;
      final isAdded = repoState is TravelDocumentRepositoryEntityAdded;
      if (isFetched || isUpdated || isDeleted || isAdded) {
        emit(
          state.copyWith(
            status: StateStatus.success,
            plans: travelDocumentRepository
                .getAllOfUser(authRepository.item!.user!.id)
                .whereType<PlanEntity>()
                .toList(),
          ),
        );
      }
    });
  }

  /// Fetches the plans.
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
      await travelDocumentRepository.fetchAllPlansOfUser(user.id);
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
