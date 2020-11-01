import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:trip_roulette/app/models/geolocation_item.dart';
import 'dart:convert';

class Geolocation {
  Future<GeolocationItem> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    return GeolocationItem(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<String> getLocationName({double latitude, double longitude}) async {
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
