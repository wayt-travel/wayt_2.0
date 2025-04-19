import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../../error/errors.dart';

/// {@template process_image_service_processed_image}
/// Processed image returned by the [ProcessImageService].
/// {@endtemplate}
class ProcessImageServiceProcessedImage {
  /// The size of the image.
  final ({int width, int height}) size;

  /// The size of the image in bytes.
  final int? byteCount;

  /// The metadata of the image.
  final Map<String, dynamic>? metadata;

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
    required this.metadata,
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
class ProcessImageService {
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
  WTaskEither<ProcessImageServiceProcessedImage> getProcess() {
    return TaskEither.tryCatch(
      () async {
        // Validate
        // TODO: Implement validation logic here AND ERROR HANDLING
        final bytes = await imageFile.readAsBytes();

        // Compress
        // TODO: Implement compression logic here

        // TODO: read EXIF data

        // Save
        final compressedFile = File(absoluteDestinationPath);
        final outputFile = await compressedFile.writeAsBytes(bytes);

        // Return
        return ProcessImageServiceProcessedImage(
          file: outputFile,
          // FIXME: Use actual size
          size: (width: 0, height: 0),
          byteCount: bytes.lengthInBytes,
          metadata: null,
          latLng: null,
        );
      },
      (e, __) => e.errorOrGeneric,
    );
  }
}
