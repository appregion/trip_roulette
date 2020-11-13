import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trip_roulette/app/blocs/result_bloc.dart';
import 'package:trip_roulette/app/models/result_model.dart';
import 'package:trip_roulette/app/ui/result_screen/flight_info_widget.dart';
import 'package:trip_roulette/app/ui/result_screen/image_gallery.dart';
import 'package:trip_roulette/app/ui/result_screen/places_widget.dart';
import 'package:trip_roulette/app/ui/result_screen/weather_widget.dart';
import 'package:trip_roulette/app/ui/widgets/outlined_icon_button.dart';

class ResultScreen extends StatefulWidget {
  final ResultBloc bloc;

  ResultScreen({
    @required this.bloc,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await widget.bloc.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.bloc.resultModelStream,
        initialData: ResultModel(),
        builder: (context, snapshot) {
          final ResultModel model = snapshot.data;
          if (model.loadingResult) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 45, left: 10.0, right: 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedIconButton(
                              icon: CupertinoIcons.arrow_left,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            OutlinedIconButton(
                              icon: CupertinoIcons.share,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        // ImageGalleryWidget(
                        //   images: model.images,
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          child: Image.network(
                            'https://www.telegraph.co.uk/content/dam/Travel/Destinations/Asia/Thailand/Phuket/phuket-thailand-beach-boat-lead-main-guide.jpg?imwidth=1400',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.6,
                          ),
                        ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.all(
                        //     Radius.circular(15.0),
                        //   ),
                        //   child: Image(
                        //     image: model.image,
                        //     fit: BoxFit.cover,
                        //     height: MediaQuery.of(context).size.height * 0.6,
                        //   ),
                        // ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          model.destinationName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FlightInfoWidget(
                          model: model,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        WeatherWidget(
                          weatherItems: model.weatherItems,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        PlacesWidget(
                          bloc: widget.bloc,
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
