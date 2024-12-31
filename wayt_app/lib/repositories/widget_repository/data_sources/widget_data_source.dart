import '../widget_repository.dart';

/// Data source for Widget entities.
abstract interface class WidgetDataSource {
  /// Creates a new Widget.
  Future<WidgetEntity> create(CreateWidgetInput input);

  /// Reads a widget by its [id].
  Future<WidgetEntity> read(String id);

  /// Deletes a widget by its [id].
  Future<void> delete(String id);
}
