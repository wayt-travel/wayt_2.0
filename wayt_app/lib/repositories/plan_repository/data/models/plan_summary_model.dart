import 'package:a2f_sdk/a2f_sdk.dart';

import '../../../repositories.dart';

class PlanSummaryModel extends Model implements PlanSummaryEntity {
  @override
  Map<String, dynamic> $toMap() {
    // TODO: implement $toMap
    throw UnimplementedError();
  }

  @override
  PlanSummaryModel copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  final DateTime createdAt;

  @override
  final String uuid;

  @override
  final bool isDaySet;

  @override
  final bool isMonthSet;

  @override
  final DateTime? plannedAt;

  @override
  final List<String> tags;

  @override
  final String title;

  @override
  final DateTime? updatedAt;

  PlanSummaryModel({
    required this.createdAt,
    required this.uuid,
    required this.isDaySet,
    required this.isMonthSet,
    required this.plannedAt,
    required this.tags,
    required this.title,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        createdAt,
        uuid,
        isDaySet,
        isMonthSet,
        plannedAt,
        tags,
        title,
        updatedAt,
      ];
}
