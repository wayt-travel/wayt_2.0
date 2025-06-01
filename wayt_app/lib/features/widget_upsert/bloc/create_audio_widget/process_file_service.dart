import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../../error/error.dart';
import '../../../../util/util.dart';

/// {@template process_audio_file_service_processed_file}
/// Processed file returned by the [ProcessAudioFileService].
/// {@endtemplate}
class ProcessAudioFileServiceProcessedFile {
  /// The size of the file in bytes.
  final int? byteCount;

  /// The processed image file.
  ///
  /// This file 100% exists.
  final File file;

  /// {@macro process_audio_file_service_processed_file}
  ProcessAudioFileServiceProcessedFile({
    required this.file,
    this.byteCount,
  });
}

/// {@template process_audio_file_service}
/// Service to process an audio file.
///
/// This service will:
/// 1. Compute the size of the file in bytes.
/// 2. Move the audio file from temporary folder to the destination path.
/// 2. Return the processed file.
/// {@endtemplate}
class ProcessAudioFileService with LoggerMixin {
  /// The file to process.
  final File file;

  /// The absolute path to the destination where the image will be saved.
  final String absoluteDestinationPath;

  /// {@macro process_file_service}
  ProcessAudioFileService({
    required this.file,
    required this.absoluteDestinationPath,
  });

  /// Runs the file processing service.
  WTaskEither<ProcessAudioFileServiceProcessedFile> task() {
    return TaskEither.tryCatch(
      () async {
        logger.i('Processing file: ${file.path}');
        // TODO: validate the file size.
        final bytes = await file.readAsBytes();
        logger.d(
          'The file is ${NumberFormat.compact().format(bytes.lengthInBytes)} '
          'bytes',
        );

        final movedFile = await FileUtils.moveFile(
          file: file,
          destinationPath: absoluteDestinationPath,
        );

        // Return
        return ProcessAudioFileServiceProcessedFile(
          file: movedFile,
          byteCount: bytes.lengthInBytes,
        );
      },
      taskEitherOnError(
        logger,
        message: 'Failed to process file ${file.path}',
      ),
    ).map((r) {
      logger.i('File processed successfully: ${r.file.path}');
      return r;
    });
  }
}
