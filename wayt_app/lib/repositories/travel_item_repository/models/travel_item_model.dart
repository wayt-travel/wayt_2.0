import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

/// Base model class for [TravelItemEntity] implementations.
///
/// It represents an item (either a widget or widget folder) in a plan or
/// journal.
abstract class TravelItemModel extends Model implements TravelItemEntity {
  @override
  final String id;

  @override
  final TravelDocumentId travelDocumentId;

  @override
  final DateTime createdAt;

  @override
  final DateTime? updatedAt;

  const TravelItemModel({
    required this.travelDocumentId,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
  });

  @override
  WidgetEntity get asWidget => isWidget
      ? this as WidgetEntity
      : throw StateError('The item is not a widget.');

  @override
  WidgetFolderEntity get asFolderWidget => isFolderWidget
      ? this as WidgetFolderEntity
      : throw StateError('The item is not a folder widget.');

  @override
  bool get isFolderWidget => this is WidgetFolderEntity;

  @override
  bool get isWidget => this is WidgetEntity;

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'travelDocumentId': travelDocumentId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        travelDocumentId,
        createdAt,
        updatedAt,
      ];

  /// Creates a copy of the model with the provided fields.
  @override
  TravelItemModel copyWith({
    int? order,
    DateTime? updatedAt,
  });
}
