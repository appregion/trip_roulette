import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:trip_roulette/app/models/city_item.dart';
import 'package:trip_roulette/app/models/country_item.dart';
import 'package:trip_roulette/app/models/geolocation_item.dart';
import 'dart:convert';

class Geolocation {
  // get latitude and longitude from user's device

  Future<GeolocationItem> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    return GeolocationItem(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  // get IATA code using lat and lon

  Future<String> getIataCode({double latitude, double longitude}) async {
    var iataRequestUrl = 'http://iatageo.com/getCode/$latitude/$longitude';
    http.Response response = await http.get(iataRequestUrl);
    String iataCode = jsonDecode(response.body)['IATA'];
    print(iataCode);
    return iataCode;
  }

  Future<GeolocationItem> getCoordinatesWithIataCode({String iataCode}) async {
    String coordinatesRequestUrl = 'http://iatageo.com/getLatLng/$iataCode';
    http.Response response = await http.get(coordinatesRequestUrl);
    var decodedData = jsonDecode(response.body);
    GeolocationItem item = GeolocationItem(
      latitude: double.parse(decodedData['latitude']),
      longitude: double.parse(decodedData['longitude']),
    );
    print(item.latitude);
    return item;
  }

  Future<String> getLocationNameWithIataCode({String iataCode}) async {
    // get list of cities which include iata codes

    var citiListUrl = 'https://api.travelpayouts.com/data/en/cities.json';
    http.Response cityResponse = await http.get(citiListUrl);

    List<dynamic> decodedData = jsonDecode(cityResponse.body);
    List<City> cities = decodedData.map((data) => City.fromJson(data)).toList();
    print('number of cities: ${cities.length}');
    int index = cities.indexWhere((element) => element.code == iataCode);

    // get list of countries which include country codes

    var countryUrl = 'https://api.travelpayouts.com/data/en/countries.json';
    http.Response countryResponse = await http.get(countryUrl);
    List<dynamic> decodedCountryData = jsonDecode(countryResponse.body);
    List<Country> countries =
        decodedCountryData.map((data) => Country.fromJson(data)).toList();
    int countryIndex = countries.indexWhere(
        (element) => element.countryCode == cities[index].countryCode);
    return cities[index].name + ', ' + countries[countryIndex].name;
  }

  Future<String> getLocationNameWithCoordinates(
      {double latitude, double longitude}) async {
    // Google Geo coding Api

    var url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyBSxH7o6uHoC_Ja1U6HTKwEYFi4ehhgWUg';
    http.Response response = await http.get(url);

    // check response status and return location
    String responseStatus = jsonDecode(response.body)['status'];
    if (responseStatus == 'OK') {
      String location = jsonDecode(response.body)['results'][0]
          ['address_components'][0]['long_name'];
      return location;
    } else if (responseStatus == 'ZERO_RESULTS') {
      return 'We couldn\'t find your location :(';
    } else {
      return 'Error :( Please try again';
    }
  }
}
