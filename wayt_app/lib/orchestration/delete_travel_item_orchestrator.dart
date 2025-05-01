import 'dart:io';

import 'package:flext/flext.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../error/error.dart';
import '../repositories/repositories.dart';

/// {@template delete_travel_item_orchestrator}
/// Orchestrator to delete a travel item.
///
/// This orchestrator will:
/// 1. Delete the travel item from the repository.
/// 2. Then if the travel item is a folder widget, delete all the media inside
///    it. If the travel item is a widget, delete all the media features inside
///    it (if any).
/// {@endtemplate}
class DeleteTravelItemOrchestrator with LoggerMixin {
  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document local media data source.
  final TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;

  /// The travel item to delete.
  final TravelItemEntity travelItem;

  /// {@macro delete_travel_item_orchestrator}
  DeleteTravelItemOrchestrator({
    required this.travelItemRepository,
    required this.travelItem,
    required this.travelDocumentLocalMediaDataSource,
  });

  /// Gets the task to delete the travel item.
  WTaskEither<void> task() {
    final deleteItemTask = travelItemRepository.deleteItem(travelItem.id);
    final deleteMediaTask = WTaskEither.tryCatch(
      () async {
        if (travelItem.isFolderWidget) {
          logger.d(
            'The travel item is a folder widget. We will need to delete all '
            'the media inside it.',
          );
          final folderPath = travelDocumentLocalMediaDataSource.buildMediaPath(
            travelDocumentId: travelItem.travelDocumentId,
            folderId: travelItem.asFolderWidget.id,
          );
          final deleted = await Directory(folderPath)
              .delete(recursive: true)
              .orNullOnError();
          logger.i(
            'All folder media have been deleted [path=${deleted?.path}]',
          );
        } else {
          final mediaList = travelItem.asWidget.features
              .whereType<MediaWidgetFeatureEntity>();
          if (mediaList.isNotEmpty) {
            logger.d(
              'The travel item contains ${mediaList.length} media features, '
              'they will be deleted.',
            );
            for (final media in mediaList) {
              final path = travelDocumentLocalMediaDataSource.getMediaPath(
                travelDocumentId: travelItem.travelDocumentId,
                folderId: travelItem.asWidget.folderId,
                mediaWidgetFeatureId: media.id,
                mediaExtension: media.mediaExtension,
              );
              await File(path).delete().orNullOnError();
            }
            logger.i(
              'All media features of $travelItem have been deleted '
              '[count=${mediaList.length}]',
            );
          }
        }
      },
      taskEitherOnError(
        logger,
        fallbackError: $errors.core.badState,
      ),
    );

    return WTaskEither.right(
      () => logger.d('Launching orchestrator to delete item $travelItem'),
    ).flatMap((_) => deleteItemTask).flatMap((_) => deleteMediaTask);
  }
}
