import '../../../../init/in_memory_data.dart';
import '../../plan_repository.dart';

final class InMemoryPlanDataSource implements PlanDataSource {
  final InMemoryData _data;

  InMemoryPlanDataSource(this._data);

  @override
  Future<PlanModel> create(PlanInput input) async {
    final plan = PlanModel(
      createdAt: DateTime.now().toUtc(),
      uuid: _data.generateUuid(),
      isDaySet: input.isDatSet,
      isMonthSet: input.isMonthSet,
      plannedAt: input.plannedAt,
      tags: input.tags,
      title: input.title,
      widgets: [],
    );

    _data.plans.save(plan.uuid, plan);

    return plan;
  }

  @override
  Future<void> delete(String id) async {
    _data.plans.delete(id);
  }

  @override
  Future<List<PlanSummaryModel>> read() async => _data.plansAsSummary.values;

  @override
  Future<PlanModel> readById(String id) async => _data.plans.getOrThrow(id);

  @override
  Future<PlanModel> update(String id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
