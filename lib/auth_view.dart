import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oh_auth_2/access_token_response_listener.dart';
import 'package:oh_auth_2/access_token_service.dart';
import 'package:oh_auth_2/models/token.dart';

class AuthView extends StatefulWidget {
  final String redirectUri;
  final String authUrl;
  final String clientId;
  final String accessTokenUrl;
  final String clientSecret;
  final AccessTokenService accessTokenService;
  final String userAgent;

  const AuthView(this.accessTokenService, this.redirectUri, this.authUrl,
      this.accessTokenUrl, this.clientId, this.userAgent, this.clientSecret);

  @override
  createState() {
    return AuthViewState();
  }
}

class AuthViewState extends State<AuthView>
    implements AccessTokenResponseListener {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription<WebViewStateChanged> onStateChanged;
  StreamSubscription<String> onUrlChanged;

  String code;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.authUrl,
      withZoom: true,
    );
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith(widget.redirectUri)) {
            this.code = (Uri.parse(url).queryParameters.values.toList()[1]);
            debugPrint(code);
            flutterWebviewPlugin.close();
            widget.accessTokenService.getAccessToken(
                code,
                widget.redirectUri,
                widget.accessTokenUrl,
                widget.clientId,
                this,
                widget.userAgent,
                widget.clientSecret);
          }
        });
      }
    });
  }

  @override
  void onTokenReceived(Token token) {
    Navigator.of(context).pop(token);
  }
}
