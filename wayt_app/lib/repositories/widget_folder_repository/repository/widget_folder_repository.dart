import 'package:a2f_sdk/a2f_sdk.dart';

import '../widget_folder_repository.dart';

part '_widget_folder_repository_impl.dart';
part 'widget_folder_repository_state.dart';

abstract interface class WidgetFolderRepository extends Repository<String,
    WidgetFolderEntity, WidgetFolderRepositoryState> {
  /// Creates a new instance of [WidgetFolderRepository] that uses the provided
  /// data source.
  factory WidgetFolderRepository(WidgetFolderDataSource dataSource) =>
      _WidgetFolderRepositoryImpl(dataSource);

  /// Creates a new WidgetFolder.
  Future<UpsertWidgetFolderOutput> create(CreateWidgetFolderInput input);

  /// Fetches a widget_folder by its [id].
  Future<WidgetFolderEntity> fetchOne(String id);

  /// Deletes a widget_folder by its [id].
  Future<void> delete(String id);
}
