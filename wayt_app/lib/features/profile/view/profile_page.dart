import 'dart:async';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import '../../../auth/auth.dart';

CognitoCredentials _credential = CognitoCredentials(
  'eu-west-3:3b8df1f0-f1d7-4700-853f-a19ab82ae13f',
  userPool,
);
CognitoUserPool userPool = CognitoUserPool(
  'eu-west-3_VkWCZFcHM',
  '13pij05jf9chmofuv8tcll475g',
);

/// Page displaying the user profile.
class ProfilePage extends StatelessWidget {
  const ProfilePage._();

  /// Path to the profile page.
  static const String path = '/profile';

  /// Route name of the profile page.
  static const String routeName = 'profile';

  /// Route of the profile page.
  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfilePage._(),
        ),
      );

  /// Navigates to the profile page.
  static void go(BuildContext context) {
    context.router.goNamed(
      routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

/// View displaying the user profile.
class ProfileView extends StatelessWidget {
  /// Creates a profile view.
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Profile'),
        ),
        const Content().asSliver,
      ],
    );
  }
}

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?

  @override
  void initState() {
    super.initState();

    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
// #docregion CanAccessScopes
      // In mobile, being authenticated means being authorized...
      final isAuthorized = account != null;
// #enddocregion CanAccessScopes

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      final userName = account?.displayName;
      final userEmail = account?.email;

      print('User Name: $userName');
      print('User Email: $userEmail');

      unawaited(account?.authentication.then((value) {
        //print(value.idToken);
        //print(value.accessToken);
        _credential
            .getAwsCredentials(value.idToken, 'accounts.google.com')
            .then((_) {
          const NthLogger('Auth').i('${value.idToken}');
        });
      }));
    });

    // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => googleSignIn.disconnect();

  Widget _buildBody() {
    final user = _currentUser;
    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      // The user is NOT Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          // This method is used to separate mobile from web code with
          // conditional exports.
          // See: src/sign_in_button.dart
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
