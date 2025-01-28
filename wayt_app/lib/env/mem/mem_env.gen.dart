import 'package:envied/envied.dart';

import '../w_env.dart';

part 'mem_env.gen.g.dart';

/// Environment variables for the local environment.
@Envied(name: 'Env', path: '.env.mem', useConstantCase: true)
final class MemEnv extends WEnv {
  @override
  @EnviedField(defaultValue: true)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
