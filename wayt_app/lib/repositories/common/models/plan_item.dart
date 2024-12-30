import 'package:a2f_sdk/a2f_sdk.dart';

import '../../repositories.dart';

/// Item contained in a travel plan.
///
/// In general it can be a widget or a folder of widgets.
abstract interface class PlanItem implements ResourceEntity {
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
