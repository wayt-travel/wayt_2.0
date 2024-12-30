import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

class AppBlocObserver extends BlocObserver with LoggerMixin {
  AppBlocObserver();

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

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    const NthLogger('FlutterError.onError')
        .e(details.exceptionAsString(), details.stack);
  };
  Bloc.observer = AppBlocObserver();
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

  runApp(await builder());
}
