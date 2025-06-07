import 'dart:async';

import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

/// File utils class.
abstract class FilePicker {
  static const _logger = NthLogger('FilePicker');

  /// Launches the picker to select files from the device.
  static Future<List<XFile>> pick(
    BuildContext context,
  ) async {
    _logger.d('Launching pick process');
    final result = await fp.FilePicker.platform.pickFiles(
      type: fp.FileType.custom,
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
