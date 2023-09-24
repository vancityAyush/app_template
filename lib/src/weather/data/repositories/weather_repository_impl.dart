import 'package:app_template/core/errors/exceptions.dart';
import 'package:app_template/core/errors/failure.dart';
import 'package:app_template/core/utils/typedef.dart';
import 'package:app_template/src/weather/data/datasources/weather_remote_data_source.dart';
import 'package:app_template/src/weather/domain/entities/weather.dart';
import 'package:app_template/src/weather/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;

  WeatherRepositoryImpl(this._remoteDataSource);

  // Test-Driven Development (TDD)
  // call the remote data source
  // make sure that it returns the proper date if there is no exception
  // check if the mothod returns the proper data
  // check if when the remoteDataSource throws an exception, we return a failure
  // and if it doesn't throw an exception, we return a success data

  @override
  ResultFuture<Weather> fetchCityWeather({required String cityName}) async {
    try {
      final result =
          await _remoteDataSource.fetchCityWeather(cityName: cityName);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<Weather> fetchLocationWeather(
      {required String lat, required String long}) async {
    try {
      final result =
          await _remoteDataSource.fetchLocationWeather(lat: lat, long: long);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
