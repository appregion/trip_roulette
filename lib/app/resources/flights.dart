import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:trip_roulette/app/models/flight_model.dart';

class Flights {
  Future<List<FlightItem>> getDirections({String iataCode}) async {
    // Get flights from this year from our destination with prices and distance and duration
    var url =
        'https://api.travelpayouts.com/v2/prices/latest?currency=usd&period_type=year&page=1&limit=1000&show_to_affiliates=true&sorting=price&origin=$iataCode&token=20a5e8b3156edfbc3f2aab405d13d0a5';
    http.Response response = await http.get(url);
    print(response.body);

    //TODO need to check if we got the right response and number of flights

    List<dynamic> decodedData = jsonDecode(response.body)['data'];
    List<FlightItem> flights =
        decodedData.map((data) => FlightItem.fromJson(data)).toList();

    return flights;
  }

  Future<int> getTicketPrice({
    String origin,
    String destination,
    DateTime departureDate,
    DateTime returnDate,
  }) async {
    String departureString = DateFormat('yyyy-MM-dd').format(departureDate);
    String returnString = DateFormat('yyyy-MM-dd').format(returnDate);
    var url =
        'https://api.travelpayouts.com/v1/prices/cheap?currency=USD&origin=$origin&destination=$destination&depart_date=$departureString&return_date=$returnString&token=20a5e8b3156edfbc3f2aab405d13d0a5';
    http.Response response = await http.get(url);
    print(response.body);

    var data = jsonDecode(response.body);
    int price;

    if (data['data']['$destination'] != null) {
      price = jsonDecode(response.body)['data']['$destination']['0']['price'];
    }
    if (price != null) {
      return price;
    } else {
      return 0;
    }
  }
}
