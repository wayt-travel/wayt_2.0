import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:uuid/uuid.dart';

import '../../../repositories.dart';

/// A Widget that displays a customizable text.
final class TextWidgetModel extends WidgetModel {
  TextWidgetFeatureModel get textFeature =>
      features.first as TextWidgetFeatureModel;

  factory TextWidgetModel({
    required String id,
    required String text,
    required FeatureTextStyle textStyle,
    required PlanOrJournalId planOrJournalId,
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
        planOrJournalId: planOrJournalId,
        updatedAt: updatedAt,
      );

  TextWidgetModel._({
    required super.id,
    required super.features,
    required super.folderId,
    required super.createdAt,
    required super.planOrJournalId,
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
      planOrJournalId: planOrJournalId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
