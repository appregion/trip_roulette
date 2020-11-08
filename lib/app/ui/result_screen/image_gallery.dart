import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trip_roulette/app/resources/images.dart';

class ImageGalleryWidget extends StatelessWidget {
  final List<ImageItem> images;

  ImageGalleryWidget({this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider.builder(
        itemCount: images.length,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.60,
          viewportFraction: 1.0,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
        ),
        itemBuilder: (context, index) {
          return Container(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
                child: Image.network(
                  images[index].imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
