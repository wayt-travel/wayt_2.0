import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

/// Item contained in a travel plan or journal.
///
/// In general it can be a widget or a folder of widgets.
abstract interface class TravelItemEntity implements Entity, ResourceEntity {
  /// The id of the Plan or Journal that contains the Widget.
  TravelDocumentId get travelDocumentId;

  /// Determines the order of the item in a plan or journal.
  ///
  /// It is not guaranteed that the order is sequential, i.e., does not have
  /// gaps. E.g., [1, 2, 5, 10, 100] is a valid order.
  ///
  /// If the item is contained inside a folder widget, the order is relative to
  /// the folder.
  int get order;

  /// Whether the item is a folder widget.
  bool get isFolderWidget;

  /// Whether the item is a widget.
  bool get isWidget;

  /// Casts the item to a widget.
  ///
  /// [isWidget] must be true.
  WidgetEntity get asWidget;

  /// Casts the item to a folder widget.
  ///
  /// [isFolderWidget] must be true.
  WidgetFolderEntity get asFolderWidget;
}
