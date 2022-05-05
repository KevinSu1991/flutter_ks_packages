// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_custom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomResponse _$CustomResponseFromJson(Map<String, dynamic> json) =>
    CustomResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      json['message'] as String,
    );

Map<String, dynamic> _$CustomResponseToJson(CustomResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'message': instance.message,
    };
