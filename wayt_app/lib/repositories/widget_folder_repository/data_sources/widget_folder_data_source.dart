import '../widget_folder_repository.dart';

/// Data source for WidgetFolder entities.
abstract interface class WidgetFolderDataSource {
  /// Creates a new WidgetFolder.
  Future<UpsertWidgetFolderOutput> create(CreateWidgetFolderInput input);

  /// Reads a widget folder by its [id].
  Future<WidgetFolderEntity> read(String id);

  /// Deletes a widget folder by its [id].
  Future<void> delete(String id);
}
