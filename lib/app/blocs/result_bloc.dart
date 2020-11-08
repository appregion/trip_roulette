import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trip_roulette/app/blocs/bloc.dart';
import 'package:trip_roulette/app/blocs/input_bloc.dart';
import 'package:trip_roulette/app/data/destination_type_data.dart';
import 'package:trip_roulette/app/models/destination_type_model.dart';
import 'package:trip_roulette/app/models/flight_model.dart';
import 'package:trip_roulette/app/models/geolocation_item.dart';
import 'package:trip_roulette/app/models/input_model.dart';
import 'package:trip_roulette/app/models/result_model.dart';
import 'package:trip_roulette/app/models/weather_model.dart';
import 'package:trip_roulette/app/resources/geolocation.dart';
import 'package:trip_roulette/app/resources/flights.dart';
import 'package:trip_roulette/app/resources/images.dart';
import 'package:trip_roulette/app/resources/places.dart';
import 'package:trip_roulette/app/resources/weather.dart';

class ResultBloc extends Bloc {
  final InputBloc inputBloc;
  ResultBloc({@required this.inputBloc});

  final _resultModelSubject =
      BehaviorSubject<ResultModel>.seeded(ResultModel());

  Stream<ResultModel> get resultModelStream => _resultModelSubject.stream;

  ResultModel get _resultModel => _resultModelSubject.value;

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
    await getLocationName(_resultModel.tripItem.destination);
    await getDestinationCoordinates();
    await getWeather();
    await getPlacesNearBy();
    // uncomment in production
    // await getImages();
    updateWith(loadingResult: false);
  }

  Future<void> getInputData() async {
    InputModel inputModel = await inputBloc.modelStream.first;
    updateWith(inputModel: inputModel);
    print('some input data: ${_resultModel.inputModel.location}');
  }

  Future<void> getLocationName(String iataCode) async {
    String locationName =
        await Geolocation().getLocationNameWithIataCode(iataCode: iataCode);
    updateWith(destinationName: locationName);
  }

  Future<void> selectFlight() async {
    List<DestinationType> _destinationTypeList = destinationTypeList;
    // get available flights from our origin and put them into a list
    print('origin iata: ${_resultModel.inputModel.iataCode}');

    List<FlightItem> allFlights = await Flights()
        .getDirections(iataCode: _resultModel.inputModel.iataCode);

    // Leave only the flights that satisfy distance requirements
    List<FlightItem> flightsFilteredByDistance = [];
    allFlights.forEach((element) {
      if (element.distance >
              _destinationTypeList[_resultModel.inputModel.destinationType]
                  .minDistance &&
          element.distance <
              _destinationTypeList[_resultModel.inputModel.destinationType]
                  .maxDistance) {
        flightsFilteredByDistance.add(element);
      } else {}
    });

    print(flightsFilteredByDistance.length);
    // Get flight according to budget criteria
    FlightItem selectedItem;
    if (flightsFilteredByDistance.length > 8) {
      if (_resultModel.inputModel.budgetType == 0) {
        int randomNumber =
            Random().nextInt((0.33 * flightsFilteredByDistance.length).toInt());
        print('random number is $randomNumber');
        selectedItem = flightsFilteredByDistance[randomNumber];
      } else if (_resultModel.inputModel.budgetType == 1) {
        int randomNumber = Random()
                .nextInt((0.33 * flightsFilteredByDistance.length).toInt()) +
            (0.33 * flightsFilteredByDistance.length).toInt();
        print('random number is $randomNumber');
        selectedItem = flightsFilteredByDistance[randomNumber];
      } else {
        int randomNumber = Random().nextInt(flightsFilteredByDistance.length -
                (0.66 * flightsFilteredByDistance.length).toInt()) +
            (0.66 * flightsFilteredByDistance.length).toInt();
        print('random number is $randomNumber');
        selectedItem = flightsFilteredByDistance[randomNumber];
      }
    } else {
      if (_resultModel.inputModel.budgetType == 0) {
        selectedItem = flightsFilteredByDistance.first;
      } else if (_resultModel.inputModel.budgetType == 1) {
        selectedItem =
            flightsFilteredByDistance[flightsFilteredByDistance.length ~/ 2];
      } else {
        selectedItem = flightsFilteredByDistance.last;
      }
    }
    print(selectedItem.destination);
    updateWith(tripItem: selectedItem);
  }

  Future<void> getImages() async {
    ImageProvider image = await Images()
        .getImageFromGoogle(locationName: _resultModel.destinationName);
    // List<ImageItem> images = await Images()
    //     .getImagesFromMediaWiki(location: _resultModel.destinationName);
    updateWith(image: image);
  }

  Future<void> getDestinationCoordinates() async {
    GeolocationItem item = await Geolocation().getCoordinatesWithIataCode(
        iataCode: _resultModel.tripItem.destination);
    _resultModel.tripItem.latitude = item.latitude;
    _resultModel.tripItem.longitude = item.longitude;
    updateWith(tripItem: _resultModel.tripItem);
  }

  Future<void> getWeather() async {
    List<WeatherItem> items = await Weather().getWeather(
      latitude: _resultModel.tripItem.latitude,
      longitude: _resultModel.tripItem.longitude,
    );
    updateWith(weatherItems: items);
  }

  Future<void> getPlacesNearBy() async {
    List<PlaceItem> items = await Places().getPlacesNearBy(
      latitude: _resultModel.tripItem.latitude,
      longitude: _resultModel.tripItem.longitude,
    );
    updateWith(placeItems: items);
  }

  @override
  void dispose() {
    _resultModelSubject.close();
  }
}
