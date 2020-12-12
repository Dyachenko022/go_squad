import 'package:json_annotation/json_annotation.dart';

part 'tokens_model.g.dart';

@JsonSerializable()
class TokensModel {
  String accessToken;
  String refreshToken;

  TokensModel(this.accessToken, this.refreshToken);

  factory TokensModel.fromJson(Map<String, dynamic> json) => _$TokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokensModelToJson(this);


}