import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/features.dart';
import '../app.dart';

/// The AppFacade is in charge of building the right content based on the state
/// of the initialization of the app.
class AppFacade extends StatelessWidget {
  /// Creates a new instance of [AppFacade].
  const AppFacade({required this.child, super.key});

  /// The child to be built. This is often the content of a route.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InitializationCubit, bool?>(
      listenWhen: (previous, current) => current != null,
      listener: (context, state) {
        if (state ?? false) {
          GetIt.I.get<AppBloc>().init();
        }
      },
      builder: (context, state) {
        if (state != null && !context.watch<AppBloc>().state.status.isUnknown) {
          return child;
        }
        return const SplashPage();
      },
    );
  }
}
