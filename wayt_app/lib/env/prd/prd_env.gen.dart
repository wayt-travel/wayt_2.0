import 'package:envied/envied.dart';

import '../w_env.dart';

part 'prd_env.gen.g.dart';

/// Environment variables for the local environment.
@Envied(name: 'Env', path: '.env.prd', useConstantCase: true)
final class PrdEnv extends WEnv {
  @override
  @EnviedField(defaultValue: true)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
