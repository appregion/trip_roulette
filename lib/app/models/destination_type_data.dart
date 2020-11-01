import 'package:trip_roulette/app/models/destination_type_model.dart';

final List<DestinationType> destinationTypeList = [
  DestinationType(
    title: 'Around me',
    subtitle: 'Destinations within 250 km',
    isSelected: false,
  ),
  DestinationType(
    title: 'Moderate distance',
    subtitle: 'Destinations within 750 km',
    isSelected: false,
  ),
  DestinationType(
    title: 'Travel the world',
    subtitle: 'Destinations within 10.000+ km',
    isSelected: false,
  ),
];
