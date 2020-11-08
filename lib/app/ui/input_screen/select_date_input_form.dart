import 'package:flutter/material.dart';
import 'package:trip_roulette/app/blocs/input_bloc.dart';

class SelectDateInputForm extends StatelessWidget {
  final InputBloc bloc;
  final bool validated;
  SelectDateInputForm({
    @required this.bloc,
    @required this.validated,
  });

  Future _selectDate(BuildContext context, bool isDepartureDate) async {
    final DateTime newDate = await showDatePicker(
      context: context,
      helpText: 'Please select a date',
      cancelText: 'Cancel',
      confirmText: 'Ok',
      initialDate: bloc.setInitialDate(isDepartureDate),
      firstDate: bloc.setFirstDate(isDepartureDate),
      lastDate: bloc.setLastDate(),
    );
    bloc.selectDate(newDate, isDepartureDate);
  }

  Widget buildSingleDateInput(BuildContext context, bool isDepartureDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isDepartureDate),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        height: 60.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.date_range,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                bloc.dateInputFormText(isDepartureDate),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        validated
            ? SizedBox()
            : Text(
                'Required field: ',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
        validated
            ? SizedBox()
            : SizedBox(
                height: 5.0,
              ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: validated
                ? null
                : Border.all(
                    style: BorderStyle.solid,
                    width: 2.5,
                    color: Colors.red,
                  ),
          ),
          child: Column(
            children: [
              buildSingleDateInput(
                context,
                true,
              ),
              Divider(
                height: 1.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              buildSingleDateInput(
                context,
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
