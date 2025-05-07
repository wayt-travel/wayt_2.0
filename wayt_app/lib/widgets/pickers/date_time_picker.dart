import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/core.dart';
import '../../theme/theme.dart';
import '../../util/sdk/date_time_extension.dart';

/// {@template date_time_picker}
/// A widget that prompts the user to select a date and time in a modal.
/// {@endtemplate}
class DateTimePicker extends StatefulWidget {
  /// {@template date_time_picker_initial_date}
  /// [initialDate] is the date and time to display when the modal is shown.
  /// If null, the current date and time will be used.
  /// The initial date will be clamped between [minimumDate] and [maximumDate],
  /// so it will never be outside of the range.
  /// {@endtemplate}
  final DateTime initialDate;

  /// {@template date_time_picker_minimum_date}
  /// [minimumDate] is the minimum date and time that can be selected.
  /// If null, the default minimum date and time will be used.
  /// {@endtemplate}
  final DateTime? minimumDate;

  /// {@template date_time_picker_maximum_date}
  /// [maximumDate] is the maximum date and time that can be selected.
  /// If null, the default maximum date and time will be used.
  /// {@endtemplate}
  final DateTime? maximumDate;

  DateTimePicker._({
    required DateTime initialDate,
    required this.minimumDate,
    required this.maximumDate,
  }) : initialDate = initialDate.clamp(minimumDate, maximumDate);

  /// Pushes the modal to the navigator.
  ///
  /// {@macro date_time_picker}
  ///
  /// {@macro date_time_picker_initial_date}
  ///
  /// {@macro date_time_picker_minimum_date}
  ///
  /// {@macro date_time_picker_maximum_date}
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
  }) async {
    return context.navRoot.push<DateTime>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => DateTimePicker._(
          initialDate: initialDate ?? DateTime.now(),
          minimumDate: minimumDate ?? DateTime(1861),
          maximumDate: maximumDate ?? DateTime(2399),
        ),
      ),
    );
  }

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // FIXME: l10n
        title: const Text('Select Date and Time'),
        actions: [
          TextButton(
            // FIXME: l10n
            child: const Text('Done'),
            onPressed: () {
              context.navRoot.pop(_selectedDate);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          $insets.sm.asVSpan,
          Padding(
            padding: $insets.screenH.asPaddingH,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: WActionCardTheme(
                    child: Card.outlined(
                      child: ListTile(
                        leading: const Icon(Icons.today),
                        // FIXME: l10n
                        title: const Text('Date'),
                        subtitle: Text(
                          DateFormat.yMMMd().format(_selectedDate),
                          style: TextStyle(
                            color: context.col.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                $insets.xs.asHSpan,
                Expanded(
                  child: WActionCardTheme(
                    child: Card.outlined(
                      child: ListTile(
                        onTap: () {
                          // TODO: use cupertino time picker for iOS
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              _selectedDate,
                            ),
                          ).then((time) {
                            if (time != null) {
                              setState(() {
                                _selectedDate = _selectedDate.copyWith(
                                  hour: time.hour,
                                  minute: time.minute,
                                );
                              });
                            }
                          });
                        },
                        leading: const Icon(Icons.schedule),
                        // FIXME: l10n
                        title: const Text('Time'),
                        subtitle: Text(
                          TimeOfDay.fromDateTime(_selectedDate).format(context),
                          style: TextStyle(
                            color: context.col.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          $insets.sm.asVSpan,
          CalendarDatePicker(
            onDateChanged: (date) {
              setState(() {
                _selectedDate = _selectedDate.copyWith(
                  year: date.year,
                  month: date.month,
                  day: date.day,
                );
              });
            },
            initialDate: _selectedDate,
            firstDate: widget.minimumDate ?? DateTime(1861),
            lastDate: widget.maximumDate ?? DateTime(2399),
          ),
        ],
      ),
    );
  }
}
