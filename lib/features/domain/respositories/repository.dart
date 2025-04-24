import 'package:dartz/dartz.dart';

import '../../data/models/common/base_response.dart';
import '../../data/models/requests/sample.dart';
import '../../data/models/responses/sample.dart';

abstract class Repository {
  Future<Either<dynamic, BaseResponse<SampleResponse>>> sample(
      SampleRequest params);
}