import 'package:flutter/material.dart';
import 'package:trip_roulette/app/ui/widgets/big_button.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({@required this.title, @required this.widgetList});
  String title;
  List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          Center(
            child: Container(
              width: 50.0,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 1.0,
          ),
          Column(
            children: widgetList,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: BigButton(
              onTap: () => Navigator.of(context).pop(),
              text: 'Done',
              color: Colors.blue,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
