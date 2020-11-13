import 'package:flutter/material.dart';

class SingleInput extends StatelessWidget {
  SingleInput({
    @required this.leadingIcon,
    @required this.text,
    this.trailingIcon,
    this.trailingWidget,
    @required this.onTap,
    @required this.validated,
  });

  final String text;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final Widget trailingWidget;
  final Function onTap;
  final bool validated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
            height: 60.0,
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
        ],
      ),
    );
  }
}
