class InputModel {
  InputModel({
    this.latitude,
    this.longitude,
    this.location,
    this.iataCode,
    this.gettingLocation = false,
    this.departureDate,
    this.returnDate,
    this.numberOfAdults = 1,
    this.numberOfKids = 0,
    this.destinationType,
    this.budgetType,
  });
  final double latitude;
  final double longitude;
  final String location;
  final String iataCode;
  final bool gettingLocation;
  final DateTime departureDate;
  final DateTime returnDate;
  final int numberOfAdults;
  final int numberOfKids;
  final int destinationType;
  final int budgetType;

  InputModel copyWith({
    double latitude,
    double longitude,
    String location,
    String iataCode,
    bool gettingLocation,
    DateTime departureDate,
    DateTime returnDate,
    int numberOfAdults,
    int numberOfKids,
    int destinationType,
    int budgetType,
  }) {
    return InputModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      iataCode: iataCode ?? this.iataCode,
      gettingLocation: gettingLocation ?? this.gettingLocation,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      numberOfAdults: numberOfAdults ?? this.numberOfAdults,
      numberOfKids: numberOfKids ?? this.numberOfKids,
      destinationType: destinationType ?? this.destinationType,
      budgetType: budgetType ?? this.budgetType,
    );
  }
}
