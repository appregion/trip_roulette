import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trip_roulette/app/models/place_item.dart';

class Places {
  Future<List<PlaceItem>> getPlacesNearBy(
      {double latitude, double longitude}) async {
    String _url =
        'https://en.wikipedia.org/w/api.php?action=query&generator=geosearch&prop=coordinates|pageimages&ggscoord=$latitude|$longitude&ggsradius=10000&ggslimit=25&format=json';

    http.Response _response = await http.get(_url);

    if (_response.statusCode == 200) {
      Map<String, dynamic> _placesMap =
          jsonDecode(_response.body)['query']['pages'];

      List<PlaceItem> _items = [];

      List<dynamic> _decodedPlacesList = _placesMap.values.toList();

      for (var i = 0; i < _decodedPlacesList.length; i++) {
        _items.add(PlaceItem(
          title: _decodedPlacesList[i]['title'],
          pageId: _decodedPlacesList[i]['pageid'],
          photoUrl: _decodedPlacesList[i]['pageimage'] != null
              ? 'https://en.wikipedia.org/wiki/en:Special:Filepath/${_decodedPlacesList[i]['pageimage']}'
              : 'https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png',
        ));
      }
      _items.removeWhere((element) =>
          element.photoUrl.contains('.pdf') ||
          element.photoUrl.contains('.svg') ||
          element.photoUrl.contains('.gif') ||
          element.photoUrl.contains('\'') ||
          element.photoUrl.contains('"'));
      print('We found ${_items.length} places near by');
      return _items;
    }

    return null;
  }

  Future<String> getPageUrlById(int pageId) async {
    String _url =
        'https://en.wikipedia.org/w/api.php?action=query&prop=info&pageids=$pageId&inprop=url&format=json';
    http.Response _response = await http.get(_url);
    if (_response.statusCode == 200) {
      String pageUrl =
          jsonDecode(_response.body)['query']['pages']['$pageId']['fullurl'];
      return pageUrl;
    }
    return null;
  }
}
