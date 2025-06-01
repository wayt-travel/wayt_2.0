import 'dart:io';

import 'package:path_provider/path_provider.dart' as path;

/// AppContext is a singleton class that holds the instance of the app context.
abstract interface class AppContext {
  /// Gets the singleton instance of the app context.
  static AppContext get I => _AppContextImpl._instance;

  /// Path to a directory where the application may place data that is
  /// user-generated, or that cannot otherwise be recreated by your application.
  Directory get applicationDocumentsDirectory;

  /// Path to a directory where the application may place application support
  /// files.
  ///
  /// Use this for files you don’t want exposed to the user. Your app should not
  /// use this directory for user data files.
  Directory get applicationSupportDirectory;

  /// Path to a directory where the application may place application-specific
  /// cache files.
  Directory get applicationCacheDirectory;

  /// Path to the temporary directory on the device that is not backed up and is
  /// suitable for storing caches of downloaded files.
  ///
  /// On iOS is the NsCachesDirectory (Library/Caches).
  ///
  /// On Android is the Context.getCacheDir.
  Directory get temporaryDirectory;

  /// Initializes the app context.
  Future<void> init();
}

class _AppContextImpl implements AppContext {
  static final _instance = _AppContextImpl._();

  _AppContextImpl._();
  @override
  late final Directory applicationDocumentsDirectory;

  @override
  late final Directory applicationSupportDirectory;

  @override
  late final Directory applicationCacheDirectory;

  @override
  late final Directory temporaryDirectory;

  @override
  Future<void> init() async {
    applicationDocumentsDirectory =
        await path.getApplicationDocumentsDirectory();
    applicationSupportDirectory = await path.getApplicationSupportDirectory();
    applicationCacheDirectory = await path.getApplicationCacheDirectory();
    temporaryDirectory = await path.getTemporaryDirectory();
  }
}
