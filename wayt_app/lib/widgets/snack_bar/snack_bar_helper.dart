import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../util/sdk_candidate.dart';

enum _MessageType {
  info,
  warning,
  error;

  bool get isInfo => this == info;
  bool get isWarning => this == warning;
  bool get isError => this == error;
}

/// Helper class to show snack bars.
@SdkCandidate()
class SnackBarHelper {
  static const _kMessageDuration = Duration(milliseconds: 4000);

  final List<String> _messagesQueue;
  static SnackBarHelper? _instance;

  /// Gets the singleton instance of [SnackBarHelper].
  // ignore: prefer_constructors_over_static_methods
  static SnackBarHelper get I => _instance ??= SnackBarHelper._();

  SnackBarHelper._() : _messagesQueue = [];

  /// Adds a text at the end of the queue
  void _addText(String text) {
    _messagesQueue.add(text);
    Future.delayed(_kMessageDuration, () => _messagesQueue.removeAt(0))
        .ignore();
  }

  /// Shows an info message.
  void showInfo({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
  }) =>
      _showMessage(
        context,
        message: message,
        type: _MessageType.info,
        action: action,
      );

  /// Shows a warning message.
  void showWarning({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
  }) =>
      _showMessage(
        context,
        message: message,
        type: _MessageType.warning,
        action: action,
      );

  /// Shows an error message.
  void showError({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
  }) =>
      _showMessage(
        context,
        message: message,
        type: _MessageType.error,
        action: action,
      );

  /// Shows a message that the feature is not implemented yet.
  void showNotImplemented(BuildContext context) {
    showWarning(
      context: context,
      message: 'Not implemented yet',
    );
  }

  /// Shows a message only if a message is not already in the queue.
  void _showMessage(
    BuildContext context, {
    required String message,
    required _MessageType type,
    SnackBarAction? action,
  }) {
    if (_messagesQueue.contains(message)) return;
    _addText(message);
    final snackBar = SnackBar(
      content: Text(
        message,
        style: context.tt.bodyMedium?.copyWith(
          color: switch (type) {
            _MessageType.info => null,
            _MessageType.warning || _MessageType.error => context.col.onError,
          },
        ),
      ),
      backgroundColor: switch (type) {
        _MessageType.info => null,
        _MessageType.warning => Colors.orangeAccent,
        _MessageType.error => context.col.error,
      },
      action: action,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Hides the current snack bar.
  void hideSnackBar(BuildContext context) {
    if (_messagesQueue.isNotEmpty) {
      _messagesQueue.removeLast();
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
