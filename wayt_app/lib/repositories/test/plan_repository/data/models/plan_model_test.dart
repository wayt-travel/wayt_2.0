import 'package:flutter_test/flutter_test.dart';

import '../../../../repositories.dart';

void main() {
  test('PlanSummaryModel is a ITodoEntity and PlanSummaryEntity', () {
    final planSummary = PlanSummaryModel(
      createdAt: DateTime.now(),
      uuid: '1',
      isDaySet: false,
      isMonthSet: false,
      plannedAt: null,
      tags: [],
      title: 'Plan summary',
      updatedAt: null,
    );

    expect(planSummary, isA<IPlanEntity>());
    expect(planSummary, isA<PlanSummaryEntity>());
    expect(planSummary, isNot(isA<PlanEntity>()));
  });

  test('PlanModel is a ITodoEntity, PlanSummaryEntity and PlanEntity', () {
    final planSummary = PlanModel(
      createdAt: DateTime.now(),
      uuid: '1',
      isDaySet: false,
      isMonthSet: false,
      plannedAt: null,
      tags: [],
      title: 'Plan summary',
      updatedAt: null,
      widgets: [],
    );

    expect(planSummary, isA<IPlanEntity>());
    expect(planSummary, isA<PlanSummaryEntity>());
    expect(planSummary, isA<PlanEntity>());
  });
}
