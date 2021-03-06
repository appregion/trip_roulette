import 'package:flutter/material.dart';
import 'package:trip_roulette/app/blocs/result_bloc.dart';
import 'package:trip_roulette/app/models/result_model.dart';

class FlightInfoWidget extends StatelessWidget {
  final ResultBloc bloc;

  FlightInfoWidget({@required this.bloc});

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

  Widget buildContent(ResultModel model) {
    if (model.tripItem != null) {
      return GridView(
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
            textBottom: '\$' + bloc.formatPrice(model.tripItem.price),
          ),
          buildInfoItem(
            icon: Icons.access_time_rounded,
            textTop: 'Duration',
            textBottom: bloc.getDurationText(model.tripItem.duration),
          ),
          buildInfoItem(
            icon: Icons.map_outlined,
            textTop: 'Distance',
            textBottom: bloc.formatDistance(model.tripItem.distance) + ' km',
          ),
          buildInfoItem(
            icon: Icons.transfer_within_a_station_outlined,
            textTop: 'Changes',
            textBottom: '${model.tripItem.numberOfChanges}',
          ),
          buildInfoItem(
            icon: Icons.access_time_rounded,
            textTop: 'Class',
            textBottom: bloc.getClassText(model.tripItem.tripClass),
          ),
        ],
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.resultModelStream,
        initialData: ResultModel(),
        builder: (context, snapshot) {
          ResultModel _model = snapshot.data;
          return Column(
            children: [
              Text(
                'Flight Info',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              ConstrainedBox(
                child: buildContent(_model),
                constraints: BoxConstraints(
                  minHeight: 250.0,
                ),
              ),
            ],
          );
        });
  }
}
