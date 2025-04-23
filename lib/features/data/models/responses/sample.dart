import 'dart:convert';

import '../common/base_response.dart';

SampleResponse sampleResponseFromJson(String str) =>
    SampleResponse.fromJson(json.decode(str));

String sampleResponseToJson(SampleResponse data) => json.encode(data.toJson());

class SampleResponse extends Serializable {
  final String? message;

  SampleResponse({
    this.message,
  });

  factory SampleResponse.fromJson(Map<String, dynamic> json) =>
      SampleResponse(message: json["message"]);

  Map<String, dynamic> toJson() => {"message": message};
}
