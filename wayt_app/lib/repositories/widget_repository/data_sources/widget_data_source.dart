import '../widget_repository.dart';

/// Data source for Widget entities.
abstract interface class WidgetDataSource {
  /// Creates a new Widget positioned at [index] in the plan or journal.
  ///
  /// The widget.order in the model is disregarded and recomputed using the
  /// provided [index] and based on the existing widgets in the plan or journal.
  /// If [index] is `null`, the widget will be added at the end of the list. If
  /// [index] is out of bounds, the widget will be added at the end of the list.
  ///
  /// The response includes the newly created widget (with correct order) and a
  /// map of the existing widgets whose order was updated as a result of the
  /// insertion.
  Future<UpsertWidgetOutput> create(WidgetModel widget, {int? index});

  /// Reads a widget by its [id].
  Future<WidgetEntity> read(String id);

  /// Deletes a widget by its [id].
  Future<void> delete(String id);
}
