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

  /// Fetches all plans of a user.
  Future<List<PlanSummaryEntity>> fetchAllOfUser(String userId);

  /// Fetches a plan by its [id].
  Future<PlanEntity> fetchOne(String id);

  /// Deletes a plan by its [id].
  Future<void> delete(String id);
}
