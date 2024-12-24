import '../../../repositories.dart';

abstract interface class PlanDataSource {
  Future<PlanModel> create(PlanInput input);

  Future<List<PlanSummaryModel>> read();

  Future<PlanModel> readById(String id);

  Future<PlanModel> update(String id);

  Future<void> delete(
    String id,
  );
}
