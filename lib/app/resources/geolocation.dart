import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:trip_roulette/app/models/airport_item.dart';
import 'package:trip_roulette/app/models/city_item.dart';
import 'package:trip_roulette/app/models/country_item.dart';
import 'package:trip_roulette/app/models/geolocation_item.dart';
import 'dart:convert';
import 'package:trip_roulette/app/resources/api_keys.dart';

class Geolocation {
  /// check if the user granted permission to access geolocation
  Future<bool> checkGeoPermission() async {
    LocationPermission _currentPermission = await Geolocator.checkPermission();
    if (_currentPermission == LocationPermission.denied ||
        _currentPermission == LocationPermission.deniedForever) {
      // request new permission from user and check his response
      LocationPermission _newPermission = await Geolocator.requestPermission();
      if (_newPermission == LocationPermission.denied ||
          _newPermission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  /// get latitude and longitude from the user's device
  Future<GeolocationItem> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    return GeolocationItem(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// open phone settings to change geolocation access preferences
  Future<void> openSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// get nearby airport iata code from coordinates
  Future<String> getIataCode({double latitude, double longitude}) async {
    String _iataRequestUrl = 'http://iatageo.com/getCode/$latitude/$longitude';
    http.Response _response = await http.get(_iataRequestUrl);
    if (_response.statusCode == 200) {
      String _iataCode = jsonDecode(_response.body)['IATA'];
      print('Nearby airport iata code is $_iataCode');
      return _iataCode;
    }
    return null;
  }

  /// get airport code with city code

  Future<String> getAirportCodeWithCityCode(String cityCode) async {
    final _url = 'https://api.travelpayouts.com/data/en/airports.json';
    http.Response _response = await http.get(_url);
    if (_response.statusCode == 200) {
      List<dynamic> _decodedData = jsonDecode(_response.body);
      List<AirportItem> _airports =
          _decodedData.map((data) => AirportItem.fromJson(data)).toList();
      String _airportCode = _airports
          .firstWhere((element) => element.cityCode == cityCode)
          .cityCode;
      print('Airport code is $_airportCode');
      return _airportCode;
    }
    return null;
  }

  /// get city code from airport iata code

  Future<String> getCityCodeFromIataCode(String iataCode) async {
    final _url = 'https://api.travelpayouts.com/data/en/airports.json';
    http.Response _response = await http.get(_url);
    if (_response.statusCode == 200) {
      List<dynamic> _decodedData = jsonDecode(_response.body);
      List<AirportItem> _airports =
          _decodedData.map((data) => AirportItem.fromJson(data)).toList();
      String _cityCode = _airports
          .firstWhere((element) => element.iataCode == iataCode)
          .cityCode;
      print('City code is $_cityCode');
      return _cityCode;
    }
    return null;
  }

  /// get city item with city code

  Future<City> getCityItemWithCityCode(String cityCode) async {
    final _url = 'https://api.travelpayouts.com/data/en/cities.json';
    http.Response _response = await http.get(_url);
    if (_response.statusCode == 200) {
      List<dynamic> _decodedData = jsonDecode(_response.body);
      List<City> _cities =
          _decodedData.map((data) => City.fromJson(data)).toList();
      City _cityItem =
          _cities.firstWhere((element) => element.code == cityCode);
      print('City name is ${_cityItem.name}');

      return _cityItem;
    }
    return null;
  }

  /// get country name with country code

  Future<String> getCountryNameWithCountryCode(String countryCode) async {
    final _url = 'https://api.travelpayouts.com/data/en/countries.json';
    http.Response _response = await http.get(_url);
    if (_response.statusCode == 200) {
      List<dynamic> _decodedData = jsonDecode(_response.body);
      List<Country> _countries =
          _decodedData.map((data) => Country.fromJson(data)).toList();
      String _countryName = _countries
          .firstWhere((element) => element.countryCode == countryCode)
          .name;
      print('Country name is $_countryName');

      return _countryName;
    }
    return null;
  }

  /// get location name with coordinates with Google API
  Future<String> getLocationNameWithCoordinates(
      {double latitude, double longitude}) async {
    // Get instance of api keys class where the keys are stored
    ApiKeys _apiKeys = ApiKeys();

    // assign the api key with the corresponding value
    final String _apiKey = _apiKeys.googlePlacesApiKey;

    String _url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_apiKey';
    http.Response _response = await http.get(_url);

    // check response status and return location
    String responseStatus = jsonDecode(_response.body)['status'];
    if (responseStatus == 'OK') {
      String _location = jsonDecode(_response.body)['results'][0]
          ['address_components'][0]['long_name'];
      return _location;
    } else if (responseStatus == 'ZERO_RESULTS') {
      return 'We couldn\'t find your location :(';
    } else {
      return 'Error :( Please try again';
    }
  }

  Future<GeolocationItem> getCoordinatesWithIataCode({String iataCode}) async {
    String _url = 'http://iatageo.com/getLatLng/$iataCode';
    http.Response _response = await http.get(_url);
    var decodedData = jsonDecode(_response.body);
    if (_response.statusCode == 200) {
      GeolocationItem _item = GeolocationItem(
        latitude: double.parse(decodedData['latitude']),
        longitude: double.parse(decodedData['longitude']),
      );
      return _item;
    }
    return null;
  }
}
