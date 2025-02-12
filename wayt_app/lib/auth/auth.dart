import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

/// The scopes required by this application.
// #docregion Initialize
const List<String> scopes = <String>[
  'email',
];

final googleSignIn = GoogleSignIn(
  scopes: scopes,
);

Future<GoogleSignInAccount?> signInWithGoogle() async {
  try {
    final user = await googleSignIn.signIn();
    return user;
  } catch (error) {
    if (kDebugMode) {
      print('Google Sign-In Error: $error');
    }
    return null;
  }
}

Future<String?> getGoogleIdToken() async {
  final user = await signInWithGoogle();
  if (user != null) {
    final googleAuth = await user.authentication;
    return googleAuth.idToken;
  }
  return null;
}

Future<void> configureAmplify() async {
  // Aggiungi il plugin per Amplify Auth Cognito
  await Amplify.addPlugins([AmplifyAuthCognito()]);

  // Configura Amplify
  await Amplify.configure('''
  {
    "auth": {
      "plugins": {
        "awsCognitoAuthPlugin": {
          "UserAgent": "aws-amplify-flutter",
          "Version": "1.0"
        }
      }
    }
  }
  ''');
}

// Future<void> signInWithCognito(String idToken) async {
//   try {
//     // Effettua il login con Cognito utilizzando il Federated Sign-In
//     final result = await Amplify.Auth.fetchAuthSession(options: FederateToIdentityPoolOptions())
//     if (result.isSignedIn) {
//       if (kDebugMode) {
//         print('User signed in: ${result.user}');
//       }
//     } else {
//       if (kDebugMode) {
//         print('Sign-in failed');
//       }
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print('Error during federated sign-in: $e');
//     }
//   }
// }

// class Credentials {
//   final CognitoCredentials _cognitoCredentials;
//   final String _token;
//   final String _authenticator;

//   Credentials(
//       String identityPoolId, String userPoolId, String clientId, this._token,
//       [this._authenticator])
//       : _cognitoCredentials = new CognitoCredentials(
//             identityPoolId, new CognitoUserPool(userPoolId, clientId));

//   Future<CognitoCredentials> get cognitoCredentials async {
//     await _cognitoCredentials.getAwsCredentials(_token, _authenticator);
//     return _cognitoCredentials;
//   }
// }

// class Api {
//   final String endpoint;
//   final String path;
//   final String region;
//   final Credentials credentials;

//   Api(this.endpoint, this.path, this.region, this.credentials);

//   post(Map body) async {
//     CognitoCredentials cognitoCredentials =
//         await credentials.cognitoCredentials;
//     final awsSigV4Client = AwsSigV4Client(
//       cognitoCredentials.accessKeyId,
//       cognitoCredentials.secretAccessKey,
//       endpoint,
//       sessionToken: cognitoCredentials.sessionToken,
//       region: region,
//     );
//     final signedRequest = SigV4Request(
//       awsSigV4Client,
//       method: 'POST',
//       path: path,
//       // headers: new Map<String, String>.from({'header-1': 'one', 'header-2': 'two'}),
//       // queryParams: new Map<String, String>.from({'tracking': 'x123'}),
//       body:  Map<String, dynamic>.from(body),
//     );

//     http.Response response;

//     response = await http.post(signedRequest.url,
//         headers: signedRequest.headers, body: signedRequest.body);

//     return response;
//   }
// }
