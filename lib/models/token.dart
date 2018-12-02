import 'package:json_annotation/json_annotation.dart';
part 'token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(name: 'access_token')
  String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  @JsonKey(name: 'bearer')
  final String bearer;
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'scope')
  final String scope;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  Token(this.accessToken, this.tokenType, this.bearer, this.expiresIn,
      this.refreshToken, this.scope);
}
