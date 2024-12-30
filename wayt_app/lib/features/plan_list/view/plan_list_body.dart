import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/repositories.dart';

class PlanListBody extends StatelessWidget {
  final List<PlanSummaryEntity> plans;
  const PlanListBody(this.plans, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final plan = plans[index];
          return ListTile(
            onTap: () {},
            title: Text(plan.name),
            subtitle: _PlanTileDate(plan),
          );
        },
        childCount: plans.length,
      ),
    );
  }
}

class _PlanTileDate extends StatelessWidget {
  final PlanSummaryEntity plan;
  const _PlanTileDate(this.plan, {super.key});

  @override
  Widget build(BuildContext context) {
    late String text;
    if (plan.plannedAt == null) {
      text = 'No date set';
    } else if (!plan.isMonthSet) {
      text = DateFormat.y().format(plan.plannedAt!);
    } else if (!plan.isDaySet) {
      text = DateFormat.yMMMM().format(plan.plannedAt!);
    } else {
      text = DateFormat.yMMMMd().format(plan.plannedAt!);
    }
    return Text(text);
  }
}
