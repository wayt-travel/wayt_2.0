import 'app/app.dart';
import 'init/init.dart';

void main() {
  registerSingletons();
  bootstrap(() => const WaytApp());
}
