import 'package:envied/envied.dart';

import '../w_env.dart';

part 'dev_env.gen.g.dart';

@Envied(name: 'Env', path: '.env.dev', useConstantCase: true)
final class DevEnv extends WEnv {
  @override
  @EnviedField(defaultValue: false)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
