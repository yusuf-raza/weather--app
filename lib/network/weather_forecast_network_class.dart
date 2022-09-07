import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_forecast/model/weather_forecast_model.dart';

import '../model/weather_forecast_model.dart';

class WeatherForecastNetwork {
  Future<WeatherForecastModel> getForecast(String city) async {
    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=b3737c6164164c90a4244827220604&q="+city+"&days=10&aqi=no&alerts=no"
        ;

    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(response.body);
      return WeatherForecastModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("error");
    }
  }
}
