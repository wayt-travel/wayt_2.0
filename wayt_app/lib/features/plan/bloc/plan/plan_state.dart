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
  /// The plan entity.
  final TravelDocumentWrapper<PlanEntity> plan;

  /// Creates a new instance of [PlanStateWithData].
  const PlanStateWithData(this.plan);

  @override
  List<Object?> get props => [plan];
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
  /// Creates a new instance of [PlanFetchSuccess].
  const PlanFetchSuccess(super.plan);
}

/// The state when the plan fetch fails.
final class PlanFetchFailure extends PlanState implements PlanFetchState {
  /// Creates a new instance of [PlanFetchFailure].
  const PlanFetchFailure(this.error);

  /// The error that caused the fetch to fail.
  final WError error;

  @override
  List<Object?> get props => [error];
}

/// The state when the plan item list is being updated.
final class PlanItemListUpdateSuccess extends PlanStateWithData {
  /// Creates a new instance of [PlanItemListUpdateSuccess].
  const PlanItemListUpdateSuccess(super.plan);
}

/// The state when the plan summary is being updated.
final class PlanSummaryUpdateSuccess extends PlanStateWithData {
  /// Creates a new instance of [PlanSummaryUpdateSuccess].
  const PlanSummaryUpdateSuccess(super.plan);
}
