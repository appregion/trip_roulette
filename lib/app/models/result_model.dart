import 'package:flutter/material.dart';
import 'package:trip_roulette/app/models/flight_model.dart';
import 'package:trip_roulette/app/models/place_item.dart';
import 'package:trip_roulette/app/models/weather_model.dart';
import 'package:trip_roulette/app/resources/images.dart';

import 'input_model.dart';

class ResultModel {
  ResultModel({
    this.loadingResult = true,
    this.destinationName,
    this.images,
    this.image,
    this.inputModel,
    this.tripItem,
    this.weatherItems,
    this.placeItems,
  });

  final bool loadingResult;
  final String destinationName;
  final List<ImageItem> images;
  final ImageProvider image;
  final InputModel inputModel;
  final FlightItem tripItem;
  final List<WeatherItem> weatherItems;
  final List<PlaceItem> placeItems;

  ResultModel copyWith({
    bool loadingResult,
    String destinationName,
    List<ImageItem> images,
    ImageProvider image,
    InputModel inputModel,
    FlightItem tripItem,
    List<WeatherItem> weatherItems,
    List<PlaceItem> placeItems,
  }) {
    return ResultModel(
      loadingResult: loadingResult ?? this.loadingResult,
      destinationName: destinationName ?? this.destinationName,
      images: images ?? this.images,
      image: image ?? this.image,
      inputModel: inputModel ?? this.inputModel,
      tripItem: tripItem ?? this.tripItem,
      weatherItems: weatherItems ?? this.weatherItems,
      placeItems: placeItems ?? this.placeItems,
    );
  }
}
