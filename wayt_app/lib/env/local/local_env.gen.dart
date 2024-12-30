import 'package:envied/envied.dart';

import '../w_env.dart';

part 'local_env.gen.g.dart';

@Envied(name: 'Env', path: '.env.local', useConstantCase: true)
final class LocalEnv extends WEnv {
  @override
  @EnviedField(defaultValue: false)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
