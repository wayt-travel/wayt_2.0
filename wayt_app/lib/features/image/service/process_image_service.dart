import 'dart:io';
import 'dart:ui';

import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../error/error.dart';

/// {@template process_image_service_processed_image}
/// Processed image returned by the [ProcessImageService].
/// {@endtemplate}
class ProcessImageServiceProcessedImage {
  /// The size of the image.
  final ({int width, int height}) size;

  /// The size of the image in bytes.
  final int? byteCount;

  /// The latitude and longitude of the image.
  final (double, double)? latLng;

  /// The processed image file.
  ///
  /// This file 100% exists.
  final File file;

  /// {@macro process_image_service_processed_image}
  ProcessImageServiceProcessedImage({
    required this.file,
    required this.size,
    required this.byteCount,
    required this.latLng,
  });
}

/// {@template process_image_service}
/// Service to process an image.
///
/// This service will:
/// 1. Validate the image.
/// 2. Compress the image.
/// 3. Read the EXIF data.
/// 4. Save the image to the destination path.
/// 5. Return the processed image.
///
/// The image will be compressed so that it fits within the specified
/// [maxWidth] and [maxHeight]. If the image is larger than the specified
/// dimensions, it will be resized to fit within those dimensions.
/// {@endtemplate}
class ProcessImageService with LoggerMixin {
  /// The image file to process.
  final XFile imageFile;

  /// The maximum width of the image.
  /// If `null`, the width will not be limited.
  final int? maxWidth;

  /// The maximum height of the image.
  /// If `null`, the height will not be limited.
  final int? maxHeight;

  /// The absolute path to the destination where the image will be saved.
  final String absoluteDestinationPath;

  /// {@macro process_image_service}
  ProcessImageService({
    required this.imageFile,
    required this.maxWidth,
    required this.maxHeight,
    required this.absoluteDestinationPath,
  });

  /// Runs the image processing service.
  WTaskEither<ProcessImageServiceProcessedImage> task() {
    return TaskEither.tryCatch(
      () async {
        logger.i('Processing image: ${imageFile.path}');
        // Validate
        // TODO: Implement validation logic here AND ERROR HANDLING
        final bytes = await imageFile.readAsBytes();
        logger.v(
          'The image is ${NumberFormat.compact().format(bytes.lengthInBytes)} '
          'bytes',
        );
        // Compress
        // TODO: Implement compression logic here

        // TODO: read EXIF data

        // Determine the size of the image
        final descriptor = await ImageDescriptor.encoded(
          await ImmutableBuffer.fromUint8List(bytes),
        );
        final size = (width: descriptor.width, height: descriptor.height);

        // Save
        final compressedFile = File(absoluteDestinationPath);
        await compressedFile.parent.create(recursive: true);
        final outputFile = await compressedFile.writeAsBytes(bytes);
        logger.v('The image was saved at: ${outputFile.path}');

        // Return
        return ProcessImageServiceProcessedImage(
          file: outputFile,
          size: size,
          byteCount: bytes.lengthInBytes,
          latLng: null,
        );
      },
      taskEitherOnError(
        logger,
        message: 'Failed to process image ${imageFile.path}',
      ),
    ).map((r) {
      logger.i('Image processed successfully: ${r.file.path}');
      return r;
    });
  }
}
