# Example

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
        AuthenticationConfig.CLIENT_ID,
        userAgent: AuthenticationConfig.USER_AGENT, //optional
        clientSecret: AuthenticationConfig.CLIENT_SECRET, //optional
)
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
    AuthenticationConfig.CLIENT_ID,
    userAgent: AuthenticationConfig.USER_AGENT, //optional
    clientSecret: AuthenticationConfig.CLIENT_SECRET, //optional
);
this.token.accessToken = token.accessToken;
debugPrint("Refreshed access token " + token.accessToken);
```
To revoke the access/refresh token:

```dart
import 'dart:async';
import 'package:oh_auth_2/authenticator.dart';
import 'package:oh_auth_2/models/token.dart';

bool isRevoked = await Authenticator(context).revokeAccessToken(
    AuthenticationConfig.REVOKE_TOKEN_URL,
    token.refreshToken,
    AuthenticationConfig.CLIENT_ID,
    userAgent: AuthenticationConfig.USER_AGENT, //optional
    clientSecret: AuthenticationConfig.CLIENT_SECRET //optional
);
debugPrint("Revoked access token " + (isRevoked.toString()));
```
