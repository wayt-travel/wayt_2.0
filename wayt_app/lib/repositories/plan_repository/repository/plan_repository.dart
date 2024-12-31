import 'package:a2f_sdk/a2f_sdk.dart';

import '../plan_repository.dart';

part '_plan_repository_impl.dart';
part 'plan_repository_state.dart';

abstract interface class PlanRepository
    extends Repository<String, PlanSummaryEntity, PlanRepositoryState> {
  /// Creates a new instance of [PlanRepository] that uses the provided data
  /// source.
  factory PlanRepository(PlanDataSource dataSource) =>
      _PlanRepositoryImpl(dataSource);

  /// Creates a new Plan.
  Future<PlanEntity> create(CreatePlanInput input);

  /// Fetches all plan (summaries only) of a user.
  Future<List<PlanSummaryEntity>> fetchAllOfUser(String userId);

  /// Fetches a full plan by its [id].
  Future<FetchPlanResponse> fetchOne(String id);

  /// Deletes a plan by its [id].
  Future<void> delete(String id);

  /// Adds a plan to the repository without fetching it from the data source
  /// and without triggering a state change.
  ///
  /// If [shouldEmit] is `true`, the repository will emit a state change.
  ///
  /// See also [addAll].
  void add(PlanEntity plan, {bool shouldEmit = true});

  /// Adds multiple plans to the repository without fetching them from the
  /// data source and without triggering a state change.
  ///
  /// If [shouldEmit] is `true`, the repository will emit a state change.
  ///
  /// See also [add].
  void addAll(Iterable<PlanEntity> plans, {bool shouldEmit = true});
}
