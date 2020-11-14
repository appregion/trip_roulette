import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_roulette/app/ui/widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String buttonText;

  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    @required this.buttonText,
  });

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => this,
    );
  }

  Widget buildActionButton(BuildContext context) {
    return FlatButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: Text(buttonText),
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        buildActionButton(context),
      ],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        buildActionButton(context),
      ],
    );
  }
}
