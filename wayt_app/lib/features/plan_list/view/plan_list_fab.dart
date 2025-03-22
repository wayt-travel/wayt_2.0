import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features.dart';

/// The FAB of the list of plans.
class PlanListFab extends StatelessWidget {
  /// Creates a new instance of [PlanListFab].
  const PlanListFab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanListCubit, PlanListState>(
      builder: (context, state) {
        Widget? fab = FloatingActionButton(
          onPressed: () => UpsertPlanModal.showForCreating(context),
          child: const Icon(Icons.add),
        );

        if (state.status.isProgress) {
          fab = const SizedBox.shrink();
        }
        return fab;
      },
    );
  }
}
