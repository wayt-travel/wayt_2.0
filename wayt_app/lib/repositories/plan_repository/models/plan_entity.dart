import 'package:a2f_sdk/a2f_sdk.dart';

/// Travel plan entity.
abstract interface class PlanEntity implements Entity, ResourceEntity {
  /// The name of the travel plan.
  String get name;

  /// The id of the owner of the travel plan.
  String get userId;

  /// The tags associated with the travel plan.
  List<String> get tags;

  /// The date when the travel is planned.
  ///
  /// Based on the value of [isMonthSet] and [isDaySet], the value of this
  /// property can be interpreted as follows:
  /// - If both [isMonthSet] and [isDaySet] are `true`, the value is the exact
  ///  date and time when the travel is planned.
  /// - If only [isMonthSet] is `true`, the value is the month and year when
  /// the travel is planned.
  /// - If both [isMonthSet] and [isDaySet] are `false`, the value is just the
  /// year when the travel is planned.
  DateTime? get plannedAt;

  /// Whether the month is set.
  bool get isMonthSet;

  /// Whether the day is set.
  bool get isDaySet;
}
