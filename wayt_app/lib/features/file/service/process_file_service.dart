import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../error/error.dart';

/// {@template process_file_service_processed_file}
/// Processed file returned by the [ProcessFileService].
/// {@endtemplate}
class ProcessFileServiceProcessedFile {
  /// The size of the file in bytes.
  final int? byteCount;

  /// The processed image file.
  ///
  /// This file 100% exists.
  final File file;

  /// {@macro process_file_service_processed_file}
  ProcessFileServiceProcessedFile({
    required this.file,
    this.byteCount,
  });
}

/// {@template process_file_service}
/// Service to process a file.
///
/// This service will:
/// 1. Save the file to the destination path.
/// 2. Return the processed file.
/// {@endtemplate}
class ProcessFileService with LoggerMixin {
  /// The file to process.
  final XFile file;

  /// The absolute path to the destination where the image will be saved.
  final String absoluteDestinationPath;

  /// {@macro process_file_service}
  ProcessFileService({
    required this.file,
    required this.absoluteDestinationPath,
  });

  /// Runs the file processing service.
  WTaskEither<ProcessFileServiceProcessedFile> task() {
    return TaskEither.tryCatch(
      () async {
        logger.i('Processing file: ${file.path}');
        // TODO: validate the fiel size.
        final bytes = await file.readAsBytes();
        logger.d(
          'The file is ${NumberFormat.compact().format(bytes.lengthInBytes)} '
          'bytes',
        );

        // Save
        final newFile = File(absoluteDestinationPath);
        await newFile.parent.create(recursive: true);
        final outputFile = await newFile.writeAsBytes(bytes);
        logger.d('The file was saved at: ${outputFile.path}');

        // Return
        return ProcessFileServiceProcessedFile(
          file: outputFile,
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
