import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../repositories/repositories.dart';

/// Displays the date of a travel plan based on the level of detail set
/// (year, month, day).
class PlanDateText extends StatelessWidget {
  /// The plannedAt date of the plan.
  final DateTime? dateTime;

  /// Whether the month is set.
  final bool isMonthSet;

  /// Whether the day is set.
  final bool isDaySet;

  /// Creates a new [PlanDateText].
  const PlanDateText({
    required this.dateTime,
    required this.isMonthSet,
    required this.isDaySet,
    super.key,
  });

  /// Creates a new [PlanDateText] from a [PlanEntity].
  PlanDateText.ofPlan({
    required PlanEntity plan,
    super.key,
  })  : dateTime = plan.plannedAt,
        isMonthSet = plan.isMonthSet,
        isDaySet = plan.isDaySet;

  @override
  Widget build(BuildContext context) {
    late String text;
    if (dateTime == null) {
      text = 'No date set';
    } else if (!isMonthSet) {
      text = DateFormat.y().format(dateTime!);
    } else if (!isDaySet) {
      text = DateFormat.yMMMM().format(dateTime!);
    } else {
      text = DateFormat.yMMMMd().format(dateTime!);
    }
    return Text(text);
  }
}
