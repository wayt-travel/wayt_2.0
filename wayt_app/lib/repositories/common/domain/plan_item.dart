import '../common.dart';

abstract interface class PlanItem {
  /// Whether the item is a folder widget.
  bool get isFolderWidget;

  /// Whether the item is a widget.
  bool get isWidget;

  /// Casts the item to a widget.
  ///
  /// [isExpenseTransaction] must be true.
  WidgetEntity get asWidget;

  // TODO: add asFolderWidget to cast item to a folder widget
}
