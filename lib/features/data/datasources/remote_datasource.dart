import '../../../core/services/api_helper.dart';
import '../models/common/base_response.dart';
import '../models/requests/sample.dart';
import '../models/responses/sample.dart';

abstract class RemoteDataSource {
  Future<BaseResponse<SampleResponse>> sample(SampleRequest request);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final APIHelper apiHelper;

  RemoteDataSourceImpl({required this.apiHelper});

  ///Splash
  @override
  Future<BaseResponse<SampleResponse>> sample(SampleRequest request) async {
    try {
      final response = await apiHelper.post(
        'auth-service/api/v1/sample',
        data: request.toJson(),
      );

      return BaseResponse<SampleResponse>.fromJson(
        response,
        (data) => SampleResponse.fromJson(data ?? {}),
      );
    } on Exception {
      rethrow;
    }
  }
}
