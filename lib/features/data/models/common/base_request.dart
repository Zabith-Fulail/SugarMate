import 'dart:convert';

BaseRequest baseRequestFromJson(String str) =>
    BaseRequest.fromJson(json.decode(str));

String baseRequestToJson(BaseRequest data) => json.encode(data.toJson());

class BaseRequest {
  String? channel;
  DeviceDetails? deviceDetails;
  String? ip;

  BaseRequest({this.channel, this.deviceDetails, this.ip});

  factory BaseRequest.fromJson(Map<String, dynamic> json) => BaseRequest(
    channel: json["channel"],
    deviceDetails:
        json["deviceDetails"] == null
            ? null
            : DeviceDetails.fromJson(json["deviceDetails"]),
    ip: json["ip"],
  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "deviceDetails": deviceDetails?.toJson(),
    "ip": ip,
  };
}

class DeviceDetails {
  String? deviceId;
  String? deviceModel;
  String? deviceOs;
  String? deviceName;
  String? latitude;
  String? longitude;

  DeviceDetails({
    this.deviceId,
    this.deviceModel,
    this.deviceOs,
    this.deviceName,
    this.latitude,
    this.longitude,
  });

  factory DeviceDetails.fromJson(Map<String, dynamic> json) => DeviceDetails(
    deviceId: json["deviceId"],
    deviceModel: json["deviceModel"],
    deviceOs: json["deviceOS"],
    deviceName: json["deviceName"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "deviceId": deviceId,
    "deviceModel": deviceModel,
    "deviceOS": deviceOs,
    "deviceName": deviceName,
    "latitude": latitude,
    "longitude": longitude,
  };
}
