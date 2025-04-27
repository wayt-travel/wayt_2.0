import '../../../repositories.dart';

/// Output of the upserting a widget.
///
/// This output contains the created widget and a map of the widgets of the
/// travel document whose order has been updated with the corresponding updated
/// value. If a widget does not appear in the map, it means that its order has
/// not been updated.
typedef UpsertWidgetOutput = ({
  WidgetModel widget,
  Map<String, int> updatedOrders,
});
