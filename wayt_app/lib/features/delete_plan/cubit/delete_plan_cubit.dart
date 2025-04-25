import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:bloc/bloc.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../error/error.dart';
import '../../../repositories/repositories.dart';

part 'delete_plan_state.dart';

/// Cubit for deleting a plan.
class DeletePlanCubit extends Cubit<DeletePlanState> with LoggerMixin {
  /// The plan repository.
  final TravelDocumentRepository travelDocumentRepository;

  /// Creates a new instance of [DeletePlanCubit].
  DeletePlanCubit({
    required this.travelDocumentRepository,
  }) : super(const DeletePlanState.initial());

  /// Deletes the plan with id [id].
  Future<void> onDelete(String id) async {
    emit(state.copyWith(status: StateStatus.progress));
    try {
      await travelDocumentRepository.delete(id);
      emit(state.copyWith(status: StateStatus.success));
    } catch (e, s) {
      final msg = 'An error occurred while deleting plan with id: $id';
      logger.e(
        msg,
        e,
        s,
      );
      emit(state.copyWithError(e.errorOrGeneric));
    }
  }
}
