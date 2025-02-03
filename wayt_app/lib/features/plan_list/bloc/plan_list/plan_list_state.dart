part of 'plan_list_cubit.dart';

/// State for the [PlanListCubit].
final class PlanListState extends SuperBlocState<WError> {
  /// The plans to display.
  final List<PlanEntity> plans;

  const PlanListState._({
    required this.plans,
    required super.status,
    super.error,
  });

  /// Initial state of the cubit.
  const PlanListState.initial()
      : plans = const [],
        super.initial();

  @override
  PlanListState copyWith({
    required StateStatus status,
    List<PlanEntity>? plans,
  }) =>
      PlanListState._(
        plans: plans ?? this.plans,
        error: error,
        status: status,
      );

  @override
  PlanListState copyWithError(WError error) => PlanListState._(
        plans: plans,
        error: error,
        status: StateStatus.failure,
      );

  @override
  String toString() => '$PlanListState { status: $status }';

  @override
  List<Object?> get props => [plans, ...super.props];
}
