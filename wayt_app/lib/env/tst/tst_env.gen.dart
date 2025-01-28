import 'package:envied/envied.dart';

import '../w_env.dart';

part 'tst_env.gen.g.dart';

/// The local test env.
@Envied(name: 'Env', path: '.env.tst', useConstantCase: true)
final class TestEnv extends WEnv {
  @override
  @EnviedField(defaultValue: false)
  final bool useInMemoryRepositories = _Env.useInMemoryRepositories;
}
