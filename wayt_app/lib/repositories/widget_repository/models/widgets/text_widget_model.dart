part of '../widget_model.dart';

/// A Widget that displays a customizable text.
final class TextWidgetModel extends WidgetModel {
  /// The text feature of the widget.
  TypographyWidgetFeatureModel get textFeature =>
      features.first as TypographyWidgetFeatureModel;

  /// Creates a new instance of [TextWidgetModel].
  factory TextWidgetModel({
    required String id,
    required String text,
    required int order,
    required TypographyFeatureStyle textStyle,
    required TravelDocumentId travelDocumentId,
    String? folderId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      TextWidgetModel._(
        id: id,
        order: order,
        features: [
          TypographyWidgetFeatureModel(
            id: const Uuid().v4(),
            data: text,
            format: TypographyFormat.material,
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
          features.length == 1 &&
              features.first is TypographyWidgetFeatureEntity,
          'The $TextWidgetModel must have exactly one '
          '$TypographyWidgetFeatureEntity.',
        ),
        super(
          type: WidgetType.text,
          version: Version(1, 0, 0),
        );

  @override
  TextWidgetModel copyWith({
    String? text,
    TypographyFeatureStyle? textStyle,
    Option<String?> folderId = const Option.none(),
    int? order,
    WidgetType? type,
    DateTime? updatedAt,
  }) {
    final feature = features.first as TypographyWidgetFeatureEntity;
    return TextWidgetModel._(
      id: id,
      order: order ?? this.order,
      features: [
        TypographyWidgetFeatureModel(
          id: features.first.id,
          data: text ?? feature.data,
          format: TypographyFormat.material,
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
