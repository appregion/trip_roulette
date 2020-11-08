import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_roulette/app/resources/places.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesWidget extends StatelessWidget {
  final List<PlaceItem> items;

  PlacesWidget({@required this.items});

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Text(
          'Interesting Places',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        ListView.builder(
            padding: EdgeInsets.all(0.0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      child: Image.network(
                        items[index].photoUrl,
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      items[index].title,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(
                      CupertinoIcons.right_chevron,
                      color: Colors.white,
                    ),
                    onTap: () {
                      _launchURL(items[index].pageUrl);
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.grey,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              );
            })
      ],
    );
  }
}
