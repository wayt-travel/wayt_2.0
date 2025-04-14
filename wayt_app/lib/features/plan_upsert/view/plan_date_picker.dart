import 'package:flutter/material.dart';

import '../../../widgets/widgets.dart';

/// Callback for when a date is picked.
typedef PlanDatePickerOnPick = dynamic Function({
  required DateTime? plannedAt,
  required bool isDaySet,
  required bool isMonthSet,
});

/// Displays a modal to pick a date for a travel plan.
abstract class PlanDatePicker {
  /// Shows the modal.
  static Future<DateTime?> show(
    BuildContext context, {
    required PlanDatePickerOnPick onPick,
    DateTime? initialDate,
  }) =>
      ModalBottomSheet.of(context).showActions<DateTime>(
        actions: [
          ModalBottomSheetAction(
            iconData: Icons.event,
            // FIXME: l10n
            title: 'I have already decided everything',
            // FIXME: l10n
            subtitle: 'Specify an exact departure date (DD/MM/YYYY)',
            onTap: (context) => DatePickerPage.push(
              context,
              initialDate: initialDate ?? DateTime.now(),
            ).then((date) {
              if (date != null) {
                onPick(plannedAt: date, isDaySet: true, isMonthSet: true);
              }
            }),
          ),
          ModalBottomSheetAction(
            iconData: Icons.date_range,
            // FIXME: l10n
            title: 'I have not decided the day yet',
            // FIXME: l10n
            subtitle: 'Specify the year and month (MM/YYYY)',
            onTap: (context) => DatePickerPage.push(
              context,
              initialDate: initialDate ?? DateTime.now(),
              initialDatePickerMode: DatePickerMode.year,
            ).then((date) {
              if (date != null) {
                onPick(plannedAt: date, isDaySet: false, isMonthSet: true);
              }
            }),
          ),
          ModalBottomSheetAction(
            iconData: Icons.calendar_month,
            // FIXME: l10n
            title: 'I am not sure exactly',
            // FIXME: l10n
            subtitle: 'Specify only the year (YYYY)',
            onTap: (context) => DatePickerPage.push(
              context,
              initialDate: initialDate ?? DateTime.now(),
              initialDatePickerMode: DatePickerMode.year,
            ).then((date) {
              if (date != null) {
                onPick(plannedAt: date, isDaySet: false, isMonthSet: false);
              }
            }),
          ),
          ModalBottomSheetActions.divider,
          ModalBottomSheetAction(
            iconData: Icons.question_mark,
            // FIXME: l10n
            title: 'I have no idea',
            // FIXME: l10n
            subtitle: 'Do not specify any date',
            onTap: (context) =>
                onPick(plannedAt: null, isDaySet: false, isMonthSet: false),
          ),
        ],
      );
}
