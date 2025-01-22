part of '../widget_model.dart';

/// A Widget that displays a customizable text.
final class TextWidgetModel extends WidgetModel {
  /// The text feature of the widget.
  TextWidgetFeatureModel get textFeature =>
      features.first as TextWidgetFeatureModel;

  factory TextWidgetModel({
    required String id,
    required String text,
    required int order,
    required FeatureTextStyle textStyle,
    required TravelDocumentId travelDocumentId,
    String? folderId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      TextWidgetModel._(
        id: id,
        order: order,
        features: [
          TextWidgetFeatureModel(
            id: const Uuid().v4(),
            data: text,
            format: TextFormat.material,
            textStyle: textStyle,
          ),
        ],
        folderId: folderId,
        createdAt: createdAt ?? DateTime.now().toUtc(),
        travelDocumentId: travelDocumentId,
        updatedAt: updatedAt,
      );

  TextWidgetModel._({
    required super.id,
    required super.order,
    required super.features,
    required super.folderId,
    required super.createdAt,
    required super.travelDocumentId,
    required super.updatedAt,
  })  : assert(
          features.length == 1 && features.first is TextWidgetFeatureEntity,
          'The $TextWidgetModel must have exactly one '
          '$TextWidgetFeatureEntity.',
        ),
        super(
          type: WidgetType.text,
          version: Version(1, 0, 0),
        );

  @override
  TextWidgetModel copyWith({
    String? text,
    FeatureTextStyle? textStyle,
    Option<String?> folderId = const Option.none(),
    int? order,
    WidgetType? type,
    DateTime? updatedAt,
  }) {
    final feature = features.first as TextWidgetFeatureEntity;
    return TextWidgetModel._(
      id: id,
      order: order ?? this.order,
      features: [
        TextWidgetFeatureModel(
          id: features.first.id,
          data: text ?? feature.data,
          format: TextFormat.material,
          textStyle: textStyle ?? feature.textStyle,
        ),
      ],
      folderId: folderId.getOrElse(() => this.folderId),
      createdAt: createdAt,
      travelDocumentId: travelDocumentId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
