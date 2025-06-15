import '../../travel_document_repository/models/travel_document_id.gen.dart';
import '../widget_folder.dart';

/// Data source for WidgetFolder entities.
abstract interface class WidgetFolderDataSource {
  /// Creates a new WidgetFolder.
  Future<UpsertWidgetFolderOutput> create(CreateWidgetFolderInput input);

  /// Updates a folder with id [id].
  Future<UpsertWidgetFolderOutput> update(
    String id, {
    required TravelDocumentId travelDocumentId,
    required UpdateWidgetFolderInput input,
  });

  /// Reads a widget folder by its [id].
  Future<WidgetFolderEntity> read(String id);

  /// Deletes a widget folder by its [id].
  Future<void> delete(String id);
}
