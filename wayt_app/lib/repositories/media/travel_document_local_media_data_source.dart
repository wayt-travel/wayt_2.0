import 'dart:io';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../core/context/context.dart';
import '../../error/error.dart';
import '../repositories.dart';

/// {@template travel_document_local_media_data_source}
/// Data source to manage travel document media local files.
///
/// This data source is used to create, copy and delete media files for travel
/// documents locally on the device.
///
/// To determine the path of the media files, the user needs to be
/// authenticated.
/// {@endtemplate}
class TravelDocumentLocalMediaDataSource with LoggerMixin {
  /// The application context.
  final AppContext appContext;

  /// The authentication repository.
  final AuthRepository authRepository;

  /// {@macro travel_document_local_media_data_source}
  TravelDocumentLocalMediaDataSource({
    required this.appContext,
    required this.authRepository,
  });

  /// The singleton instance of the [TravelDocumentLocalMediaDataSource].
  static TravelDocumentLocalMediaDataSource get I =>
      GetIt.I<TravelDocumentLocalMediaDataSource>();

  /// Builds the path of a travel document media file.
  ///
  /// The path is built using the following format:
  /// ```plaintext
  /// <root>/users/<user_id>/travel_documents/<travel_document_id>/<folder_id>/<suffix>
  /// ```
  ///
  /// The suffix must be a valid relative path without leading slashes.
  /// It can include subfolders and, in the end, the file name if needed.
  ///
  /// The [userId] is optional. If not provided, the current authenticated user
  /// will be used.
  String buildMediaPath({
    required TravelDocumentId travelDocumentId,
    required String? folderId,
    String? userId,
    String? suffix,
  }) {
    var path = join(
      appContext.applicationDocumentsDirectory.path,
      'users',
      userId ?? authRepository.getOrThrow().user!.id,
      'travel_documents',
      travelDocumentId.id,
    );
    if (folderId != null) {
      path = join(path, folderId);
    }
    if (suffix != null) {
      path = join(path, suffix);
    }
    return path;
  }

  /// Gets the path of a media widget feature for a travel document.
  String getMediaPath({
    required TravelDocumentId travelDocumentId,
    required String? folderId,
    required String mediaWidgetFeatureId,
    required String mediaExtension,
  }) =>
      buildMediaPath(
        travelDocumentId: travelDocumentId,
        folderId: folderId,
        suffix: '$mediaWidgetFeatureId$mediaExtension',
      );

  /// Creates a media file from the given [bytes] in the specified
  /// [travelDocumentId].
  ///
  /// If [userId] is not provided, the current authenticated user will be
  /// used.
  WTaskEither<File> createMedia(
    Uint8List bytes, {
    required TravelDocumentId travelDocumentId,
    required String? folderId,
    required String fileName,
    String? userId,
  }) =>
      TaskEither.tryCatch(
        () async {
          final path = buildMediaPath(
            travelDocumentId: travelDocumentId,
            folderId: folderId,
            userId: userId,
            suffix: fileName,
          );
          final file = File(path);
          await file.parent.create(recursive: true);
          return file.writeAsBytes(bytes);
        },
        taskEitherOnError(logger, fallbackError: $errors.system.io),
      );

  /// Copies the given [file] into the specified [travelDocumentId].
  ///
  /// If [userId] is not provided, the current authenticated user will be
  /// used.
  WTaskEither<File> copyMedia(
    File file, {
    required TravelDocumentId travelDocumentId,
    required String? folderId,
    String? userId,
  }) =>
      TaskEither.tryCatch(
        () async {
          final path = buildMediaPath(
            travelDocumentId: travelDocumentId,
            folderId: folderId,
            userId: userId,
            suffix: basename(file.path),
          );
          final newFile = File(path);
          await newFile.parent.create(recursive: true);
          return file.copy(newFile.path);
        },
        taskEitherOnError(logger, fallbackError: $errors.system.io),
      );
}
