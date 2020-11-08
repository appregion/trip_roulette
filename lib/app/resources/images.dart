import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageItem {
  final String imageUrl;

  ImageItem({this.imageUrl});

  factory ImageItem.fromJson(Map<String, dynamic> data) {
    return ImageItem(

        //image from Flickr
        // imageUrl:
        //     'https://live.staticflickr.com/${data['server']}/${data['id']}_${data['secret']}_c.jpg',
        );
  }
}

class Images {
  Future<ImageProvider> getImageFromGoogle({String locationName}) async {
    String apiKey = 'AIzaSyAYvxvPsW0RT8XHy8nTUOj2C6KIvlR0g68';
    String photoReference = '';

    // find place by location name
    String findPlaceUrl =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$locationName&inputtype=textquery&fields=photos,name,rating&key=$apiKey';
    http.Response findPlaceResponse = await http.get(findPlaceUrl);
    // check response status and return location
    String findPlaceResponseStatus =
        jsonDecode(findPlaceResponse.body)['status'];
    if (findPlaceResponseStatus == 'OK') {
      photoReference = jsonDecode(findPlaceResponse.body)['candidates'][0]
          ['photos'][0]['photo_reference'];
      print('photo reference is $photoReference');
      String url =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=1000&photoreference=$photoReference&key=$apiKey';
      http.Response imageResponce = await http.get(url);

      ImageProvider image = Image.memory(imageResponce.bodyBytes).image;

      return image;
    } else {
      return null;
    }
  }

  // Future<List<ImageItem>> getImages({String location}) async {
  //   String key = '260c8fe4eeb8fd6a04a6c8c80e175d25';
  //
  //   var flickrApi =
  //       'https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=$key&text=$location&format=json&nojsoncallback=1&privacy_filter=1&content_type=1&geo_context=2&per_page=30';
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
