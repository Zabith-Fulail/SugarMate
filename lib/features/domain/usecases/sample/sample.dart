import 'package:dartz/dartz.dart';

import '../../../data/models/common/base_response.dart';
import '../../../data/models/requests/sample.dart';
import '../../../data/models/responses/sample.dart';
import '../../respositories/repository.dart';
import '../usecase.dart';

class SampleUseCase
    extends UseCase<BaseResponse<SampleResponse>, SampleRequest> {
  final Repository? repository;

  SampleUseCase({this.repository});

  @override
  Future<Either<dynamic, BaseResponse<SampleResponse>>> call(
      SampleRequest params) async {
    return await repository!.sample(params);
  }
}
