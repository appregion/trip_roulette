import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_roulette/app/models/weather_model.dart';
import 'package:trip_roulette/app/resources/api_keys.dart';

class Weather {
  Future<List<WeatherItem>> getWeather(
      {double latitude, double longitude}) async {
    // Get instance of api keys class where the keys are stored
    ApiKeys apiKeys = ApiKeys();

    // assign the api key with the corresponding value
    final String _apiKey = apiKeys.openWeatherApiKey;

    String _url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&units=metric&exclude=hourly,minutely&appid=$_apiKey';

    http.Response _response = await http.get(_url);
    if (_response.statusCode == 200) {
      List<dynamic> _weatherData = jsonDecode(_response.body)['daily'];
      List<WeatherItem> _items = [];

      for (var i = 0; i < _weatherData.length; i++) {
        _items.add(WeatherItem(
          date:
              DateTime.fromMillisecondsSinceEpoch(_weatherData[i]['dt'] * 1000),
          minTemp: _weatherData[i]['temp']['min'].toInt(),
          maxTemp: _weatherData[i]['temp']['max'].toInt(),
          iconName: _weatherData[i]['weather'][0]['icon'],
        ));
      }
      return _items;
    } else {
      return null;
    }
  }
}
