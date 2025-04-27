import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../core/core.dart';

/// Bootstraps the application.
///
/// Runs the common initialization code for the application to be executed
/// before the material app is launched. Finally it launches the application
/// with the given [builder].
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    const NthLogger('FlutterError.onError')
        .e(details.exceptionAsString(), details.stack);
  };
  Bloc.observer = _AppBlocObserver();
  EquatableConfig.stringify = false;

  // Add cross-flavor configuration here
  NthLogger.disableAllPrinters();
  NthLogger.enablePrinter(
    DevLogPrinter(
      minLevel: LoggerLevel.all,
      formatter: const Formatter(
        useColors: true,
        colorEachLine: true,
        includeClassReference: true,
      ),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await AppContext.I.init();
  runApp(await builder());
}

class _AppBlocObserver extends BlocObserver with LoggerMixin {
  _AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logger.v('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.v('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
