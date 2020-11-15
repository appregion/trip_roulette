import 'dart:convert';
import 'package:trip_roulette/app/resources/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Images {
  ApiKeys _apiKeys = ApiKeys();

  Future<ImageProvider> getImageFromGoogle({String locationName}) async {
    final String _apiKey = _apiKeys.googlePlacesApiKey;
    String _photoReference = '';

    // find place by location name
    String _findPlaceUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$locationName&inputtype=textquery&fields=photos,name,rating&key=$_apiKey';
    http.Response findPlaceResponse = await http.get(_findPlaceUrl);
    // check response status and return location
    String _findPlaceResponseStatus =
        jsonDecode(findPlaceResponse.body)['status'];
    if (_findPlaceResponseStatus == 'OK') {
      _photoReference = jsonDecode(findPlaceResponse.body)['candidates'][0]
          ['photos'][0]['photo_reference'];
      print('photo reference is $_photoReference');
      String _url =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=$_photoReference&key=$_apiKey';
      http.Response _imageResponse = await http.get(_url);

      ImageProvider image = Image.memory(_imageResponse.bodyBytes).image;

      return image;
    } else {
      return null;
    }
  }

  // Future<List<ImageItem>> getImages({String location}) async {
  //
  //   final String _apiKey = _apiKeys.flickrApiKey;
  //
  //   var flickrApi =
  //       'https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=$_apiKey&text=$location&format=json&nojsoncallback=1&privacy_filter=1&content_type=1&geo_context=2&per_page=30';
  //
  //   var wikiMediaUrl =
  //       'https://en.wikipedia.org/w/api.php?action=query&titles=$location&prop=images&format=json';
  //   http.Response imagesResponse = await http.get(wikiMediaUrl);
  //
  //   // List<dynamic> decodedDataFromFlickr =
  //   //     jsonDecode(imagesResponse.body)['photos']['photo'];
  //
  //   print(imagesResponse.body);
  //   Map<String, dynamic> decodedDataFromWiki =
  //       jsonDecode(imagesResponse.body)['query']['pages'];
  //
  //   List<dynamic> dataList = decodedDataFromWiki.values.toList();
  //
  //   print(decodedDataFromWiki);
  //   List<ImageItem> images =
  //       dataList.map((data) => ImageItem.fromJson(data)).toList();
  //   return [];
  // }

  // Future<List<ImageItem>> getImagesFromMediaWiki({String location}) async {
  //   var url =
  //       'https://en.wikipedia.org/w/api.php?action=query&titles=Barcelona&prop=images&imlimit=max&format=json';
  //   print(location);
  //   var searchUrl =
  //       'https://en.wikipedia.org/w/api.php?action=query&generator=search&gsrsearch=$location&exintro=&prop=extracts|images&imlimit=max&format=json';
  //   http.Response imagesResponse = await http.get(searchUrl);
  //   // print(imagesResponse.body);
  //   Map<String, dynamic> decodedDataFromWiki =
  //       jsonDecode(imagesResponse.body)['query']['pages'];
  //
  //   print(decodedDataFromWiki.keys);
  //
  //   List<dynamic> dataList = decodedDataFromWiki.values.toList();
  //   print(dataList[0]);
  //   List<ImageItem> images = [];
  //   for (var i = 0; i < dataList.length; i++) {
  //     print(dataList[i]['extract']);
  //     if ({dataList[i]['extract']}.toString().contains('city')) {
  //       print(dataList[i]['images']);
  //
  //       int imagesCount = dataList[i]['images'].length;
  //       for (var x = 0; x < imagesCount; x++) {
  //         images.add(ImageItem(
  //             imageUrl:
  //                 'https://en.wikipedia.org/wiki/en:Special:Filepath/${dataList[i]['images'][x]['title']}'));
  //         print(images[x].imageUrl);
  //       }
  //       break;
  //     } else {
  //       print('not found');
  //     }
  //   }
  //   images.removeWhere((element) =>
  //       element.imageUrl.contains('.pdf') ||
  //       element.imageUrl.contains('.svg') ||
  //       element.imageUrl.contains('.gif') ||
  //       element.imageUrl.contains('\'') ||
  //       element.imageUrl.contains('"'));
  //   return images;
  // }
}
