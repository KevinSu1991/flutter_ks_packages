import 'package:json_annotation/json_annotation.dart';

part 'response_custom.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomResponse {
  int code;
  String error = "";
  String message = "";

  CustomResponse(this.code, this.error, this.message);

  bool get isSuccessful {
    return code == 1;
  }

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
