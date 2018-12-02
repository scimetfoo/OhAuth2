import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oh_auth_2/authenticator.dart';
import 'package:oh_auth_2/models/token.dart';

import 'environment/authentication_config.dart';

class ExampleView extends StatefulWidget {
  @override
  createState() {
    return ExampleViewState();
  }
}

class ExampleViewState extends State<ExampleView> {
  Token token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OhAuth2"),
      ),
      drawer: getNavigationDrawer(context),
    );
  }

  getNavigationDrawer(BuildContext context) {

    getLoginNavigationDrawerItem(var icon, String viewName, routeName) {
      return ListTile(
        leading: Icon(icon),
        title: Text(viewName),
        onTap: () {
          setState(() async {
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
          });
        },
      );
    }

    getRevokeNavigationDrawerItem(IconData icon, String viewName, String t) {
      return ListTile(
          leading: Icon(icon),
          title: Text(viewName),
          onTap: () {
            setState(() async {
              bool isRevoked = await Authenticator(context).revokeAccessToken(
                  AuthenticationConfig.REVOKE_TOKEN_URL,
                  token.refreshToken,
                  AuthenticationConfig.CLIENT_ID);
              debugPrint("Revoked access token " + (isRevoked.toString()));
            });
          });
    }

    getRefreshNavigationDrawerItem(IconData icon, String viewName, String t) {
      return ListTile(
          leading: Icon(icon),
          title: Text(viewName),
          onTap: () {
            setState(() async {
              Token token = await Authenticator(context).refreshAccessToken(
                  AuthenticationConfig.ACCESS_TOKEN_URL,
                  this.token.refreshToken,
                  AuthenticationConfig.CLIENT_ID);
              this.token.accessToken = token.accessToken;
              debugPrint("Refreshed acccess token " + token.accessToken);
            });
          });
    }

    var navigationBarChildren = [
      getLoginNavigationDrawerItem(Icons.account_circle, 'Sign In', ''),
      getRefreshNavigationDrawerItem(Icons.account_circle, 'Refresh Token', ''),
      getRevokeNavigationDrawerItem(Icons.account_circle, 'Revoke Token', ''),
    ];

    ListView navigationDrawerListView =
        ListView(children: navigationBarChildren);

    return Drawer(
      child: navigationDrawerListView,
    );
  }
}
