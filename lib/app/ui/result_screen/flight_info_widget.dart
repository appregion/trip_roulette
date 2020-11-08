import 'package:flutter/material.dart';
import 'package:trip_roulette/app/models/result_model.dart';

class FlightInfoWidget extends StatelessWidget {
  final ResultModel model;

  FlightInfoWidget({@required this.model});

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

  Widget buildInfoItem({
    IconData icon,
    String textTop,
    String textBottom,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                textTop,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.5,
              ),
              Text(
                textBottom,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Flight Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 0.0,
          ),
          physics: ScrollPhysics(), // to disable GridView's scrolling
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: 15.0,
            bottom: 0.0,
          ),
          children: [
            buildInfoItem(
              icon: Icons.flight_rounded,
              textTop: 'Directions',
              textBottom:
                  '${model.inputModel.iataCode} - ${model.tripItem.destination}',
            ),
            buildInfoItem(
              icon: Icons.attach_money,
              textTop: 'Price from',
              textBottom: '\$' + formatPrice(model.tripItem.price),
            ),
            buildInfoItem(
              icon: Icons.access_time_rounded,
              textTop: 'Duration',
              textBottom: getDurationText(model.tripItem.duration),
            ),
            buildInfoItem(
              icon: Icons.map_outlined,
              textTop: 'Distance',
              textBottom: formatDistance(model.tripItem.distance) + ' km',
            ),
            buildInfoItem(
              icon: Icons.transfer_within_a_station_outlined,
              textTop: 'Changes',
              textBottom: '${model.tripItem.numberOfChanges}',
            ),
            buildInfoItem(
              icon: Icons.access_time_rounded,
              textTop: 'Class',
              textBottom: getClassText(model.tripItem.tripClass),
            ),
          ],
        ),
      ],
    );
  }
}
