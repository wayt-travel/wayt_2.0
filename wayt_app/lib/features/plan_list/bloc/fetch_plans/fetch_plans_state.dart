part of 'fetch_plans_cubit.dart';

final class FetchPlansState extends SuperBlocState<WError> {
  final List<PlanEntity> plans;

  const FetchPlansState._({
    required this.plans,
    required super.status,
    super.error,
  });

  const FetchPlansState.initial()
      : plans = const [],
        super.initial();

  @override
  FetchPlansState copyWith({
    required StateStatus status,
    List<PlanEntity>? plans,
  }) =>
      FetchPlansState._(
        plans: plans ?? this.plans,
        error: error,
        status: status,
      );

  @override
  FetchPlansState copyWithError(WError error) => FetchPlansState._(
        plans: plans,
        error: error,
        status: StateStatus.failure,
      );

  @override
  String toString() => '$FetchPlansState { status: $status }';

  @override
  List<Object?> get props => [plans, ...super.props];
}
