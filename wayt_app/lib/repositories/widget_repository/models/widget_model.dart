import 'package:a2f_sdk/a2f_sdk.dart';

import '../../common/common.dart';
import 'models.dart';

/// A model representing a widget in a travel Plan or Journal.
class WidgetModel extends TravelItemModel implements WidgetEntity {
  @override
  final List<WidgetFeatureEntity> features;

  @override
  final String? folderId;

  @override
  final WidgetType type;

  const WidgetModel({
    required super.id,
    required this.features,
    required this.folderId,
    required this.type,
    required super.createdAt,
    required super.journalId,
    required super.planId,
    required super.updatedAt,
  });

  WidgetModel copyWith({
    List<WidgetFeatureEntity>? features,
    Optional<String?> folderId = const Optional.absent(),
    WidgetType? type,
    DateTime? updatedAt,
  }) {
    return WidgetModel(
      id: id,
      features: features ?? this.features,
      folderId: folderId.orElseIfAbsent(this.folderId),
      type: type ?? this.type,
      createdAt: createdAt,
      journalId: journalId,
      planId: planId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'folderId': folderId,
        'type': type.toString(),
        // Remove the id from the super class $map because it's already in the
        // 'id' key
        ...super.$toMap()..remove('id'),
        'features': features.map((e) => e.id).toList(),
      };

  @override
  List<Object?> get props => [
        ...super.props,
        features,
        folderId,
        type,
      ];
}
