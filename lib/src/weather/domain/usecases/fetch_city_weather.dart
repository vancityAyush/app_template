import 'package:app_template/core/usecase/usecase.dart';
import 'package:app_template/core/utils/typedef.dart';
import 'package:app_template/src/weather/domain/entities/weather.dart';
import 'package:app_template/src/weather/domain/repositories/weather_repository.dart';

class FetchCityWeather extends UsecaseWithParams<Weather, String> {
  const FetchCityWeather(this._repository);

  final WeatherRepository _repository;

  @override
  ResultFuture<Weather> call(String cityName) async =>
      _repository.fetchCityWeather(
        cityName: cityName,
      );
}
