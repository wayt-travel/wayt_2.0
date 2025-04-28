import 'package:bloc/bloc.dart';

/// Cubit for managing the app initialization.
///
/// It is charge of initializing everything the app needs.
class InitializationCubit extends Cubit<bool?> {
  /// Creates a new instance of [InitializationCubit].
  InitializationCubit() : super(null);

  /// Run the app initialization
  Future<void> onSetup() async {
    // TEMP: remove this line
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    emit(true);
  }
}
