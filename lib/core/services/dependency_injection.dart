import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/data/datasources/local_datasource.dart';
import '../../features/data/datasources/remote_datasource.dart';
import '../../features/data/repositories/repository_impl.dart';
import '../../features/domain/respositories/repository.dart';
import '../../features/domain/usecases/sample/sample.dart';
import '../../features/presentation/bloc/sample/sample_bloc.dart';
import 'api_helper.dart';
import '../network/network_info.dart';

final inject = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  const flutterSecureStorage = FlutterSecureStorage();

  inject.registerSingleton(DeviceInfoPlugin());

  inject.registerLazySingleton(() => sharedPreferences);
  inject.registerLazySingleton(() => packageInfo);
  inject.registerLazySingleton(() => flutterSecureStorage);

  inject.registerLazySingleton<LocalDatasource>(
    () => LocalDatasource(
      securePreferences: inject(),
      sharedPreferences: inject(),
    ),
  );
  inject.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(apiHelper: inject()),
  );

  inject.registerSingleton(Dio());
  inject.registerLazySingleton<APIHelper>(
    () => APIHelper(
      dio: inject(),
      localDatasource: inject(),
    ),
  );
  inject.registerLazySingleton(() => Connectivity());
  inject.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(inject()));

  /// Repository
  inject.registerLazySingleton<Repository>(
    () => RepositoryImpl(remoteDataSource: inject(), networkInfo: inject()),
  );

  /// UseCases
  inject.registerLazySingleton(
    () => SampleUseCase(repository: inject()),
  );

  /// Blocs
  inject.registerFactory(
    () => SampleBloc(
      sampleUseCase: SampleUseCase(),
    ),
  );
}
