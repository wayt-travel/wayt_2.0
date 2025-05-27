import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

/// File utils class.
abstract class FileUtils {
  static const _logger = NthLogger('FileUtils');

  /// Launches the picker to select files from the device.
  static Future<List<XFile>> pick(
    BuildContext context,
  ) async {
    _logger.d('Launching pick process');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['pdf'],
      withReadStream: true,
    );
    if (result == null) {
      _logger.d('No files picked');
      return [];
    }
    _logger.d(
      'Picked ${result.xFiles.length} files: '
      '${result.xFiles.map((e) => e.path).join(', ')}',
    );
    return result.xFiles;
  }
}
