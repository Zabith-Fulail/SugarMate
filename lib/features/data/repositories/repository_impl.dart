import 'package:dartz/dartz.dart';
import '../../../core/network/network_info.dart';
import '../../../utils/app_strings.dart';
import '../../domain/respositories/repository.dart';
import '../datasources/remote_datasource.dart';
import '../models/common/base_response.dart';
import '../models/requests/sample.dart';
import '../models/responses/sample.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource? remoteDataSource;
  final NetworkInfo? networkInfo;

  RepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  /// Splash
  @override
  Future<Either<dynamic, BaseResponse<SampleResponse>>> sample(
    SampleRequest params,
  ) async {
    if (await networkInfo!.isConnected) {
      try {
        final parameters = await remoteDataSource!.sample(params);
        return Right(parameters);
      } catch (e) {
        return Left(e);
      }
    } else {
      return Left(AppStrings.noInternetErrorMsg);
    }
  }
}
