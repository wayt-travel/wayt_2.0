part of 'fetch_plan_cubit.dart';

final class FetchPlanState extends SuperBlocState<WError> {
  final PlanEntity? plan;

  const FetchPlanState._({
    required this.plan,
    required super.status,
    super.error,
  });

  const FetchPlanState.initial()
      : plan = null,
        super.initial();

  @override
  FetchPlanState copyWith({
    required StateStatus status,
    Optional<PlanEntity?> plan = const Optional.absent(),
  }) =>
      FetchPlanState._(
        plan: plan.orElseIfAbsent(this.plan),
        error: error,
        status: status,
      );

  @override
  FetchPlanState copyWithError(WError error) => FetchPlanState._(
        plan: plan,
        error: error,
        status: status,
      );

  @override
  List<Object?> get props => [plan, ...super.props];
}
