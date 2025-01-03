import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:uuid/uuid.dart';

import '../../repositories.dart';

part 'widgets/text_widget_model.dart';

/// A model representing a widget in a travel Plan or Journal.
abstract class WidgetModel extends TravelItemModel implements WidgetEntity {
  @override
  final List<WidgetFeatureEntity> features;

  @override
  final String? folderId;

  @override
  final WidgetType type;

  @override
  final int order;

  @override
  final Version version;

  const WidgetModel({
    required super.id,
    required this.features,
    required this.folderId,
    required this.type,
    required this.version,
    required this.order,
    required super.createdAt,
    required super.planOrJournalId,
    required super.updatedAt,
  });

  /// Creates a new [WidgetModel] implementation from the given parameters.
  ///
  /// **NB:** this method should be called only when the input is valid, e.g.,
  /// when the values come from the database/backend.
  factory WidgetModel.toImplementation({
    required String id,
    required List<WidgetFeatureEntity> features,
    required String? folderId,
    required WidgetType type,
    required int order,
    required PlanOrJournalId planOrJournalId,
    required DateTime createdAt,
    required DateTime? updatedAt,
  }) =>
      switch (type) {
        WidgetType.text => TextWidgetModel._(
            id: id,
            order: order,
            features: features,
            folderId: folderId,
            createdAt: createdAt,
            planOrJournalId: planOrJournalId,
            updatedAt: updatedAt,
          ),
        // TODO: Handle this case.
        WidgetType.audio => throw UnimplementedError(),
        // TODO: Handle this case.
        WidgetType.place => throw UnimplementedError(),
      };

  WidgetModel copyWith({
    Optional<String?> folderId = const Optional.absent(),
    int? order,
    WidgetType? type,
    DateTime? updatedAt,
  });

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'version': version.toString(),
        'folderId': folderId,
        'order': order,
        'type': type.toString(),
        // Remove the id from the super class $map because it's already in the
        // 'id' key
        ...super.$toMap()..remove('id'),
        'features': features.map((e) => e.id).toList(),
      };

  @override
  List<Object?> get props => [
        ...super.props,
        version,
        order,
        features,
        folderId,
        type,
      ];
}
