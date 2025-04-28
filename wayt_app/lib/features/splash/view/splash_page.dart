import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

/// Splash screen page.
class SplashPage extends StatelessWidget {
  /// Creates a new instance of [SplashPage].
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
