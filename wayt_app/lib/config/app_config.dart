import 'package:a2f_sdk/a2f_sdk.dart';

enum EnvMode {
  inMemory,
  api;

  bool get isInMemory => this == inMemory;
  bool get isApi => this == api;
}

class AppConfig {
  AppConfig.dev({
    required this.apiRoot,
    required this.mode,
  }) : flavor = Flavor.dev;
  AppConfig.stg({
    required this.apiRoot,
  })  : flavor = Flavor.staging,
        mode = EnvMode.api;
  AppConfig.prod({
    required this.apiRoot,
  })  : flavor = Flavor.prod,
        mode = EnvMode.api;

  /// Indicates the environment.
  final Flavor flavor;

  /// Indicates the root of the api.
  final String apiRoot;

  final EnvMode mode;
}
