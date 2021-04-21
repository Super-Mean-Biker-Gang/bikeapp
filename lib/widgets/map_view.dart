import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bikeapp/widgets/map_search_bar.dart';

class MapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(top: queryData.size.height * .10),
              child: MapSearchBar()),
        ],
      ),
    );
  }
}
