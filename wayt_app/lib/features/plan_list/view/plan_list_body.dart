import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../../theme/random_color.dart';
import 'plan_tile/plan_tile.dart';

class PlanListBody extends StatefulWidget {
  final List<PlanEntity> plans;
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
            return PlanTile(
              index: index,
              key: ValueKey(index),
              accentColor: RandomColor.colorFromInt(index, intensity: 300),
              plan: widget.plans[index],
            );
          },
          childCount: widget.plans.length,
        ),
      ),
    );
  }
}
