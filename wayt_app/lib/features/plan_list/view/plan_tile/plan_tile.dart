import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../repositories/repositories.dart';
import '../../../../router/router.dart';
import '../../../../widgets/widgets.dart';
import '../../../features.dart';
import 'plan_date_text.dart';

/// A tile of a Travel Plan displayed in the list of plans of the user.
class PlanTile extends StatelessWidget {
  /// The plan summary to display.
  final PlanEntity plan;

  /// The index of the plan in the list.
  final int index;

  /// The accent color of the plan to colorize a bit the tile.
  final Color accentColor;

  /// Creates a plan tile.
  const PlanTile({
    required this.plan,
    required this.index,
    required this.accentColor,
    super.key,
  });

  Future<void> _delete(BuildContext context) async {
    return ModalBottomSheet.of(context).showActions(
      title: Text(
        // FIXME: l10n
        'Are you sure?',
        style: context.tt.labelLarge,
      ),
      actions: [
        ModalBottomSheetActions.delete(context).copyWith(
          onTap: (ctx) {
            final cubit = DeletePlanCubit(
              travelDocumentRepository: GetIt.I.get(),
            );
            // Here the context is not mounted, so we use rootNavigatorKey
            $rootNavigatorKey.currentContext!.navRoot
                .pushBlocListenerBarrier<DeletePlanCubit, DeletePlanState>(
              bloc: cubit,
              trigger: () => cubit.onDelete(plan.id),
              listenWhen: (previous, current) =>
                  current.status.isSuccess || current.status.isFailure,
              listener: (context, state) {
                context.navRoot.pop();
                if (state.status.isFailure) {
                  SnackBarHelper.I.showError(
                    context: context,
                    message: state.error.toString(),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> _onLongPress(BuildContext context) async {
    return ModalBottomSheet.of(context).showActions(
      actions: [
        ModalBottomSheetActions.edit(context),
        ModalBottomSheetActions.divider,
        ModalBottomSheetActions.delete(context).copyWith(onTap: _delete),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => PlanPage.push(
        context,
        planId: plan.id,
        planSummary: plan,
      ),
      onLongPress: () => _onLongPress(context),
      leading: CircleAvatar(
        backgroundColor: accentColor,
        child: Text(
          '${index + 1}',
          style: context.tt.bodyMedium?.copyWith(
            color: context.col.onInverseSurface,
          ),
        ),
      ),
      title: Text(plan.name),
      titleTextStyle: context.tt.bodyLarge?.copyWith(
        color: accentColor,
      ),
      subtitle: PlanDateText.ofPlan(plan: plan),
    );
  }
}
