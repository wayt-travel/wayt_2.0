import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import 'w_permission.dart';

/// {@template microphone_permission}
/// Permission to access the microphone.
/// {@endtemplate}
class MicrophonePermission extends WPermission {
  static const _logger = NthLogger('MicrophonePermission');

  /// Creates a new instance of [MicrophonePermission].
  const MicrophonePermission() : super(_logger);

  @override
  Permission get permission => Permission.microphone;

  @override
  Future<bool> requestInternal({
    BuildContext? context,
    String? alertMessage,
  }) async {
    return defaultRequestInternal(
      context: context,
      // FIXME: l10n
      alertMessage: alertMessage ??
          'Wayt needs to access your microphone for you to record audio. '
              'Tap the wheel and turn on "Microphone".',
    );
  }
}
