import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
import '../../../router/router.dart';

/// Splash screen page.
class SplashPage extends StatelessWidget {
  const SplashPage._();

  /// Path to the splash screen page.
  static const String path = '/';

  /// Route name of the splash screen page.
  static const String routeName = 'splashPage';

  /// Route of the splash screen page.
  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashPage._(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (prev, current) =>
          prev.status.isUnknown && (current.status != prev.status),
      // FIXME: the transition should look like the splash screen is popped
      // instead now it looks like the default route is pushed, i.e., sliding
      // in from the right edge of the screen.
      listener: (context, state) => goToDefaultRoute(context),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   WIcons.logo,
              //   height: 60,
              // ),
              const Placeholder(
                fallbackWidth: 60,
                fallbackHeight: 60,
              ),
              const Gap(20),
              Theme(
                data: ThemeData(
                  cupertinoOverrideTheme: const CupertinoThemeData(
                    brightness: Brightness.light,
                  ),
                ),
                child: const CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
