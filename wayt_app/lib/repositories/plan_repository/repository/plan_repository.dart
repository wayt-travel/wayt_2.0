import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

part '_plan_repository_impl.dart';
part 'plan_repository_state.dart';

abstract interface class PlanRepository
    extends Repository<String, PlanEntity, PlanRepositoryState> {
  /// Creates a new instance of [PlanRepository] that uses the provided data
  /// source.
  factory PlanRepository({
    required PlanDataSource dataSource,
    required SummaryHelperRepository summaryHelperRepository,
  }) =>
      _PlanRepositoryImpl(dataSource, summaryHelperRepository);

  /// Creates a new Plan.
  Future<PlanEntity> create(CreatePlanInput input);

  /// Fetches all plan of a user.
  Future<List<PlanEntity>> fetchAllOfUser(String userId);

  /// Fetches a full plan by its [id].
  ///
  /// The plan is returned with its items.
  Future<TravelDocumentWrapper<PlanEntity>> fetchOne(String id);

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
