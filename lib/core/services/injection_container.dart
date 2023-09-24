import 'package:app_template/src/authentication/data/datasources/authenrication_remote_data_source.dart';
import 'package:app_template/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:app_template/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:app_template/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:app_template/src/weather/data/datasources/weather_remote_data_source.dart';
import 'package:app_template/src/weather/domain/repositories/weather_repository.dart';
import 'package:app_template/src/weather/presentation/bloc/weather_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../src/authentication/domain/usecases/create_user.dart';
import '../../src/authentication/domain/usecases/get_user.dart';
import '../../src/weather/data/repositories/weather_repository_impl.dart';
import '../../src/weather/domain/usecases/fetch_city_weather.dart';
import '../../src/weather/domain/usecases/fetch_location_weather.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // app logic
    ..registerFactory(
      () => AuthenticationCubit(createUser: sl(), getUsers: sl()),
    )
    // use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    // repositories
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(sl()),
    )
    // data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthRemoteDataSrcImpl(sl()),
    )
    // external dependencies
    ..registerLazySingleton(http.Client.new);

  final dio = Dio();
  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    requestBody: true,
    requestHeader: true,
    responseHeader: true,
  ));

  sl
    ..registerFactory(
        () => WeatherBloc(fetchCityWeather: sl(), fetchLocationWeather: sl()))
    ..registerLazySingleton(() => FetchCityWeather(sl()))
    ..registerLazySingleton(() => FetchLocationWeather(sl()))
    ..registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(sl()))
    ..registerLazySingleton<WeatherRemoteDataSource>(
        () => OpenApiRemoteDataSrcImpl(sl()))
    ..registerLazySingleton(() => dio);
}
