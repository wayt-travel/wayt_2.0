import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../repositories.dart';

/// A model representing a widget in a travel Plan or Journal.
abstract class WidgetModel extends TravelItemModel implements WidgetEntity {
  @override
  final List<WidgetFeatureEntity> features;

  @override
  final String? folderId;

  @override
  final WidgetType type;

  @override
  final Version version;

  const WidgetModel({
    required super.id,
    required this.features,
    required this.folderId,
    required this.type,
    required this.version,
    required super.createdAt,
    required super.planOrJournalId,
    required super.updatedAt,
  });

  WidgetModel copyWith({
    Optional<String?> folderId = const Optional.absent(),
    WidgetType? type,
    DateTime? updatedAt,
  });

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'version': version.toString(),
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
        version,
        features,
        folderId,
        type,
      ];
}
