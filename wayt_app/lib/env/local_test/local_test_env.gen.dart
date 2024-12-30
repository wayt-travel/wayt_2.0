import 'package:envied/envied.dart';

import '../w_env.dart';

part 'local_test_env.gen.g.dart';

@Envied(name: 'Env', path: '.env.local_test', useConstantCase: true)
final class LocalTestEnv extends WEnv {
  @override
  @EnviedField(defaultValue: false)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
