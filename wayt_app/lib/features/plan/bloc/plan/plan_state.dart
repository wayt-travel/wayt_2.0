part of 'plan_cubit.dart';

/// Common state for the plan bloc.
sealed class PlanState extends Equatable {
  const PlanState();

  @override
  List<Object?> get props => [];
}

/// Parent state for states that have plan data, i.e., all states except
/// [PlanInitial] and the fetch in progress/failure states.
sealed class PlanStateWithData extends PlanState {
  final PlanEntity plan;
  final List<TravelItemEntityWrapper> travelItems;

  const PlanStateWithData({
    required this.plan,
    required this.travelItems,
  });

  @override
  List<Object?> get props => [plan, travelItems];
}

/// Parent interface implemented by states that represent the fetch state.
abstract interface class PlanFetchState {}

/// The initial state of the plan bloc.
final class PlanInitial extends PlanState {}

/// The state when the plan is being fetched.
final class PlanFetchInProgress extends PlanState implements PlanFetchState {}

/// The state when the plan fetch is successful
final class PlanFetchSuccess extends PlanStateWithData
    implements PlanFetchState {
  const PlanFetchSuccess({
    required super.plan,
    required super.travelItems,
  });
}

/// The state when the plan fetch fails.
final class PlanFetchFailure extends PlanState implements PlanFetchState {
  const PlanFetchFailure(this.error);

  final WError error;

  @override
  List<Object?> get props => [error];
}

/// The state when the plan item list is being updated.
final class PlanItemListUpdateSuccess extends PlanStateWithData {
  const PlanItemListUpdateSuccess({
    required super.plan,
    required super.travelItems,
  });
}

/// The state when the plan summary is being updated.
final class PlanSummaryUpdateSuccess extends PlanStateWithData {
  const PlanSummaryUpdateSuccess({
    required super.plan,
    required super.travelItems,
  });
}
