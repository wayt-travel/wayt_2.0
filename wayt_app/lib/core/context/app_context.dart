import 'dart:io';

import 'package:path_provider/path_provider.dart' as path;

/// AppContext is a singleton class that holds the instance of the app context.
final class AppContext {
  static final _instance = AppContext._();

  AppContext._();

  /// Gets the singleton instance of the app context.
  static AppContext get I => _instance;

  /// Path to a directory where the application may place data that is
  /// user-generated, or that cannot otherwise be recreated by your application.
  late final Directory applicationDocumentsDirectory;

  /// Path to a directory where the application may place application support
  /// files.
  ///
  /// Use this for files you don’t want exposed to the user. Your app should not
  /// use this directory for user data files.
  late final Directory applicationSupportDirectory;

  /// Path to a directory where the application may place application-specific
  /// cache files.
  late final Directory applicationCacheDirectory;

  /// Path to the temporary directory on the device that is not backed up and is
  /// suitable for storing caches of downloaded files.
  late final Directory temporaryDirectory;

  /// Initialized the app context.
  Future<void> init() async {
    applicationDocumentsDirectory =
        await path.getApplicationDocumentsDirectory();
    applicationSupportDirectory = await path.getApplicationSupportDirectory();
    applicationCacheDirectory = await path.getApplicationCacheDirectory();
    temporaryDirectory = await path.getTemporaryDirectory();
  }
}
