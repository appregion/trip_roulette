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
