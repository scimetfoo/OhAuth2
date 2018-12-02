import 'package:oh_auth_2/models/token.dart';

abstract class AccessTokenResponseListener {
  void onTokenReceived(Token token);
}
