import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../repositories.dart';

part 'plan_model.gen.g.dart';

/// Model implementation of the [PlanEntity].
@JsonSerializable()
class PlanModel extends TravelDocumentModel implements PlanEntity {
  @override
  final DateTime? plannedAt;

  @override
  final bool isDaySet;

  @override
  final bool isMonthSet;

  @override
  final List<String> tags;

  /// Creates a new instance of the [PlanModel].
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

  /// Creates a new instance of the [PlanModel] from a JSON map.
  factory PlanModel.fromJson(Json json) => _$PlanModelFromJson(json);

  /// Converts this instance to a JSON map.
  Json toJson() => _$PlanModelToJson(this);

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

  /// Creates a copy of this instance with the given properties changed.
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
