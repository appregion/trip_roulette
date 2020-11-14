import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:trip_roulette/app/blocs/bloc.dart';
import 'package:trip_roulette/app/blocs/input_bloc.dart';
import 'package:trip_roulette/app/data/destination_type_data.dart';
import 'package:trip_roulette/app/models/city_item.dart';
import 'package:trip_roulette/app/models/destination_type_model.dart';
import 'package:trip_roulette/app/models/flight_model.dart';
import 'package:trip_roulette/app/models/geolocation_item.dart';
import 'package:trip_roulette/app/models/image_item.dart';
import 'package:trip_roulette/app/models/input_model.dart';
import 'package:trip_roulette/app/models/place_item.dart';
import 'package:trip_roulette/app/models/result_model.dart';
import 'package:trip_roulette/app/models/weather_model.dart';
import 'package:trip_roulette/app/resources/geolocation.dart';
import 'package:trip_roulette/app/resources/flights.dart';
import 'package:trip_roulette/app/resources/images.dart';
import 'package:trip_roulette/app/resources/places.dart';
import 'package:trip_roulette/app/resources/weather.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultBloc extends Bloc {
  final InputBloc inputBloc;
  ResultBloc({@required this.inputBloc});

  final _resultModelSubject =
      BehaviorSubject<ResultModel>.seeded(ResultModel());

  Stream<ResultModel> get resultModelStream => _resultModelSubject.stream;

  ResultModel get _resultModel => _resultModelSubject.value;

  @override
  void dispose() {
    _resultModelSubject.close();
  }

  void updateWith({
    bool loadingResult,
    String destinationName,
    List<ImageItem> images,
    ImageProvider image,
    InputModel inputModel,
    FlightItem tripItem,
    List<WeatherItem> weatherItems,
    List<PlaceItem> placeItems,
  }) {
    // update model
    _resultModelSubject.add(_resultModel.copyWith(
      loadingResult: loadingResult,
      destinationName: destinationName,
      images: images,
      image: image,
      inputModel: inputModel,
      tripItem: tripItem,
      weatherItems: weatherItems,
      placeItems: placeItems,
    ));
  }

  Future<void> loadData() async {
    await getInputData();

    await selectFlight();

    // get location name
    await getLocationName(_resultModel.tripItem.destination);

    // get airport code with city code
    String _airportCode = await Geolocation()
        .getAirportCodeWithCityCode(_resultModel.tripItem.destination);

    if (_airportCode != null) {
      // get coordinates with airport code
      GeolocationItem _item = await Geolocation()
          .getCoordinatesWithIataCode(iataCode: _airportCode);
      await getWeather(latitude: _item.latitude, longitude: _item.longitude);
      await getPlacesNearBy(
          latitude: _item.latitude, longitude: _item.longitude);
    }

    // uncomment in production
    // await getImages();

    updateWith(loadingResult: false);
  }

  Future<void> getInputData() async {
    InputModel inputModel = await inputBloc.modelStream.first;
    updateWith(inputModel: inputModel);
  }

  Future<void> selectFlight() async {
    List<DestinationType> _destinationTypeList = destinationTypeList;
    // get available flights from our origin and put them into a list

    List<FlightItem> _flights = await Flights()
        .getDirections(iataCode: _resultModel.inputModel.iataCode);
    if (_flights.isNotEmpty) {
      // Leave only the flights that satisfy distance requirements
      List<FlightItem> _flightsFilteredByDistance = [];
      _flights.forEach((element) {
        if (element.distance >
                _destinationTypeList[_resultModel.inputModel.destinationType]
                    .minDistance &&
            element.distance <
                _destinationTypeList[_resultModel.inputModel.destinationType]
                    .maxDistance) {
          _flightsFilteredByDistance.add(element);
        }
      });
      // Get single flight according to budget criteria from filtered list
      FlightItem _selectedItem;
      int _randomNumber;
      if (_flightsFilteredByDistance.length > 6) {
        if (_resultModel.inputModel.budgetType == 0) {
          _randomNumber = Random()
              .nextInt((0.33 * _flightsFilteredByDistance.length).toInt());
          print('random number is $_randomNumber');
          _selectedItem = _flightsFilteredByDistance[_randomNumber];
        } else if (_resultModel.inputModel.budgetType == 1) {
          _randomNumber = Random()
                  .nextInt((0.33 * _flightsFilteredByDistance.length).toInt()) +
              (0.33 * _flightsFilteredByDistance.length).toInt();
          print('random number is $_randomNumber');
          _selectedItem = _flightsFilteredByDistance[_randomNumber];
        } else {
          _randomNumber = Random().nextInt(_flightsFilteredByDistance.length -
                  (0.66 * _flightsFilteredByDistance.length).toInt()) +
              (0.66 * _flightsFilteredByDistance.length).toInt();
          print('random number is $_randomNumber');
          _selectedItem = _flightsFilteredByDistance[_randomNumber];
        }
      } else {
        if (_resultModel.inputModel.budgetType == 0) {
          _selectedItem = _flightsFilteredByDistance.first;
        } else if (_resultModel.inputModel.budgetType == 1) {
          _selectedItem = _flightsFilteredByDistance[
              _flightsFilteredByDistance.length ~/ 2];
        } else {
          _selectedItem = _flightsFilteredByDistance.last;
        }
      }
      updateWith(tripItem: _selectedItem);
    }
  }

  Future<void> getImages() async {
    ImageProvider image = await Images()
        .getImageFromGoogle(locationName: _resultModel.destinationName);
    // List<ImageItem> images = await Images()
    //     .getImagesFromMediaWiki(location: _resultModel.destinationName);
    updateWith(image: image);
  }

  Future<void> getLocationName(String cityCode) async {
    String _location = 'No name';
    City _cityItem = await Geolocation().getCityItemWithCityCode(cityCode);
    if (_cityItem != null) {
      // get city name & country name and assign them to location string
      String _cityName = _cityItem.name;
      String _countryName = await Geolocation()
          .getCountryNameWithCountryCode(_cityItem.countryCode);
      if (_countryName != null) {
        _location = _cityName + ', ' + _countryName;
      } else {
        _location = _cityName;
      }
    }
    updateWith(destinationName: _location);
  }

  Future<void> getWeather({double latitude, double longitude}) async {
    List<WeatherItem> items = await Weather().getWeather(
      latitude: latitude,
      longitude: longitude,
    );
    updateWith(weatherItems: items);
  }

  Future<void> getPlacesNearBy({double latitude, double longitude}) async {
    List<PlaceItem> items = await Places().getPlacesNearBy(
      latitude: latitude,
      longitude: longitude,
    );
    updateWith(placeItems: items);
  }

  Future<void> openNearByPlace(int pageId) async {
    String _url = await Places().getPageUrlById(pageId);
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }

  Future<void> share() async {
    final String _text =
        'Trip Roulette:\nDestination: ${_resultModel.destinationName}\nPrice from: \$${formatPrice(_resultModel.tripItem.price)}\nFlight duration: ${getDurationText(_resultModel.tripItem.duration)} \nDistance: ${formatDistance(_resultModel.tripItem.distance)} km';
    await Share.share(_text);
  }

  String getClassText(int tripClass) {
    return tripClass == 0
        ? 'Economy'
        : tripClass == 1
            ? 'Business'
            : 'First';
  }

  String formatDistance(int tripDistance) {
    String number = tripDistance.toString();
    if (number.length > 3) {
      String partTwo = number.substring(number.length - 3, number.length);
      String partOne = number.substring(0, number.length - partTwo.length);
      number = partOne + ' ' + partTwo;
    }
    return number;
  }

  String formatPrice(double tripPrice) {
    String number = tripPrice.toString();
    if (number.length > 6) {
      String partTwo = number.substring(number.length - 6, number.length);
      String partOne = number.substring(0, number.length - partTwo.length);
      number = partOne + ',' + partTwo;
    }
    return number;
  }

  String getDurationText(int tripDuration) {
    int hours = (tripDuration / 60).floor();
    int minutes = tripDuration - (hours * 60);
    String duration = '${hours}h ${minutes}m';
    return duration;
  }
}
