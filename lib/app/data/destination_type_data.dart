import 'package:trip_roulette/app/models/destination_type_model.dart';

final List<DestinationType> destinationTypeList = [
  DestinationType(
    title: 'Around me',
    subtitle: 'Destinations within 2 000 km',
    isSelected: false,
    minDistance: 0,
    maxDistance: 2000,
  ),
  DestinationType(
    title: 'Moderate distance',
    subtitle: 'Destinations within 5 000 km',
    isSelected: false,
    minDistance: 2000,
    maxDistance: 5000,
  ),
  DestinationType(
    title: 'Travel the world',
    subtitle: 'Any place in the world',
    isSelected: false,
    minDistance: 5000,
    maxDistance: 25000,
  ),
];
