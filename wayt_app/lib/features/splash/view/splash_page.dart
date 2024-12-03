import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app.dart';
import '../../home/home.dart';

class SplashPage extends StatelessWidget {
  const SplashPage._();

  static const String path = '/';
  static const String routeName = 'splashPage';

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
      listener: (context, state) {
        HomePage.go(context);
      },
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
