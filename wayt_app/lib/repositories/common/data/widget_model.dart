import '../domain/widget_entity.dart';
import '../domain/widget_feature_entity.dart';
import '../widget_type.dart';

class WidgetModel implements WidgetEntity {
  @override
  final List<WidgetFeatureEntity> features;

  @override
  final String? folderId;

  @override
  final String id;

  @override
  final WidgetType type;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        features,
        folderId,
        id,
        type,
      ];

  WidgetModel({
    required this.features,
    required this.folderId,
    required this.id,
    required this.type,
  });

  @override
  // TODO: implement asWidget
  WidgetEntity get asWidget => throw UnimplementedError();

  @override
  // TODO: implement isFolderWidget
  bool get isFolderWidget => throw UnimplementedError();

  @override
  bool get isWidget => true;
}
