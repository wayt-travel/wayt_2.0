import 'package:envied/envied.dart';
import 'package:flutter/services.dart';

import 'env.dart';

part 'w_env.gen.g.dart';

/// Interface defining the environment variables to be overridden by
/// environments.
abstract interface class IWEnv {
  /// Whether to use in-memory repositories.
  bool get useInMemoryRepositories;

  /// The public access token for the Mapbox API.
  String get mapboxAccessToken;
}

/// Extension to add convenience methods to the environment.
extension WEnvExtension on WEnv {
  /// Whether the env is TST.
  bool get isTst => WEnv._flavor == WFlavor.tst;

  /// Whether the env is MEM.
  bool get isMem => WEnv._flavor == WFlavor.mem;

  /// Whether the env is DEV.
  bool get isDev => WEnv._flavor == WFlavor.dev;

  /// Whether the env is PRD.
  bool get isPrd => WEnv._flavor == WFlavor.prd;
}

/// The environment configuration for the app.
@Envied(name: 'MemEnv', path: '.env.mem', useConstantCase: true)
@Envied(name: 'DevEnv', path: '.env.dev', useConstantCase: true)
@Envied(name: 'TstEnv', path: '.env.tst', useConstantCase: true)
@Envied(name: 'PrdEnv', path: '.env.prd', useConstantCase: true)
abstract class WEnv implements IWEnv {
  /// Holds the current environment configuration.
  static final WEnv _instance = switch (_flavor) {
    WFlavor.tst => _TstEnv(),
    WFlavor.mem => _MemEnv(),
    WFlavor.dev => _DevEnv(),
    WFlavor.prd => _PrdEnv(),
  };

  /// Gets the current environment configuration.
  static WEnv get I => _instance;

  static final WFlavor _flavor = _nativeFlavor;

  /// The flavor of the app when it was built.
  static WFlavor get _nativeFlavor => appFlavor != null
      ? WFlavor.fromName(appFlavor!)
      : throw StateError('FLUTTER_APP_FLAVOR is not set');

  @override
  @EnviedField(defaultValue: true)
  final bool useInMemoryRepositories = _instance.useInMemoryRepositories;

  @override
  @EnviedField()
  final String mapboxAccessToken = _instance.mapboxAccessToken;
}
