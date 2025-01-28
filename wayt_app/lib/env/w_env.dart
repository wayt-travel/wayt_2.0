import 'package:flutter/services.dart';

import 'dev/dev_env.gen.dart';
import 'memory/memory_env.gen.dart';
import 'test/test_env.gen.dart';
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
        WFlavor.tst => TestEnv(),
        WFlavor.mem => MemoryEnv(),
        WFlavor.dev => DevEnv(),
        WFlavor.prod => throw UnimplementedError(),
      };

  static final WFlavor _flavor = _nativeFlavor;

  /// The flavor of the app when it was built.
  static WFlavor get _nativeFlavor => appFlavor != null
      ? WFlavor.fromName(appFlavor!)
      : throw StateError('FLUTTER_APP_FLAVOR is not set');

  /// Whether the env is local test.
  bool get isTest => _flavor == WFlavor.tst;

  /// Whether the env is local.
  bool get isMemory => _flavor == WFlavor.mem;

  /// Whether the env is dev.
  bool get isDev => _flavor == WFlavor.dev;

  /// Whether the env is prod.
  bool get isProd => _flavor == WFlavor.prod;
}
