import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

/// An abstract class for handling file operations.
abstract class FileUtils {
  static const _logger = NthLogger('FileUtils');

  /// Moves a [file] to the [destinationPath].
  ///
  /// If the destination path does not exist, it will be created.
  /// It creates only the structure of the destination path, not the file if is
  /// is specified in the [destinationPath].
  ///
  /// It returns the moved file.
  static Future<File> moveFile({
    required File file,
    required String destinationPath,
  }) async {
    _logger.d('Moving file: ${file.path} to $destinationPath');

    final hasPathFile = path.extension(destinationPath).isNotEmpty;

    final Directory destinationDirectory;
    if (hasPathFile) {
      final file = File(destinationPath);
      final directoryPath = file.parent.path;

      destinationDirectory = Directory(directoryPath);
    } else {
      destinationDirectory = Directory(destinationPath);
    }

    if (!destinationDirectory.existsSync()) {
      _logger.d(
        'Destination directory does not exist, creating: '
        '${destinationDirectory.path}',
      );
      await destinationDirectory.create(recursive: true);
    }

    final destinationFilePath = path.join(
      destinationDirectory.path,
      path.basename(file.path),
    );

    // Moves the file to the new destination.
    await file.rename(destinationFilePath);
    _logger.d('File moved to: $destinationFilePath');
    return File(destinationFilePath);
  }
}
