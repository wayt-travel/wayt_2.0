/// AppContext is a singleton class that holds the instance of the app context.
final class AppContext {
  static final _instance = AppContext._();

  AppContext._();

  /// Gets the singleton instance of the app context.
  static AppContext get I => _instance;
}
