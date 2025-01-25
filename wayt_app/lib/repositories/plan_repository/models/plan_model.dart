import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

class PlanModel extends TravelDocumentModel implements PlanEntity {
  @override
  final DateTime? plannedAt;

  @override
  final bool isDaySet;

  @override
  final bool isMonthSet;

  @override
  final List<String> tags;

  PlanModel({
    required super.createdAt,
    required super.id,
    required super.userId,
    required this.isDaySet,
    required this.isMonthSet,
    required this.plannedAt,
    required this.tags,
    required super.name,
    required super.updatedAt,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        isDaySet,
        isMonthSet,
        plannedAt,
        tags,
      ];

  @override
  Map<String, dynamic> $toMap() => {
        ...super.$toMap(),
        'plannedAt': plannedAt,
        'isDaySet': isDaySet,
        'isMonthSet': isMonthSet,
        'tags': tags.join(', '),
      };

  PlanModel copyWith({
    Optional<DateTime?> plannedAt = const Optional.absent(),
    bool? isDaySet,
    bool? isMonthSet,
    String? name,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PlanModel(
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
