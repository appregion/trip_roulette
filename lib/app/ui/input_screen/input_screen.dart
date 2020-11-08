import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_roulette/app/blocs/input_bloc.dart';
import 'package:trip_roulette/app/blocs/result_bloc.dart';
import 'package:trip_roulette/app/models/input_model.dart';
import 'package:trip_roulette/app/ui/input_screen/budget_input_form.dart';
import 'package:trip_roulette/app/ui/input_screen/location_type_input_form.dart';
import 'package:trip_roulette/app/ui/input_screen/people_input_form.dart';
import 'package:trip_roulette/app/ui/input_screen/select_date_input_form.dart';
import 'package:trip_roulette/app/ui/result_screen/result_screen.dart';
import 'package:trip_roulette/widgets/big_button.dart';
import 'package:trip_roulette/widgets/single_input.dart';

class InputScreen extends StatefulWidget {
  final InputBloc bloc;

  InputScreen({@required this.bloc});

  static Widget create(BuildContext context) {
    return Provider<InputBloc>(
      create: (context) => InputBloc(),
      child: Consumer<InputBloc>(
          builder: (context, bloc, _) => InputScreen(bloc: bloc)),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final double inputHeightInterval = 20.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.bloc.modelStream,
        initialData: InputModel(),
        builder: (context, snapshot) {
          final InputModel model = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Trip Roulette',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.0,
                      ),
                    ),
                    SizedBox(height: 45.0),
                    SingleInput(
                      leadingIcon: Icons.location_on,
                      text: widget.bloc.locationInputText(),
                      trailingWidget: model.gettingLocation
                          ? SizedBox(
                              height: 16.0,
                              width: 16.0,
                              child: CircularProgressIndicator(),
                            )
                          : Icon(
                              Icons.my_location,
                              color: Colors.grey,
                            ),
                      onTap: () async {
                        await widget.bloc.getCurrentPosition();
                      },
                      validated: widget.bloc.validateInputField(
                        inputField: model.location,
                        submitted: model.submitted,
                      ),
                    ),
                    SizedBox(
                      height: inputHeightInterval,
                    ),
                    SelectDateInputForm(
                      bloc: widget.bloc,
                      validated: widget.bloc.validateDateInput(
                        departureDate: model.departureDate,
                        returnDate: model.returnDate,
                        submitted: model.submitted,
                      ),
                    ),
                    SizedBox(
                      height: inputHeightInterval,
                    ),
                    SingleInput(
                      leadingIcon: Icons.people,
                      text: widget.bloc.peopleInputFormText(),
                      trailingIcon: Icons.arrow_drop_down,
                      onTap: _selectNumberOfPeople,
                      validated: widget.bloc.validateInputField(
                        inputField: model.numberOfAdults,
                        submitted: model.submitted,
                      ),
                    ),
                    SizedBox(
                      height: inputHeightInterval,
                    ),
                    SingleInput(
                      leadingIcon: Icons.map,
                      text: widget.bloc.destinationInputFormText(),
                      trailingIcon: Icons.arrow_drop_down,
                      onTap: _selectLocationType,
                      validated: widget.bloc.validateInputField(
                        inputField: model.destinationType,
                        submitted: model.submitted,
                      ),
                    ),
                    SizedBox(
                      height: inputHeightInterval,
                    ),
                    SingleInput(
                      leadingIcon: Icons.attach_money,
                      text: widget.bloc.budgetInputFormText(),
                      trailingIcon: Icons.arrow_drop_down,
                      onTap: _selectBudget,
                      validated: widget.bloc.validateInputField(
                        inputField: model.budgetType,
                        submitted: model.submitted,
                      ),
                    ),
                    SizedBox(
                      height: inputHeightInterval,
                    ),
                    BigButton(
                      onTap: _submit,
                      text: 'Search',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            )),
          );
        });
  }

  void showCustomModelBottomSheet(Widget widget) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return widget;
        });
  }

  void _submit() {
    bool submitValidated = widget.bloc.submit();
    if (submitValidated) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Provider<ResultBloc>(
          create: (context) {
            return ResultBloc(
              inputBloc: widget.bloc,
            );
          },
          child: Consumer<ResultBloc>(
              builder: (context, bloc, _) => ResultScreen(
                    bloc: bloc,
                  )),
          dispose: (context, bloc) => bloc.dispose(),
        );
      }));
    }
  }

  void _selectNumberOfPeople() {
    showCustomModelBottomSheet(NumberOfPeopleInputForm(bloc: widget.bloc));
  }

  void _selectLocationType() {
    showCustomModelBottomSheet(LocationTypeInputForm(bloc: widget.bloc));
  }

  void _selectBudget() {
    showCustomModelBottomSheet(BudgetInputForm(bloc: widget.bloc));
  }
}
