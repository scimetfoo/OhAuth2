part of 'token.dart';

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token(
      json['access_token'] as String,
      json['token_type'] as String,
      json['bearer'] as String,
      json['expires_in'] as int,
      json['refresh_token'] as String,
      json['scope'] as String);
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'bearer': instance.bearer,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
      'scope': instance.scope
    };
