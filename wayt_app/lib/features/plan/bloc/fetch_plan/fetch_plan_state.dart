part of 'fetch_plan_cubit.dart';

final class FetchPlanState extends SuperBlocState<WError> {
  final FetchPlanResponse? response;

  const FetchPlanState._({
    required this.response,
    required super.status,
    super.error,
  });

  const FetchPlanState.initial()
      : response = null,
        super.initial();

  @override
  FetchPlanState copyWith({
    required StateStatus status,
    Optional<FetchPlanResponse?> response = const Optional.absent(),
  }) =>
      FetchPlanState._(
        response: response.orElseIfAbsent(this.response),
        error: error,
        status: status,
      );

  @override
  FetchPlanState copyWithError(WError error) => FetchPlanState._(
        response: response,
        error: error,
        status: status,
      );

  @override
  List<Object?> get props => [response, ...super.props];
}
