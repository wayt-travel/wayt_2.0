import 'package:flutter/services.dart';

import 'dev/dev_env.gen.dart';
import 'local/local_env.gen.dart';
import 'local_test/local_test_env.gen.dart';
import 'w_flavor.dart';

/// Interface defining the environment variables to be overridden by
/// environments.
abstract interface class _IWEnv {
  /// Whether to use in-memory repositories.
  bool get useInMemoryRepositories;
}

/// The environment configuration for the app.
abstract class WEnv implements _IWEnv {
  /// Holds the current environment configuration.
  static WEnv? _instance;

  /// Gets the current environment configuration.
  static WEnv get I => _instance ??= switch (_flavor) {
        WFlavor.localTest => LocalTestEnv(),
        WFlavor.local => LocalEnv(),
        WFlavor.dev => DevEnv(),
        WFlavor.prod => throw UnimplementedError(),
      };

  static final WFlavor _flavor = _dartDefineFlavor;

  /// The flavor of the app when it was built.
  // TODO: use this instead of the dart define (_dartDefineFlavor)
  // ignore: unused_element
  static WFlavor get _nativeFlavor => appFlavor != null
      ? WFlavor.fromName(appFlavor!)
      : throw StateError('FLUTTER_APP_FLAVOR is not set');

  /// The flavor from a custom dart-define variable `WENV`.
  static WFlavor get _dartDefineFlavor {
    try {
      return WFlavor.fromName(const String.fromEnvironment('WENV'));
    } catch (e) {
      throw StateError('WENV dart-define variable is not set');
    }
  }

  /// Whether the env is local test.
  bool get isLocalTest => _flavor == WFlavor.localTest;

  /// Whether the env is local.
  bool get isLocal => _flavor == WFlavor.local;

  /// Whether the env is dev.
  bool get isDev => _flavor == WFlavor.dev;

  /// Whether the env is prod.
  bool get isProd => _flavor == WFlavor.prod;
}
