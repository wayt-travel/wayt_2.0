import 'package:path/path.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:uuid/uuid.dart';

final kVeryRandomRoot = '/7A6mJjy6MMHrSguq_${const Uuid().v4()}';

class _MockPathProviderPlatform
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationCachePath() =>
      Future.value(join(kVeryRandomRoot, 'cache'));

  @override
  Future<String?> getApplicationDocumentsPath() =>
      Future.value(join(kVeryRandomRoot, 'documents'));

  @override
  Future<String?> getApplicationSupportPath() =>
      Future.value(join(kVeryRandomRoot, 'support'));

  @override
  Future<String?> getDownloadsPath() =>
      Future.value(join(kVeryRandomRoot, 'downloads'));

  @override
  Future<List<String>?> getExternalCachePaths() =>
      Future.value([join(kVeryRandomRoot, 'external_cache')]);

  @override
  Future<String?> getExternalStoragePath() =>
      Future.value(join(kVeryRandomRoot, 'external_storage'));

  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) =>
      Future.value([join(kVeryRandomRoot, 'external_storage_paths')]);

  @override
  Future<String?> getLibraryPath() =>
      Future.value(join(kVeryRandomRoot, 'library'));

  @override
  Future<String?> getTemporaryPath() =>
      Future.value(join(kVeryRandomRoot, 'temp'));
}

void mockPathProvider() {
  PathProviderPlatform.instance = _MockPathProviderPlatform();
}
