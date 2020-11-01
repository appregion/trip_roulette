import 'dart:async';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trip_roulette/app/blocs/bloc.dart';
import 'package:trip_roulette/app/models/budget_type_data.dart';
import 'package:trip_roulette/app/models/budget_type_model.dart';
import 'package:trip_roulette/app/models/destination_type_data.dart';
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
  }

  void updateWith({
    double latitude,
    double longitude,
    String location,
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
    // get location name from coordinates
    String locationName = await Geolocation()
        .getLocationName(latitude: item.latitude, longitude: item.longitude);
    // update model with new values
    updateWith(
      latitude: item.latitude,
      longitude: item.longitude,
      location: locationName,
      gettingLocation: false,
    );
  }

  String locationInputText() {
    return _model.location == null
        ? 'Your current location'
        : 'Current location: ' + _model.location;
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

  void submit() {
    print(_model.location);
    print(_model.departureDate);
    print(_model.returnDate);
    print(_model.numberOfAdults);
    print(_model.numberOfKids);
    print(_model.destinationType);
    print(_model.budgetType);
  }
}
