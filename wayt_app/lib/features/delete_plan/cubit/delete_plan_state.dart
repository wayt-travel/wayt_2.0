part of 'delete_plan_cubit.dart';

/// State for the [DeletePlanCubit].
final class DeletePlanState extends SuperBlocState<WError> {
  const DeletePlanState._({
    required super.status,
    super.error,
  });

  /// Initial state of the cubit.
  const DeletePlanState.initial() : super.initial();

  @override
  DeletePlanState copyWith({required StateStatus status}) {
    return DeletePlanState._(
      status: status,
    );
  }

  @override
  DeletePlanState copyWithError(WError error) {
    return DeletePlanState._(
      status: StateStatus.failure,
      error: error,
    );
  }
}
