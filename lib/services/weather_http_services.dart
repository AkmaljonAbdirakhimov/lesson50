import 'dart:convert';

import 'package:weather_app/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherHttpServices {
  Future<Weather?> getWeather(String city) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=4fbcaea02da3f8d21a4ac27cfc5dca4c");
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      Weather? weather;
      if (data != null) {
        final latLon = await getLatLon(city);
        if (latLon.isNotEmpty) {
          data['airQualityIndex'] =
              await getAirQuality(latLon['lat'], latLon['lon']);
        }
        weather = Weather.fromJson(data);
      }
      return weather;
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<Map<String, dynamic>> getLatLon(String city) async {
    Uri url = Uri.parse(
        "http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=4fbcaea02da3f8d21a4ac27cfc5dca4c");
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      Map<String, dynamic> latLon = {};
      if (data != null) {
        latLon['lat'] = data[0]['lat'];
        latLon['lon'] = data[0]['lon'];
      }
      return latLon;
    } catch (e) {
      print(e);
    }

    return {};
  }

  Future<int?> getAirQuality(double lat, double lon) async {
    Uri url = Uri.parse(
        "https://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$lon&key=7935dab1-f9b0-4825-b778-a431d28cba9e");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      if (data != null) {
        return data['data']['current']['pollution']['aqius'];
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
