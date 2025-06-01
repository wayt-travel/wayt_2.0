import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../widgets/widgets.dart';

/// An abstract class that represents a permission in the app.
abstract class WPermission {
  final NthLogger _logger;

  /// Creates a new instance of [WPermission].
  const WPermission(this._logger);

  /// Defines the permissions which can be checked and requested.
  @protected
  Permission get permission;

  /// Checksi if the permission in granted.
  Future<bool> get isGranted async => permission.isGranted;

  @protected
  @nonVirtual
  Future<bool> defaultRequestInternal({
    required String alertMessage,
    BuildContext? context,
    void Function()? openSettingsPage,
  }) async {
    if (await permission.isDenied) {
      _logger.i('The user did not grant the permission for '
          '$permission. Asking them for it...');
      final status = await permission.request();
      if (status.isGranted) {
        _logger.i('The user has just granted the permission for '
            '$permission');
        return true;
      }
      if (status.isLimited) {
        _logger.i('The user has just limited granted the permission for '
            '$permission');
        return true;
      } else {
        _logger.i('The user has denied the permission for '
            '$permission');
        if (context != null && context.mounted) {
          // TODO: add permission dialog
          // await WPermissionDialog.show(
          //   context: context,
          //   text: alertMessage,
          // );
          SnackBarHelper.I.showError(
            context: context,
            message: alertMessage,
            action: const SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          );
        }
        return false;
      }
    }

    if (await permission.isPermanentlyDenied) {
      _logger.w(
        'The user has PERMANENTLY denied the permission for $permission',
      );
      if (context != null && context.mounted) {
        // TODO: add permission dialog
        // await WPermissionDialog.show(
        //   context: context,
        //   text: alertMessage,
        //   onConfirm: openSettingsPage,
        // );
        SnackBarHelper.I.showError(
          context: context,
          message: alertMessage,
          action: SnackBarAction(
            label: 'Settings',
            onPressed: openSettingsPage ?? openAppSettings,
          ),
        );
      }
      return false;
    }

    if (await permission.isGranted) {
      _logger.v('The user has already granted Wayt the permission for '
          '$permission');
      return true;
    }

    _logger.e('Unexpected permission status '
        '=${await permission.status}');
    return false;
  }

  @protected
  Future<bool> requestInternal({
    BuildContext? context,
    String? alertMessage,
  });

  @nonVirtual
  Future<bool> request() => requestInternal();

  @nonVirtual
  Future<bool> requestWithAlert({
    required BuildContext context,
    String? alertMessage,
  }) =>
      requestInternal(
        context: context,
        alertMessage: alertMessage,
      );
}
