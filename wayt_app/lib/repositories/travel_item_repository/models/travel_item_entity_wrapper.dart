import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:equatable/equatable.dart';

import 'travel_item_entity.dart';

/// Utility class that wraps a [TravelItemEntity] with its children.
///
/// If the item is a folder, the children are the items inside the folder.
///
/// If the item is a widget, the children are null.
class TravelItemEntityWrapper with EquatableMixin, ModelToStringMixin {
  /// The item wrapped by this instance.
  final TravelItemEntity value;

  /// The children of the item if it is a folder, otherwise null.
  final List<TravelItemEntity>? children;

  const TravelItemEntityWrapper.widget(this.value) : children = null;

  const TravelItemEntityWrapper.folder(this.value, this.children);

  @override
  List<Object?> get props => [value, children];

  @override
  Map<String, dynamic> $toMap() => {
        'item': value,
        'children.length': children?.length,
      };
}
