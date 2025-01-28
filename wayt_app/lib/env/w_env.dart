import 'package:flutter/services.dart';

import 'env.dart';

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
        WFlavor.mem => MemEnv(),
        WFlavor.dev => DevEnv(),
        WFlavor.prd => throw UnimplementedError(),
      };

  static final WFlavor _flavor = _nativeFlavor;

  /// The flavor of the app when it was built.
  static WFlavor get _nativeFlavor => appFlavor != null
      ? WFlavor.fromName(appFlavor!)
      : throw StateError('FLUTTER_APP_FLAVOR is not set');

  /// Whether the env is TST.
  bool get isTst => _flavor == WFlavor.tst;

  /// Whether the env is MEM.
  bool get isMem => _flavor == WFlavor.mem;

  /// Whether the env is DEV.
  bool get isDev => _flavor == WFlavor.dev;

  /// Whether the env is PRD.
  bool get isPrd => _flavor == WFlavor.prd;
}
