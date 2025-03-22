part of 'upsert_plan_cubit.dart';

/// State for the [UpsertPlanCubit].
final class UpsertPlanState extends SuperBlocState<WError> {
  /// The name of the plan.
  final String? name;

  /// The planned date of the plan.
  final DateTime? plannedAt;

  /// Whether the month is set in the [plannedAt] date.
  final bool isMonthSet;

  /// Whether the day is set in the [plannedAt] date.
  final bool isDaySet;

  const UpsertPlanState._({
    required this.name,
    required this.plannedAt,
    required this.isMonthSet,
    required this.isDaySet,
    required super.status,
    super.error,
  });

  /// Creates an initial state of the [UpsertPlanCubit].
  UpsertPlanState.initial(PlanEntity? planToUpdate)
      : name = planToUpdate?.name,
        plannedAt = planToUpdate?.plannedAt,
        isMonthSet = planToUpdate?.isMonthSet ?? false,
        isDaySet = planToUpdate?.isDaySet ?? false,
        super.initial();

  @override
  UpsertPlanState copyWith({
    required StateStatus status,
    String? name,
    Option<DateTime?> plannedAt = const Option.none(),
    bool? isMonthSet,
    bool? isDaySet,
  }) =>
      UpsertPlanState._(
        name: name ?? this.name,
        plannedAt: plannedAt.getOrElse(() => this.plannedAt),
        isMonthSet: isMonthSet ?? this.isMonthSet,
        isDaySet: isDaySet ?? this.isDaySet,
        error: error,
        status: status,
      );

  @override
  UpsertPlanState copyWithError(WError error) => UpsertPlanState._(
        name: name,
        plannedAt: plannedAt,
        isMonthSet: isMonthSet,
        isDaySet: isDaySet,
        error: error,
        status: StateStatus.failure,
      );

  @override
  List<Object?> get props => [
        name,
        plannedAt,
        isMonthSet,
        isDaySet,
        ...super.props,
      ];
}
