import 'dart:convert';

SampleRequest sampleRequestFromJson(String str) => SampleRequest.fromJson(json.decode(str));

String sampleRequestToJson(SampleRequest data) => json.encode(data.toJson());

class SampleRequest {
  final String? message;

  SampleRequest({
    this.message,
  });

  factory SampleRequest.fromJson(Map<String, dynamic> json) => SampleRequest(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
