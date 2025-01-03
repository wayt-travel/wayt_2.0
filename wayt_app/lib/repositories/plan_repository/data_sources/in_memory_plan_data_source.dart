import 'package:flext/flext.dart';

import '../../../init/in_memory_data.dart';
import '../../plan_repository/plan_repository.dart';

final class InMemoryPlanDataSource implements PlanDataSource {
  final InMemoryData _data;

  InMemoryPlanDataSource(this._data);

  @override
  Future<PlanModel> create(CreatePlanInput input) async {
    await waitFakeTime();
    final plan = PlanModel(
      userId: input.userId,
      createdAt: DateTime.now().toUtc(),
      id: _data.generateUuid(),
      isDaySet: input.isDaySet,
      isMonthSet: input.isMonthSet,
      plannedAt: input.plannedAt,
      tags: input.tags,
      name: input.name,
      updatedAt: null,
    );

    _data.plans.save(plan.id, plan);

    return plan;
  }

  @override
  Future<void> delete(String id) async {
    await waitFakeTime();
    _data.plans.delete(id);
  }

  @override
  Future<List<PlanModel>> readAllOfUser(String userId) async =>
      waitFakeTime().then(
        (_) => _data.plans.values
            .where((plan) => plan.userId == userId)
            .toList()
            .sortedByCompare(
          (plan) => plan.plannedAt,
          (p1, p2) {
            if (p2 == null) return -1;
            if (p1 == null) return 1;
            return p1.compareTo(p2);
          },
        ),
      );

  @override
  Future<PlanWithItems> readById(String id) async {
    await waitFakeTime();
    final plan = _data.plans.getOrThrow(id);
    final items = _data.travelItems.values
        .where((item) => item.planOrJournalId.planId == id)
        .toList();
    return (plan: plan, travelItems: items);
  }
}
