import '../../repositories.dart';

/// {@template widget_folder_model}
/// Model implementation for a folder of widgets in a travel plan or journal.
/// 
/// The folder can be customized with a [name], [icon], and [color].
/// {@endtemplate}
class WidgetFolderModel extends TravelItemModel implements WidgetFolderEntity {
  @override
  final String name;

  @override
  final WidgetFolderIcon icon;

  @override
  final FeatureColor color;

  @override
  final int order;

  /// {@macro widget_folder_model}
  const WidgetFolderModel({
    required super.id,
    required super.travelDocumentId,
    required super.createdAt,
    required super.updatedAt,
    required this.order,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  Map<String, dynamic> $toMap() => {
        'id': id,
        'name': name,
        'order': order,
        'icon': icon,
        'color': color,
        // Remove the id from the super class $map because it's already in the
        // 'id' key
        ...super.$toMap()..remove('id'),
      };

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        icon,
        color,
        order,
      ];

  @override
  WidgetFolderModel copyWith({
    int? order,
    String? name,
    WidgetFolderIcon? icon,
    FeatureColor? color,
    DateTime? updatedAt,
  }) =>
      WidgetFolderModel(
        id: id,
        travelDocumentId: travelDocumentId,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        icon: icon ?? this.icon,
        name: name ?? this.name,
        color: color ?? this.color,
        order: order ?? this.order,
      );
}
