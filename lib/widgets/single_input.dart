import 'package:flutter/material.dart';

class SingleInput extends StatelessWidget {
  SingleInput({
    @required this.leadingIcon,
    @required this.text,
    this.trailingIcon,
    this.trailingWidget,
    @required this.onTap,
  });

  String text;
  IconData leadingIcon;
  IconData trailingIcon;
  Widget trailingWidget;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      leadingIcon,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              trailingWidget != null
                  ? trailingWidget
                  : Icon(
                      trailingIcon,
                      color: Colors.grey,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
