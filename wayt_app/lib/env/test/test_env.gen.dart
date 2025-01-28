import 'package:envied/envied.dart';

import '../w_env.dart';

part 'test_env.gen.g.dart';

/// The local test env.
@Envied(name: 'Env', path: '.env.test', useConstantCase: true)
final class TestEnv extends WEnv {
  @override
  @EnviedField(defaultValue: false)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
