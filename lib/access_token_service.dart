import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oh_auth_2/access_token_response_listener.dart';
import 'package:oh_auth_2/models/token.dart';

class AccessTokenService {
  String accessTokenResponseBody;

  getAccessToken(
      String code,
      String redirectUri,
      String accessTokenUrl,
      String clientId,
      AccessTokenResponseListener listener,
      String userAgent,
      String clientSecret) {
    http
        .post(accessTokenUrl,
            body: {
              "Content-Type": "application/x-www-form-urlencoded",
              "grant_type": "authorization_code",
              "code": code,
              "redirect_uri": redirectUri,
            },
            headers: createHeaders(clientId, userAgent, clientSecret))
        .then((response) {
      debugPrint("Code: ${code}");
      debugPrint("Auth request URL: ${response.request.headers.toString()}");
      debugPrint("Response body: ${response.body}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map tokenMap = json.decode(response.body);
        var token = Token.fromJson(tokenMap);
        listener.onTokenReceived(token);
      } else {
        this.accessTokenResponseBody = response.body;
        listener.onTokenReceived(null);
      }
    });
  }

  Future<Response> refreshToken(String accessToken, String refreshTokenUrl,
      String clientId, String userAgent, String clientSecret) async {
    return http.post(
      refreshTokenUrl,
      body: {
        "grant_type": "refresh_token",
        "refresh_token": accessToken,
      },
      headers: createHeaders(clientId, userAgent, clientSecret),
    );
  }

  Future<Response> revokeAccessToken(String token, String clientId,
      String revokeTokenUrl, String userAgent, String clientSecret) {
    return http.post(revokeTokenUrl,
        body: {
          "token": token,
        },
        headers: createHeaders(clientId, userAgent, clientSecret));
  }

  Map<String, String> createHeaders(
      String clientId, String userAgent, String clientSecret) {
    Map<String, String> headers = Map();
    headers.putIfAbsent(
      "Authorization",
      () =>
          "Basic " +
          Base64Codec().encode(latin1.encode(
              clientId + ':' + (clientSecret == null ? '' : clientSecret))),
    );
    if (userAgent != null) {
      headers.putIfAbsent("User-Agent", () => userAgent);
    }
    return headers;
  }
}
