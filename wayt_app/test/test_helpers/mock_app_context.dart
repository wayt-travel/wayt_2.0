import 'dart:io';

import 'package:path/path.dart';
import 'package:wayt_app/core/core.dart';

import 'mock_path_provider.dart';

final class MockAppContext implements AppContext {
  @override
  Directory get applicationCacheDirectory =>
      Directory(join(kVeryRandomRoot, 'cache'));

  @override
  Directory get applicationDocumentsDirectory =>
      Directory(join(kVeryRandomRoot, 'documents'));

  @override
  Directory get applicationSupportDirectory =>
      Directory(join(kVeryRandomRoot, 'support'));

  @override
  Directory get temporaryDirectory => Directory(join(kVeryRandomRoot, 'temp'));

  @override
  Future<void> init() async {}
}
