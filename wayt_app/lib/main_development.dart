import 'package:get_it/get_it.dart';

import 'app/app.dart';
import 'bootstrap.dart';
import 'config/app_config.dart';
import 'init/init.dart';

void main() {
  final config = AppConfig.dev(
    apiRoot: 'apiRoot',
    mode: EnvMode.inMemory,
  );
  GetIt.I.registerSingleton<AppConfig>(config);
  registersRepositories();
  bootstrap(() => const WaytApp());
}
