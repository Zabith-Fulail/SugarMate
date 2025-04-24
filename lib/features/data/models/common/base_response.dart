import 'dart:convert';

BaseResponse baseResponseFromJson(String str) => BaseResponse.fromJson(json.decode(str),(data) => data);

String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

class BaseResponse<T extends Serializable> {
  final bool? success;
  final String? message;
  final List<String>? errors;
  final int? errorCode;
  final DateTime? responseTime;
  final T? data;

  BaseResponse({
    this.success,
    this.message,
    this.errors,
    this.errorCode,
    this.responseTime,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json,Function(Map<String, dynamic>?) create) => BaseResponse(
    success: json["success"],
    message: json["message"],
    errors: json["errors"] == null ? [] : List<String>.from(json["errors"]!.map((x) => x)),
    errorCode: json["errorCode"],
    responseTime: json["responseTime"] == null ? null : DateTime.parse(json["responseTime"]),
    data: json["data"] == null
        ? null
        : create(json["data"] is List ? json : json['data']),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
    "errorCode": errorCode,
    "responseTime": responseTime?.toIso8601String(),
    "data": data?.toJson(),
  };
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}
