import 'package:a2f_sdk/a2f_sdk.dart';

import '../../plan_repository.dart';

part '_plan_repository_impl.dart';
part 'plan_repository_state.dart';

typedef Plans = List<PlanSummaryEntity>;

abstract interface class PlanRepository
    extends Repository<String, IPlanEntity, PlanRepositoryState> {
  /// Creates a new instance of [PlanRepository] that uses the provided data
  /// source.
  factory PlanRepository(PlanDataSource dataSource) =>
      _PlanRepositoryImpl(dataSource);

  Future<void> create(PlanInput input);

  Future<Plans> read();

  Future<PlanEntity> readBy(String id);

  Future<void> delete(String id);
}
