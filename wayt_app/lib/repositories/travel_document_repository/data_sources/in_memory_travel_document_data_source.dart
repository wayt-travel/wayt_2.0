import 'package:a2f_sdk/a2f_sdk.dart';

import '../../../init/in_memory_data.dart';
import '../../repositories.dart';

/// In-memory data source for travel documents.
final class InMemoryTravelDocumentDataSource
    implements TravelDocumentDataSource {
  final InMemoryDataHelper _dataHelper;

  /// Creates a new in-memory data source for travel documents.
  InMemoryTravelDocumentDataSource(this._dataHelper);

  @override
  Future<PlanModel> createPlan(CreatePlanInput input) async {
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
  Future<List<PlanModel>> readAllPlansOfUser(String userId) async =>
      waitFakeTime().then(
        (_) => _dataHelper.getSortedPlansWhere(
          (plan) => plan.userId == userId,
        ),
      );

  @override
  Future<TravelDocumentWrapper<TravelDocumentModel>> readById(String id) async {
    await waitFakeTime();
    return _dataHelper.getTravelDocumentWrapperByRawId(id);
  }

  @override
  Future<PlanModel> updatePlan(
    String id, {
    required UpdatePlanInput input,
  }) async {
    await waitFakeTime();
    final old = _dataHelper.getPlan(id);
    final updated = old.copyWith(
      isDaySet: input.isDaySet,
      isMonthSet: input.isMonthSet,
      plannedAt: Optional(input.plannedAt),
      tags: input.tags,
      name: input.name,
      updatedAt: DateTime.now().toUtc(),
    );

    _dataHelper.saveTravelDocument(updated);

    return updated;
  }
}
