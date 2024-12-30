import 'package:a2f_sdk/a2f_sdk.dart';

import 'models.dart';

class WidgetModel extends Model implements WidgetEntity {
  @override
  final String id;

  @override
  final List<WidgetFeatureEntity> features;

  @override
  final String? folderId;

  @override
  final WidgetType type;

  const WidgetModel({
    required this.id,
    required this.features,
    required this.folderId,
    required this.type,
  });

  WidgetModel copyWith() => throw UnimplementedError();

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'features': features.map((e) => e.id).toList(),
        'folderId': folderId,
        'type': type.toString(),
      };

  @override
  List<Object?> get props => [id];
}
