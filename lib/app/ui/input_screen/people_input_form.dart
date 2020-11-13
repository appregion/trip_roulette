import 'package:flutter/material.dart';
import 'package:trip_roulette/app/blocs/input_bloc.dart';
import 'package:trip_roulette/app/models/input_model.dart';
import 'package:trip_roulette/app/ui/widgets/modal_bottom_sheet.dart';
import 'package:trip_roulette/app/ui/widgets/round_icon_button.dart';

class NumberOfPeopleInputForm extends StatelessWidget {
  final InputBloc bloc;

  NumberOfPeopleInputForm({@required this.bloc});

  Widget buildListTile(
      String title, String subtitle, bool isAdults, InputModel model) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoundIconButton(
            icon: Icons.remove,
            enabledColor: Colors.blue,
            disabledColor: Colors.black12,
            isEnabled: bloc.isDecrementButtonEnabled(isAdults),
            onTap: () {
              bloc.decrementNumberOfPeople(isAdults);
            },
          ),
          SizedBox(
            width: 20.0,
          ),
          SizedBox(
            width: 20.0,
            child: Text(
              bloc.adultsOrKidsNumber(isAdults),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          RoundIconButton(
            icon: Icons.add,
            enabledColor: Colors.blue,
            disabledColor: Colors.black12,
            isEnabled: bloc.isIncrementButtonEnabled(isAdults),
            onTap: () {
              bloc.incrementNumberOfPeople(isAdults);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InputModel>(
        stream: bloc.modelStream,
        initialData: InputModel(),
        builder: (context, snapshot) {
          InputModel model = snapshot.data;
          return CustomBottomSheet(
            title: 'Number of people',
            widgetList: [
              buildListTile(
                'Adults',
                '18+',
                true,
                model,
              ),
              buildListTile(
                'Kids',
                'From 0 up to 17',
                false,
                model,
              ),
            ],
          );
        });
  }
}
