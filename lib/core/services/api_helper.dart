import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../features/data/datasources/local_datasource.dart';
import '../../utils/app_constants.dart';
import '../network/network_config.dart';

class APIHelper {
  final Dio? dio;
  // final DeviceData? deviceData;
  final LocalDatasource? localDatasource;

  APIHelper({this.dio, this.localDatasource}) {
    _initApiClient();
  }

  Future<void> _initApiClient() async {
    final logInterceptor =
        LogInterceptor()
          ..responseHeader = true
          ..requestHeader = true;

    final BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: kConnectionTimeout),
      receiveTimeout: const Duration(seconds: kReceiveTimeout),
      persistentConnection: true,
      baseUrl: NetworkConfig.getNetworkUrl(),
      // headers: {'Authorization': AppConstants.accessToken},
    );

    // dio
    //   ?..options = options
    //   ..interceptors.add(
    //     TokenInterceptor(localDataSource: localDatasource, dio: dio),
    //   )
    //   ..interceptors.add(
    //     DeviceDataInterceptor(dio: dio, deviceData: deviceData),
    //   )
    //   ..interceptors.add(logInterceptor);

    // dio?.httpClientAdapter = IOHttpClientAdapter(
    //   createHttpClient: () {
    //     final client = HttpClient();
    //     client.badCertificateCallback = (
    //       X509Certificate cert,
    //       String host,
    //       int port,
    //     ) {
    //       log(cert.endValidity.isAfter(DateTime.now()).toString());
    //       if (kIsSSLAvailable) {
    //         return isTrustedCertificate(cert, host);
    //       } else {
    //         return true;
    //       }
    //     };
    //     return client;
    //   },
    //   validateCertificate: (cert, host, port) {
    //     if (kIsSSLAvailable) {
    //       return isTrustedCertificate(cert, host);
    //     } else {
    //       return true;
    //     }
    //   },
    // );
  }

  Future<Response?> get(String url, {Map<String, dynamic>? data}) async {
    try {
      log('[API Helper - GET] Request Body => $data');

      final response = await dio?.get(
        "${AppConstants.kBaseUrl}$url",
        data: data,
      );

      log('[API Helper - GET] Response Body => $response');

      return response;
    } catch (e) {
      if (e is DioException) {
        final errorResponse = e.response?.data;
        final statusCode = e.response?.statusCode;

        log("[API Helper - POST] Error Status Code => $statusCode");
        log("[API Helper - POST] Error Response => $errorResponse");
      } else {
        log("[API Helper - POST] Connection Exception => $e");
        log("[API Helper - POST] Error type => ${e.runtimeType}");
      }
      rethrow;
    }
  }

  Future<dynamic> post(String url, {required Map<String, dynamic> data}) async {
    try {
      final Map<String, dynamic> bodyData = await _generateBaseRequestData(
        data,
      );

      log('[API Helper - POST] Request Body => $bodyData');

      final response = await dio?.post(
        "${AppConstants.kBaseUrl}$url",
        data: bodyData,
      );
      if (response?.data == "" || response?.data == null) {
        throw Exception("Something went wrong!");
      } else {
        log('[API Helper - POST] Response Body => ${response.toString()}');
        return response?.data;
      }
    } catch (e) {
      if (e is DioException) {
        final errorResponse = e.response?.data;
        final statusCode = e.response?.statusCode;

        log("[API Helper - POST] Error Status Code => $statusCode");
        log("[API Helper - POST] Error Response => $errorResponse");

        if (errorResponse is Map<String, dynamic> &&
            errorResponse.containsKey('success') &&
            errorResponse.containsKey('message') &&
            errorResponse.containsKey('data') &&
            errorResponse.containsKey('errors') &&
            errorResponse.containsKey('errorCode') &&
            errorResponse.containsKey('responseTime') &&
            errorResponse['success'] is bool &&
            errorResponse['message'] is String &&
            (errorResponse['data'] == null ||
                errorResponse['data'] is Map<String, dynamic>) &&
            (errorResponse['errors'] == null ||
                errorResponse['errors'] is List) &&
            errorResponse['errorCode'] is int &&
            errorResponse['responseTime'] is String) {
          return errorResponse;
        }

        return {
          "success": false,
          "message": e.type == DioExceptionType.receiveTimeout ? "Connection timed out. Please check your network and retry" : e.type == DioExceptionType.connectionError ? "Unable to connect to the server. Please check your internet connection and try again" : "Something went wrong !",
        };
      } else if (e is HttpException) {
        log("[API Helper - POST] Error Status Uri => ${e.uri}");
        log("[API Helper - POST] Error msg => ${e.message}");
        return {"message": e.message};
      } else {
        log("[API Helper - POST] Connection Exception => $e");
        log("[API Helper - POST] Error type => ${e.runtimeType}");
        return {"message": e.toString()};
      }
    }
  }

  Future<Map<String, dynamic>> _generateBaseRequestData(
    Map<String, dynamic> body,
  ) async {

    /// If you want to use BaseRequest model, please uncomment the below lines

    // final deviceInfo = await deviceData?.getDeviceData();

    // BaseRequest baseRequest = BaseRequest();
    // DeviceDetails deviceDetails = DeviceDetails();

    // baseRequest.channel = kDeviceChannel;
    // deviceDetails.deviceId = deviceInfo?.dd?.deviceId;
    // deviceDetails.deviceOs = deviceInfo?.dd?.osName;
    // deviceDetails.deviceName = deviceInfo?.dd?.deviceName;
    // deviceDetails.deviceModel = deviceInfo?.dd?.deviceModel;
    // deviceDetails.latitude = deviceInfo?.dd?.latitude ?? '0';
    // deviceDetails.longitude = deviceInfo?.dd?.longitude ?? '0';
    // baseRequest.ip = deviceInfo?.dd?.ip;

    // baseRequest.deviceDetails = deviceDetails;

    // body.addAll(baseRequest.toJson());

    return body;
  }
}
