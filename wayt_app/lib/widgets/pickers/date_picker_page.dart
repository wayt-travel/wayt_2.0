import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../util/util.dart';

@SdkCandidate(requiresL10n: true)
/// Displays a page with a [CalendarDatePicker] embedded in.
class DatePickerPage extends StatelessWidget {
  /// Creates a calendar date picker page.
  const DatePickerPage._({
    required this.initialDate,
    required this.minimumDate,
    required this.maximumDate,
    this.datePickerMode = DatePickerMode.day,
  });

  /// {@template date_picker_initial_date}
  /// The initially selected [DateTime] that the picker should display.
  /// {@endtemplate}
  final DateTime initialDate;

  /// {@template date_picker_minimum_date}
  /// The earliest allowable [DateTime] that the user can select.
  /// {@endtemplate}
  final DateTime? minimumDate;

  /// {@template date_picker_maximum_date}
  /// The latest allowable [DateTime] that the user can select.
  /// {@endtemplate}
  final DateTime? maximumDate;

  /// {@template date_picker_mode}
  /// The initial display of the calendar picker.
  /// {@endtemplate}
  final DatePickerMode datePickerMode;

  /// Shows the [DatePickerPage].
  static Future<DateTime?> push(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
  }) async {
    return context.navRoot.push<DateTime>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) {
          return DatePickerPage._(
            initialDate: initialDate,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            datePickerMode: initialDatePickerMode,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DatePickerView(
      initialDate: initialDate,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      datePickerMode: datePickerMode,
    );
  }
}

/// The view of the [DatePickerPage]
class DatePickerView extends StatefulWidget {
  /// Creates the calendar view.
  const DatePickerView({
    required this.initialDate,
    required this.datePickerMode,
    super.key,
    this.minimumDate,
    this.maximumDate,
  });

  /// {@macro date_picker_initial_date}
  final DateTime initialDate;

  /// {@macro date_picker_minimum_date}
  final DateTime? minimumDate;

  /// {@macro date_picker_maximum_date}
  final DateTime? maximumDate;

  /// {@macro date_picker_mode}
  final DatePickerMode datePickerMode;

  @override
  State<DatePickerView> createState() => _DatePickerViewState();
}

class _DatePickerViewState extends State<DatePickerView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _onSelectedDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          // FIXME: l10n
          'Select date',
        ),
        actions: [
          TextButton(
            onPressed: () => context.navRoot.pop(_selectedDate),
            child: const Text(
              // FIXME: l10n
              'Save',
            ),
          ),
        ],
      ),
      body: CalendarDatePicker(
        onDateChanged: _onSelectedDateChanged,
        initialCalendarMode: widget.datePickerMode,
        initialDate: _selectedDate,
        firstDate: widget.minimumDate ?? DateTime(1900),
        lastDate: widget.maximumDate == null
            ? DateTime(2300)
            : widget.maximumDate!.isAfter(widget.initialDate)
                ? widget.maximumDate!
                : widget.initialDate,
      ),
    );
  }
}
