import 'package:flutter/material.dart';
import 'package:trip_roulette/app/blocs/input_bloc.dart';
import 'package:trip_roulette/app/data/budget_type_data.dart';
import 'package:trip_roulette/app/models/budget_type_model.dart';
import 'package:trip_roulette/app/models/input_model.dart';
import 'package:trip_roulette/widgets/modal_bottom_sheet.dart';

class BudgetInputForm extends StatelessWidget {
  final InputBloc bloc;
  BudgetInputForm({this.bloc});
  final List<BudgetType> _budgetTypeList = budgetTypeList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.modelStream,
        initialData: InputModel(),
        builder: (context, snapshot) {
          return CustomBottomSheet(title: 'Your Budget', widgetList: [
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _budgetTypeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      bloc.updateWith(budgetType: index);
                    },
                    title: Text(
                      _budgetTypeList[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _budgetTypeList[index].subtitle,
                    ),
                    trailing: bloc.budgetTypeShowCheckMark(index)
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
