import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/repositories.dart';
import '../../plan/view/plan_page.dart';

class PlanListBody extends StatefulWidget {
  final List<PlanSummaryEntity> plans;
  const PlanListBody(this.plans, {super.key});

  @override
  State<PlanListBody> createState() => _PlanListBodyState();
}

class _PlanListBodyState extends State<PlanListBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFadeTransition(
      opacity: animation,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final plan = widget.plans[index];
            return ListTile(
              key: ValueKey(index),
              onTap: () => PlanPage.push(
                context,
                planId: plan.id,
                planSummary: plan,
              ),
              title: Text(plan.name),
              subtitle: _PlanTileDate(plan),
            );
          },
          childCount: widget.plans.length,
        ),
      ),
    );
  }
}

class _PlanTileDate extends StatelessWidget {
  final PlanSummaryEntity plan;
  const _PlanTileDate(this.plan);

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
