import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../repositories/repositories.dart';
import '../../../../widgets/modal/modal.dart';
import '../../../plan/view/plan_page.dart';

/// A tile of a Travel Plan displayed in the list of plans of the user.
class PlanTile extends StatelessWidget {
  /// The plan summary to display.
  final PlanSummaryEntity plan;

  /// The index of the plan in the list.
  final int index;

  /// The accent color of the plan to colorize a bit the tile.
  final Color accentColor;

  const PlanTile({
    required this.plan,
    required this.index,
    required this.accentColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => PlanPage.push(
        context,
        planId: plan.id,
        planSummary: plan,
      ),
      onLongPress: () => ModalBottomSheet.of(context).showActions(
        actions: [
          ModalBottomSheetActions.edit(context),
          ModalBottomSheetActions.divider,
          ModalBottomSheetActions.delete(context),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: accentColor,
        child:
            // Icon(
            //   // TEMP:
            //   // Shows a random icon based on the plan id.
            //   IconData(
            //     0xe000 +
            //         int.parse(
            //               plan.id.substring(plan.id.length - 8),
            //               radix: 16,
            //             ) %
            //             1790,
            //     fontFamily: 'MaterialIcons',
            //   ),
            //   color: context.col.primaryContainer,
            // ),
            Text(
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
      subtitle: _PlanTileDate(plan),
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