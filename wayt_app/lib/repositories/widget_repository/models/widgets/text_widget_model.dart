import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:uuid/uuid.dart';

import '../../../repositories.dart';
import '../widget_feature/features/text/feature_text_style.dart';

/// A Widget that displays a customizable text.
final class TextWidgetModel extends WidgetModel {
  TextWidgetFeatureModel get textFeature =>
      features.first as TextWidgetFeatureModel;

  factory TextWidgetModel({
    required String id,
    required String text,
    required FeatureTextStyle textStyle,
    required String? journalId,
    required String? planId,
    String? folderId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      TextWidgetModel._(
        id: id,
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
        journalId: journalId,
        planId: planId,
        updatedAt: updatedAt,
      );

  TextWidgetModel._({
    required super.id,
    required super.features,
    required super.folderId,
    required super.createdAt,
    required super.journalId,
    required super.planId,
    required super.updatedAt,
  }) : super(
          type: WidgetType.text,
          version: Version(1, 0, 0),
        );

  @override
  TextWidgetModel copyWith({
    String? text,
    FeatureTextStyle? textStyle,
    Optional<String?> folderId = const Optional.absent(),
    WidgetType? type,
    DateTime? updatedAt,
  }) {
    final feature = features.first as TextWidgetFeatureEntity;
    return TextWidgetModel._(
      id: id,
      features: [
        TextWidgetFeatureModel(
          id: features.first.id,
          data: text ?? feature.data,
          format: TextFormat.material,
          textStyle: textStyle ?? feature.textStyle,
        ),
      ],
      folderId: folderId.orElseIfAbsent(this.folderId),
      createdAt: createdAt,
      journalId: journalId,
      planId: planId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
