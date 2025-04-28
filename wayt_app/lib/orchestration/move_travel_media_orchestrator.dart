import 'dart:io';

import 'package:flext/flext.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../error/error.dart';
import '../repositories/repositories.dart';

typedef _MediaList = List<({String destination, String source})>;

/// {@template move_travel_media_orchestrator}
///
/// Orchestrator to move travel media.
///
/// This orchestrator will:
/// 1. Extract all the media to move by looking for all the features of type
///    [MediaWidgetFeatureModel] in the [travelItemsToMove].
/// 2. Copy the media to the new location. The new location is determined by the
///    [destinationFolderId].
/// 3. Move the travel items to the new location using the
///    [TravelItemRepository.moveTravelItems] method.
/// 4. Delete the old media.
///
/// If the copy of media (step 2) fails, the orchestrator will try to rollback
/// the move by deleting the media that was copied to the new location and
/// interrupt the process afterwards.
///
/// {@endtemplate}
final class MoveTravelMediaOrchestrator with LoggerMixin {
  /// The travel item repository.
  final TravelItemRepository travelItemRepository;

  /// The travel document local media data source.
  final TravelDocumentLocalMediaDataSource travelDocumentLocalMediaDataSource;

  /// The travel document ID.
  final TravelDocumentId travelDocumentId;

  /// The travel items to move.
  final List<TravelItemEntity> travelItemsToMove;

  /// The destination folder ID.
  final String? destinationFolderId;

  /// {@macro move_travel_media_orchestrator}
  MoveTravelMediaOrchestrator({
    required this.travelItemRepository,
    required this.travelDocumentLocalMediaDataSource,
    required this.travelItemsToMove,
    required this.destinationFolderId,
    required this.travelDocumentId,
  });

  /// Gets the task to move the travel media.
  WTaskEither<void> task() {
    final mediaList = _getMediaList();

    // Copy the travel item media to the new location
    final copyFilesTask = WTaskEither.tryCatch(
      () async {
        logger.d(
          'Copying ${mediaList.length} media files to the new location.',
        );
        try {
          for (final media in mediaList) {
            final source = media.source;
            final destination = media.destination;
            // Create the destination directory if it doesn't exist
            await Directory(destination).parent.create(recursive: true);
            // Copy the file to the new location
            await File(source).copy(destination);
            logger.d(
              'Copied media file from $source to $destination',
            );
          }
          logger.i(
            'Copied ${mediaList.length} media files to the new location.',
          );
        } catch (e) {
          logger.e(
            'Failed to copy media files to the new location: $e',
          );
          // Rollback if fails but still throw the error
          await _rollback(mediaList);
          rethrow;
        }
      },
      taskEitherOnError(logger),
    );

    // Move the travel item medias
    final moveTask = travelItemRepository.moveTravelItems(
      travelDocumentId: travelDocumentId,
      travelItemsToMove: travelItemsToMove,
      destinationFolderId: destinationFolderId,
    );

    // Delete the old travel item media
    final deleteTask = WTaskEither.tryCatch(
      () async {
        logger.d(
          'Deleting the old media files after moving the travel items '
          '[count=${mediaList.length}].',
        );
        for (final media in mediaList) {
          // Delete the file
          await File(media.source).delete().orNullOnError();
        }
        logger.i(
          'Deleted ${mediaList.length} old media files after moving the travel '
          'items.',
        );
      },
      taskEitherOnError(logger, fallbackError: $errors.core.badState),
    );

    return copyFilesTask.flatMap((_) => moveTask).flatMap((_) => deleteTask);
  }

  _MediaList _getMediaList() =>
      travelItemsToMove.whereType<WidgetEntity>().flatMap((widget) {
        final features = widget.features;
        final mediaList =
            features.whereType<MediaWidgetFeatureModel>().toList();
        return mediaList.map(
          (media) => (
            source: travelDocumentLocalMediaDataSource.getMediaPath(
              travelDocumentId: widget.travelDocumentId,
              folderId: widget.folderId,
              mediaWidgetFeatureId: media.id,
              mediaExtension: media.mediaExtension,
            ),
            destination: travelDocumentLocalMediaDataSource.getMediaPath(
              travelDocumentId: widget.travelDocumentId,
              folderId: destinationFolderId,
              mediaWidgetFeatureId: media.id,
              mediaExtension: media.mediaExtension,
            ),
          ),
        );
      }).toList();

  Future<void> _rollback(_MediaList mediaList) async {
    logger.d(
      'Rolling back the media copy. The media created during the partial '
      'copy will be deleted.',
    );
    for (final media in mediaList) {
      // Delete the file
      await File(media.destination).delete().orNullOnError();
    }
    logger.i(
      'Rollback complete: all media files created during the partial copy have '
      'been deleted.',
    );
  }
}
