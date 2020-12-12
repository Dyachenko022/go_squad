// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokensModel _$TokensModelFromJson(Map<String, dynamic> json) {
  return TokensModel(
    json['accessToken'] as String,
    json['refreshToken'] as String,
  );
}

Map<String, dynamic> _$TokensModelToJson(TokensModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
