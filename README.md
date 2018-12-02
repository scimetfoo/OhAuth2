# OhAuth2

OhAuth2 is a Flutter library for the industry-standard protocol for authorization.

Disclaimer: This library has been tested with a few services like Reddit and Strava. If you find OhAuth2 to be incompatible with a service you're trying to use this library with, please open an Issue or create a PR

# Installation
Installing OhAuth2 is simple using Dart's package management system https://pub.dartlang.org/packages/oh_auth_2.

# Getting Started

(Assuming you already have your OAuth credentials)

To retrieve the access token:

```dart
import 'dart:async';
import 'package:oh_auth_2/authenticator.dart';
import 'package:oh_auth_2/models/token.dart';

Future<Token> tokenResult = Authenticator(context)
    .getAccessToken(
        AuthenticationConfig.REDIRECT_URI,
        AuthenticationConfig.AUTH_URL,
        AuthenticationConfig.ACCESS_TOKEN_URL,
        AuthenticationConfig.CLIENT_ID)
    .then((token) {
  this.token = token;
  debugPrint(token.toJson().toString());
});
```
To refresh the access token:

```dart
import 'dart:async';
import 'package:oh_auth_2/authenticator.dart';
import 'package:oh_auth_2/models/token.dart';

Token token = await Authenticator(context).refreshAccessToken(
    AuthenticationConfig.ACCESS_TOKEN_URL,
    this.token.refreshToken,
    AuthenticationConfig.CLIENT_ID);
this.token.accessToken = token.accessToken;
debugPrint("Refreshed access token " + token.accessToken);
```
To revoke the access/refresh token:

```dart
bool isRevoked = await Authenticator(context).revokeAccessToken(
    AuthenticationConfig.REVOKE_TOKEN_URL,
    token.refreshToken,
    AuthenticationConfig.CLIENT_ID);
debugPrint("Revoked access token " + (isRevoked.toString()));
```

# License

OhAuth2 is provided under a [MIT License](https://github.com/Murtaza0xFF/OhAuth2/blob/master/LICENSE). Copyright (c) 2018 Murtaza Akbari.