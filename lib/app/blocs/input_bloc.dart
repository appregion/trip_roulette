import 'dart:async';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trip_roulette/app/blocs/bloc.dart';
import 'package:trip_roulette/app/data/budget_type_data.dart';
import 'package:trip_roulette/app/models/budget_type_model.dart';
import 'package:trip_roulette/app/data/destination_type_data.dart';
import 'package:trip_roulette/app/models/destination_type_model.dart';
import 'package:trip_roulette/app/models/geolocation_item.dart';
import 'package:trip_roulette/app/models/input_model.dart';
import 'package:trip_roulette/app/resources/geolocation.dart';

class InputBloc extends Bloc {
  final _modelSubject = BehaviorSubject<InputModel>.seeded(InputModel());

  Stream<InputModel> get modelStream => _modelSubject.stream;

  InputModel get _model => _modelSubject.value;

  @override
  void dispose() {
    _modelSubject.close();
    print('disposed');
  }

  void updateWith({
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
    // update model
    _modelSubject.add(_model.copyWith(
      latitude: latitude,
      longitude: longitude,
      location: location,
      iataCode: iataCode,
      gettingLocation: gettingLocation,
      departureDate: departureDate,
      returnDate: returnDate,
      numberOfAdults: numberOfAdults,
      numberOfKids: numberOfKids,
      destinationType: destinationType,
      budgetType: budgetType,
    ));
  }

  Future<void> getCurrentPosition() async {
    updateWith(gettingLocation: true);
    // get coordinates
    GeolocationItem item = await Geolocation().getPosition();
    // get iata code
    String iata = await Geolocation()
        .getIataCode(latitude: item.latitude, longitude: item.longitude);
    //get location name from iata code
    String location =
        await Geolocation().getLocationNameWithIataCode(iataCode: iata);
    // update model with new values
    updateWith(
      latitude: item.latitude,
      longitude: item.longitude,
      location: location,
      iataCode: iata,
      gettingLocation: false,
    );
  }

  String locationInputText() {
    return _model.location == null
        ? 'Get your current location'
        : _model.location;
  }

  void selectDate(DateTime newDate, bool isDepartureDate) {
    if (isDepartureDate) {
      if (_model.returnDate != null && newDate.isAfter(_model.returnDate)) {
        updateWith(returnDate: newDate);
        print(_model.returnDate);
      }
      updateWith(departureDate: newDate);
      print(_model.departureDate);
    } else {
      if (_model.departureDate != null &&
          newDate.isBefore(_model.departureDate)) {
        updateWith(departureDate: newDate);
      }
      updateWith(returnDate: newDate);
    }
  }

  DateTime setInitialDate(bool isDepartureDate) {
    DateTime _todayDate = DateTime.now();

    return isDepartureDate
        ? _model.departureDate != null
            ? _model.departureDate
            : _todayDate
        : _model.returnDate != null
            ? _model.returnDate
            : _model.departureDate != null
                ? _model.departureDate
                : _todayDate;
  }

  DateTime setFirstDate(bool isDepartureDate) {
    DateTime _todayDate = DateTime.now();
    return isDepartureDate
        ? _todayDate
        : _model.departureDate != null
            ? _model.departureDate
            : _todayDate;
  }

  DateTime setLastDate() {
    DateTime _todayDate = DateTime.now();
    return DateTime(_todayDate.year + 2);
  }

  String dateInputFormText(bool isDepartureDate) {
    return isDepartureDate
        ? _model.departureDate != null
            ? DateFormat('d MMMM yyyy, EEEE').format(_model.departureDate)
            : 'Select departure date'
        : _model.returnDate != null
            ? DateFormat('d MMMM yyyy, EEEE').format(_model.returnDate)
            : 'Select return date';
  }

  String peopleInputFormText() {
    return _model.numberOfKids > 0
        ? '${_model.numberOfAdults} adult(s),  ${_model.numberOfKids} kid(s)'
        : '${_model.numberOfAdults} adult(s)';
  }

  void incrementNumberOfPeople(bool isAdults) {
    if (isAdults) {
      if (_model.numberOfAdults < 9) {
        updateWith(numberOfAdults: _model.numberOfAdults + 1);
      }
    } else {
      if (_model.numberOfKids < 9) {
        updateWith(numberOfKids: _model.numberOfKids + 1);
      }
    }
  }

  void decrementNumberOfPeople(bool isAdults) {
    if (isAdults) {
      if (_model.numberOfAdults > 1) {
        updateWith(numberOfAdults: _model.numberOfAdults - 1);
      }
    } else {
      if (_model.numberOfKids > 0) {
        updateWith(numberOfKids: _model.numberOfKids - 1);
      }
    }
  }

  bool isDecrementButtonEnabled(bool isAdults) {
    return isAdults
        ? _model.numberOfAdults == 1
            ? false
            : true
        : _model.numberOfKids == 0
            ? false
            : true;
  }

  bool isIncrementButtonEnabled(bool isAdults) {
    return isAdults
        ? _model.numberOfAdults == 9
            ? false
            : true
        : _model.numberOfKids == 9
            ? false
            : true;
  }

  String adultsOrKidsNumber(bool isAdults) {
    return isAdults
        ? _model.numberOfAdults.toString()
        : _model.numberOfKids.toString();
  }

  String destinationInputFormText() {
    final List<DestinationType> _destinationTypeList = destinationTypeList;
    return _model.destinationType != null
        ? _destinationTypeList[_model.destinationType].title
        : 'Select destination';
  }

  bool destinationTypeShowCheckMark(int index) {
    return _model.destinationType != null && index == _model.destinationType
        ? true
        : false;
  }

  String budgetInputFormText() {
    final List<BudgetType> _budgetTypeList = budgetTypeList;
    return _model.budgetType != null
        ? _budgetTypeList[_model.budgetType].title
        : 'Select budget';
  }

  bool budgetTypeShowCheckMark(int index) {
    return _model.budgetType != null && index == _model.budgetType
        ? true
        : false;
  }

  void submit() async {}

  // void selectDestination() async {
  //   List<FlightItem> allFlights =
  //       await Places().getDirections(iataCode: _model.iataCode);
  //   // filter list based on destination proximity imposed by user
  //   List<FlightItem> filtered = [];
  //   allFlights.forEach((element) {
  //     int maxDistance = _model.destinationType == 0
  //         ? 500
  //         : _model.destinationType == 1
  //             ? 2000
  //             : 25000;
  //     int minDistance = _model.destinationType == 0
  //         ? 0
  //         : _model.destinationType == 1
  //             ? 500
  //             : 2000;
  //     if (element.distance > minDistance && element.distance < maxDistance) {
  //       filtered.add(element);
  //     }
  //   });
  //   print(filtered.length);
  //
  //   // loop through list until find flights for required dates
  //   // bool flightFound = false;
  //   // for (var i = 0; flightFound != true && i < filtered.length; i++) {
  //   //   int price = await Places().getTicketPrice(
  //   //     origin: _model.iataCode,
  //   //     destination: filtered[i].destination,
  //   //     departureDate: _model.departureDate,
  //   //     returnDate: _model.returnDate,
  //   //   );
  //   //   if (price != 0) {
  //   //     flightFound = true;
  //   //     print(price);
  //   //   }
  //   // }
  // }
}
