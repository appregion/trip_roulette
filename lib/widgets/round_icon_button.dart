import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    @required this.icon,
    @required this.enabledColor,
    @required this.disabledColor,
    @required this.onTap,
    @required this.isEnabled,
  });
  IconData icon;
  Color enabledColor;
  Color disabledColor;
  Function onTap;
  bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.0,
        width: 36.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: isEnabled ? enabledColor : disabledColor,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}
