import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceItem {
  final int pageId;
  final String pageUrl;
  final String photoUrl;
  final String title;

  PlaceItem({this.pageId, this.pageUrl, this.photoUrl, this.title});
}

class Places {
  Future<List<PlaceItem>> getPlacesNearBy(
      {double latitude, double longitude}) async {
    var url =
        'https://en.wikipedia.org/w/api.php?action=query&generator=geosearch&prop=coordinates|pageimages&ggscoord=$latitude|$longitude&ggsradius=10000&ggslimit=50&format=json';

    http.Response response = await http.get(url);

    Map<String, dynamic> placesMap =
        jsonDecode(response.body)['query']['pages'];

    List<PlaceItem> items = [];

    List<dynamic> decodedPlacesList = placesMap.values.toList();

    for (var i = 0; i < decodedPlacesList.length; i++) {
      String pageUrl = await getPageUrlById(decodedPlacesList[i]['pageid']);
      items.add(PlaceItem(
        title: decodedPlacesList[i]['title'],
        pageId: decodedPlacesList[i]['pageid'],
        photoUrl: decodedPlacesList[i]['pageimage'] != null
            ? 'https://en.wikipedia.org/wiki/en:Special:Filepath/${decodedPlacesList[i]['pageimage']}'
            : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png',
        pageUrl: pageUrl,
      ));
      print(items[i].pageId);
      print(items[i].title);
      print(items[i].photoUrl);
      print(items[i].pageUrl);
    }
    items.removeWhere((element) =>
        element.photoUrl.contains('.pdf') ||
        element.photoUrl.contains('.svg') ||
        element.photoUrl.contains('.gif') ||
        element.photoUrl.contains('\'') ||
        element.photoUrl.contains('"'));
    return items;
  }

  Future<String> getPageUrlById(int pageId) async {
    var url =
        'https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=$pageId&inprop=url&format=json';
    http.Response response = await http.get(url);
    String pageUrl =
        jsonDecode(response.body)['query']['pages']['$pageId']['fullurl'];
    return pageUrl;
  }
}
