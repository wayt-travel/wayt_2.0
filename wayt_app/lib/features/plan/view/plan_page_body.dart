import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';

class PlanPageBody extends StatelessWidget {
  final PlanEntity plan;
  const PlanPageBody({required this.plan, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(plan.name),
        ),
      ],
    );
  }
}
