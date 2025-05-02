import '../../repositories.dart';

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

  /// Updates a widget on the plan or journal.
  Future<UpsertWidgetOutput> update(WidgetModel widget);

  /// Reads a widget by its [id].
  Future<WidgetEntity> read(String id);

  /// Deletes a widget by its [id].
  Future<void> delete(String id);

  /// Moves [widgetsToMove] to the folder with the given [destinationFolderId].
  /// If [destinationFolderId] is `null`, the widgets will be moved to the root
  /// of the travel document.
  ///
  /// All widgets must belong to the same travel document [travelDocumentId]
  /// otherwise an error will be thrown.
  Future<List<WidgetEntity>> moveToFolder({
    required TravelDocumentId travelDocumentId,
    required List<WidgetEntity> widgetsToMove,
    required String? destinationFolderId,
  });
}
