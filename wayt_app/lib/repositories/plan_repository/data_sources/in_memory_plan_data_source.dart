import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

final class InMemoryPlanDataSource implements PlanDataSource {
  final InMemoryDataHelper _dataHelper;

  InMemoryPlanDataSource(this._dataHelper);

  @override
  Future<PlanModel> create(CreatePlanInput input) async {
    await waitFakeTime();
    final plan = PlanModel(
      userId: input.userId,
      createdAt: DateTime.now().toUtc(),
      id: _dataHelper.generateUuid(),
      isDaySet: input.isDaySet,
      isMonthSet: input.isMonthSet,
      plannedAt: input.plannedAt,
      tags: input.tags,
      name: input.name,
      updatedAt: null,
    );

    _dataHelper.saveTravelDocument(plan);

    return plan;
  }

  @override
  Future<void> delete(String id) async {
    await waitFakeTime();
    _dataHelper.deletePlan(id);
  }

  @override
  Future<List<PlanModel>> readAllOfUser(String userId) async =>
      waitFakeTime().then(
        (_) => _dataHelper.getSortedPlansWhere(
          (plan) => plan.userId == userId,
        ),
      );

  @override
  Future<TravelDocumentWrapper<PlanModel>> readById(String id) async {
    await waitFakeTime();
    return _dataHelper.getTravelDocumentWrapper(TravelDocumentId.plan(id));
  }
}
