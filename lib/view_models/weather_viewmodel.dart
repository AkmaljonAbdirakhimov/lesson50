import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_http_services.dart';

class WeatherViewmodel {
  final weatherHttpServices = WeatherHttpServices();

  Future<Weather?> getWeather(String city) async {
    final weatherData = await weatherHttpServices.getWeather(city);

    return weatherData;
  }
}
