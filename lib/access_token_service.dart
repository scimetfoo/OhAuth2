import 'dart:convert';

import 'package:oh_auth_2/access_token_response_listener.dart';
import 'package:oh_auth_2/models/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AccessTokenService {
  String accessTokenResponseBody;

  getAccessToken(String code, String redirectUri, String accessTokenUrl,
      String clientId, AccessTokenResponseListener listener,
      String clientSecret) {
    var url = accessTokenUrl;
    Map<String, String> authHeaders = {
      "Authorization": "Basic " +
          Base64Codec().encode(latin1.encode(
              clientId + ':' + (clientSecret == null ? '' : clientSecret))),
      "User-Agent": "Jara client"
    };
    http
        .post(url,
            body: {
              "Content-Type": "application/x-www-form-urlencoded",
              "grant_type": "authorization_code",
              "code": code,
              "redirect_uri": redirectUri,
            },
            headers: authHeaders)
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

  Future<Response> refreshToken(
      String accessToken, String refreshTokenUrl, String clientId,
      String clientSecret) async {
    Map<String, String> authHeaders = {
      "Authorization": "Basic " +
          Base64Codec().encode(latin1.encode(
              clientId + ':' + (clientSecret == null ? '' : clientSecret))),
      "User-Agent": "Jara client"
    };
    return http.post(refreshTokenUrl,
        body: {
          "grant_type": "refresh_token",
          "refresh_token": accessToken,
        },
        headers: authHeaders);
  }

  Future<Response> revokeAccessToken(
      String token, String clientId, String revokeTokenUrl,
      String clientSecret) {
    var url = revokeTokenUrl;
    Map<String, String> revokeTokenAccessHeaders = {
      "Authorization": "Basic " +
          Base64Codec().encode(latin1.encode(
              clientId + ":" + (clientSecret == null ? '' : clientSecret))),
      "User-Agent": "Jara client"
    };
    return http.post(url,
        body: {
          "token": token,
        },
        headers: revokeTokenAccessHeaders);
  }
}
