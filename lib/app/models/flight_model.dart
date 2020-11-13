import 'package:intl/intl.dart';

class FlightItem {
  double price;
  String origin;
  String destination;
  int duration;
  int distance;
  DateTime departureDate;
  DateTime returnDate;
  int tripClass;
  int numberOfChanges;

  FlightItem({
    this.price,
    this.origin,
    this.destination,
    this.duration,
    this.distance,
    this.departureDate,
    this.returnDate,
    this.tripClass,
    this.numberOfChanges,
  });

  factory FlightItem.fromJson(Map<String, dynamic> data) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return FlightItem(
      price: data['value'],
      origin: data['origin'],
      destination: data['destination'],
      duration: data['duration'],
      distance: data['distance'],
      departureDate: dateFormat.parse(data['depart_date']),
      returnDate: dateFormat.parse(data['return_date']),
      tripClass: data['trip_class'],
      numberOfChanges: data['number_of_changes'],
    );
  }
}
