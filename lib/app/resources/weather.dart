import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_roulette/app/models/weather_model.dart';

class Weather {
  Future<List<WeatherItem>> getWeather(
      {double latitude, double longitude}) async {
    String appId = 'ce3cfe3cb651ea67676b5d84df035fc4';

    var url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&units=metric&exclude=hourly,minutely&appid=$appId';

    http.Response response = await http.get(url);
    List<dynamic> weatherData = jsonDecode(response.body)['daily'];
    List<WeatherItem> items = [];

    for (var i = 0; i < weatherData.length; i++) {
      items.add(WeatherItem(
        date: DateTime.fromMillisecondsSinceEpoch(weatherData[i]['dt'] * 1000),
        minTemp: weatherData[i]['temp']['min'].toInt(),
        maxTemp: weatherData[i]['temp']['max'].toInt(),
        iconName: weatherData[i]['weather'][0]['icon'],
      ));
    }
    return items;
  }
}
