import 'package:json_annotation/json_annotation.dart';

part 'response_custom.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomResponse {
  bool isSuccess;
  String error = "";
  String message = "";

  CustomResponse(this.isSuccess, this.error, this.message);

  ///显示的错误信息，优先显示error， 其次是message
  String get displayMessage {
    if (error.isNotEmpty) {
      return error;
    }
    if (message.isNotEmpty) {
      return message;
    }
    return "";
  }

  factory CustomResponse.fromJson(Map<String, dynamic> json) => _$CustomResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CustomResponseToJson(this);
}
