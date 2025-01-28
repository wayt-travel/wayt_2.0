import 'package:envied/envied.dart';

import '../w_env.dart';

part 'memory_env.gen.g.dart';

/// Environment variables for the local environment.
@Envied(name: 'Env', path: '.env.memory', useConstantCase: true)
final class MemoryEnv extends WEnv {
  @override
  @EnviedField(defaultValue: true)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
