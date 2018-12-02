import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oh_auth_2/access_token_service.dart';
import 'package:oh_auth_2/auth_view.dart';
import 'package:oh_auth_2/exceptions.dart';
import 'package:oh_auth_2/models/token.dart';

/// Creates a new [Authenticator] instance.

class Authenticator {
  final BuildContext context;
  AccessTokenService accessTokenService = new AccessTokenService();

  /// [redirectUri] The redirect_uri specified during registration
  ///
  /// [authUrl] The authorization URL to send a POST request to.
  ///
  /// [accessTokenUrl] After retrieving the code, a POST request is made to
  /// retrieve the access token. Use the access token URL provided by the application
  ///
  /// [clientId] The Client ID generated during app registration
  ///
  /// [clientSecret] The Client ID generated during app registration
  ///
  Future<Token> getAccessToken(String redirectUri, String authUrl,
      String accessTokenUrl, String clientId,
      [String clientSecret]) async {
    final Token tokenResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthView(accessTokenService, redirectUri, authUrl,
            accessTokenUrl, clientId, clientSecret),
      ),
    );

    if (tokenResult == null &&
        accessTokenService.accessTokenResponseBody == null) {
      return null;
    } else if (tokenResult == null) {
      throw AuthenticationError("Error retrieving access token " +
          accessTokenService.accessTokenResponseBody);
    } else {
      return tokenResult;
    }
  }

  /// [refreshTokenUrl] The URL provided to make a POST request for a new access
  /// token (same as the access token URL inmost cases)
  ///
  /// [refreshToken] The refresh token retrieved during the initial request for an access token
  ///
  /// [clientId] The Client ID generated during app registration
  ///
  /// [clientSecret] The Client ID generated during app registration

  Future<Token> refreshAccessToken(
      String refreshTokenUrl, String refreshToken, String clientId,
      [String clientSecret]) async {
    Response refreshTokenResponse = await accessTokenService.refreshToken(
        refreshToken, refreshTokenUrl, clientId, clientSecret);
    debugPrint("Response status: ${refreshTokenResponse.statusCode}");
    debugPrint("Refresh token response body: ${refreshTokenResponse.body}");
    if (refreshTokenResponse.statusCode >= 200 &&
        refreshTokenResponse.statusCode < 300) {
      Map tokenMap = json.decode(refreshTokenResponse.body);
      var token = Token.fromJson(tokenMap);
      return token;
    } else {
      throw AuthenticationError(
          "Error refreshing token " + refreshTokenResponse.body);
    }
  }

  /// [revokeTokenUrl] When the token is no longer required, a POST request is made
  /// to revoke the token. Use the revoke token URL provided
  ///
  /// [token] The access token or refresh token that the client wishes to revoke
  ///
  /// [clientId] The Client ID generated during app registration
  ///
  /// [clientSecret] The Client ID generated during app registration

  Future<bool> revokeAccessToken(
      String revokeTokenUrl, String token, String clientId,
      [String clientSecret]) async {
    Response revokeTokenResponse = await accessTokenService.revokeAccessToken(
        token, clientId, revokeTokenUrl, clientSecret);
    debugPrint("Response status: ${revokeTokenResponse.statusCode}");
    debugPrint("Response body: ${revokeTokenResponse.body}");
    return revokeTokenResponse.statusCode == 204
        ? true
        : throw AuthenticationError(
            "Error revoking token " + revokeTokenResponse.body);
  }

  Authenticator(this.context);
}
