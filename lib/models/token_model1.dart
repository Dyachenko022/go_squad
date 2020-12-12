// To parse this JSON data, do
//
//     final tokenModel1 = tokenModel1FromJson(jsonString);

import 'dart:convert';

TokenModel1 tokenModel1FromJson(String str) => TokenModel1.fromJson(json.decode(str));

String tokenModel1ToJson(TokenModel1 data) => json.encode(data.toJson());

class TokenModel1 {
  TokenModel1({
    this.tokens,
  });

  Tokens tokens;

  factory TokenModel1.fromJson(Map<String, dynamic> json) => TokenModel1(
    tokens: Tokens.fromJson(json["tokens"]),
  );

  Map<String, dynamic> toJson() => {
    "tokens": tokens.toJson(),
  };
}

class Tokens {
  Tokens({
    this.accessToken,
    this.refreshToken,
  });

  String accessToken;
  String refreshToken;

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };
}
