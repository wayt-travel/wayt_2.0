import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

class PlanSummaryModel extends Model implements PlanSummaryEntity {
  @override
  final String id;

  @override
  final String userId;

  @override
  final DateTime? plannedAt;

  @override
  final bool isDaySet;

  @override
  final bool isMonthSet;

  @override
  final String name;

  @override
  final List<String> tags;

  @override
  final DateTime createdAt;

  @override
  final DateTime? updatedAt;

  PlanSummaryModel({
    required this.createdAt,
    required this.id,
    required this.userId,
    required this.isDaySet,
    required this.isMonthSet,
    required this.plannedAt,
    required this.tags,
    required this.name,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        isDaySet,
        isMonthSet,
        plannedAt,
        tags,
        name,
        createdAt,
        updatedAt,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'name': name,
        'userId': userId,
        'plannedAt': plannedAt,
        'isDaySet': isDaySet,
        'isMonthSet': isMonthSet,
        'tags': tags.join(', '),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  PlanSummaryModel copyWith({
    Optional<DateTime?> plannedAt = const Optional.absent(),
    bool? isDaySet,
    bool? isMonthSet,
    String? name,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PlanSummaryModel(
        id: id,
        userId: userId,
        plannedAt: plannedAt.orElseIfAbsent(this.plannedAt),
        isDaySet: isDaySet ?? this.isDaySet,
        isMonthSet: isMonthSet ?? this.isMonthSet,
        name: name ?? this.name,
        tags: tags ?? this.tags,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
