// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_custom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomResponse _$CustomResponseFromJson(Map<String, dynamic> json) => CustomResponse(
      json['code'] as int,
      json['error'] as String,
      json['message'] as String,
    );

Map<String, dynamic> _$CustomResponseToJson(CustomResponse instance) => <String, dynamic>{
      'code': instance.code,
      'error': instance.error,
      'message': instance.message,
    };
