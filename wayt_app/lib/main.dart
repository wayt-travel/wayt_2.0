import 'app/app.dart';
import 'init/init.dart';

void main() {
  registerRepositories();
  bootstrap(() => const WaytApp());
}
