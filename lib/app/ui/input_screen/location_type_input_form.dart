import 'package:flutter/material.dart';
import 'package:trip_roulette/app/blocs/input_bloc.dart';
import 'package:trip_roulette/app/data/destination_type_data.dart';
import 'package:trip_roulette/app/models/destination_type_model.dart';
import 'package:trip_roulette/app/models/input_model.dart';
import 'package:trip_roulette/widgets/modal_bottom_sheet.dart';

class LocationTypeInputForm extends StatelessWidget {
  final InputBloc bloc;
  LocationTypeInputForm({this.bloc});

  final List<DestinationType> _destinationTypeList = destinationTypeList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.modelStream,
        initialData: InputModel(),
        builder: (context, snapshot) {
          return CustomBottomSheet(title: 'Destination Type', widgetList: [
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _destinationTypeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      bloc.updateWith(destinationType: index);
                    },
                    title: Text(
                      _destinationTypeList[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _destinationTypeList[index].subtitle,
                    ),
                    trailing: bloc.destinationTypeShowCheckMark(index)
                        ? Icon(
                            Icons.check_outlined,
                            color: Colors.blue,
                          )
                        : null,
                  );
                }),
          ]);
        });
  }
}
