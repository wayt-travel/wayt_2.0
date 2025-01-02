import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

/// Item contained in a travel plan or journal.
///
/// In general it can be a widget or a folder of widgets.
abstract interface class TravelItemEntity implements Entity, ResourceEntity {
  /// The id of the Plan or Journal that contains the Widget.
  PlanOrJournalId get planOrJournalId;

  /// Whether the item is a folder widget.
  bool get isFolderWidget;

  /// Whether the item is a widget.
  bool get isWidget;

  /// Casts the item to a widget.
  ///
  /// [isWidget] must be true.
  WidgetEntity get asWidget;

  // TODO: add asFolderWidget to cast item to a folder widget
}
