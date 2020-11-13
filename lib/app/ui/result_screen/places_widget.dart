import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_roulette/app/blocs/result_bloc.dart';
import 'package:trip_roulette/app/models/result_model.dart';

class PlacesWidget extends StatelessWidget {
  final ResultBloc bloc;
  PlacesWidget({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResultModel>(
        stream: bloc.resultModelStream,
        initialData: ResultModel(),
        builder: (context, snapshot) {
          ResultModel _model = snapshot.data;
          if (_model.placeItems != null) {
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
                    itemCount: _model.placeItems.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              child: Image.network(
                                _model.placeItems[index].photoUrl,
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              _model.placeItems[index].title,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(
                              CupertinoIcons.right_chevron,
                              color: Colors.white,
                            ),
                            onTap: () => bloc.openNearByPlace(
                                _model.placeItems[index].pageId),
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
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
