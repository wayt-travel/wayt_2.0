import 'microphone_permission.dart';
import 'w_permission.dart';

/// An abstract class that contains all the permissions used in the app.
///
/// - `microphone`: Permission to access the microphone.
abstract class WPermissions {

  /// {@macro microphone_permission}
  static const WPermission microphone = MicrophonePermission();
}
