import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_roulette/app/models/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  final List<WeatherItem> weatherItems;
  WeatherWidget({this.weatherItems});

  List<Widget> buildWeatherItems(
      BuildContext context, List<WeatherItem> weatherItems) {
    List<Widget> items = [];
    for (var i = 0; i < weatherItems.length; i++) {
      items.add(Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            border: weatherItems[i].date.day == DateTime.now().day
                ? Border.all(
                    color: Colors.white,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE')
                      .format(weatherItems[i].date)
                      .substring(0, 3),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.network(
                  'http://openweathermap.org/img/wn/${weatherItems[i].iconName}@2x.png',
                  width:
                      MediaQuery.of(context).size.width / weatherItems.length,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${weatherItems[i].maxTemp}°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                      ),
                    ),
                    Text(
                      '${weatherItems[i].minTemp}°',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Weather Forecast',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildWeatherItems(context, weatherItems),
        ),
      ],
    );
  }
}
