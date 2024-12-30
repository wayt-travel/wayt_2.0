import 'app/app.dart';
import 'bootstrap.dart';
import 'init/init.dart';

void main() {
  registerRepositories();
  bootstrap(() => const WaytApp());
}
