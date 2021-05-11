import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bikeapp/models/responsive_size.dart';

class MapSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 5),
      margin: EdgeInsets.only(
          left: queryData.size.width * .05, right: queryData.size.width * .05),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.cyanAccent, width: responsiveHeight(1.0)),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Stack(
        children: [
          TextField(
            style: TextStyle(fontSize: queryData.textScaleFactor * 30),
            textInputAction: TextInputAction.search,
            cursorColor: Colors.blue,
            cursorHeight: queryData.textScaleFactor * 40,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: queryData.textScaleFactor * 25),
              hintText: 'Search a location',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 45, right: 85),
            ),
            onTap: () async {
              print('Creating suggestions bar');
            },
            onSubmitted: (String str) {
              print('submitting results');
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  print('Asks for location permissions');
                },
                tooltip: 'Find my device location',
                icon: Icon(Icons.location_pin,
                    color: Colors.green, size: queryData.textScaleFactor * 40),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: 'Filter bikes',
                    icon: Icon(Icons.filter_alt,
                        color: Colors.purpleAccent,
                        size: queryData.textScaleFactor * 40),
                  ),
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    tooltip: 'Account Access',
                    icon: Icon(Icons.account_circle_outlined,
                        color: Colors.blue,
                        size: queryData.textScaleFactor * 40),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
