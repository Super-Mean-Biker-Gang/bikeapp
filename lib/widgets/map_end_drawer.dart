import 'package:bikeapp/screens/add_bike_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class MapEndDrawer extends StatelessWidget {
  // connect routing function with account screen
  void pushAccountScreen(BuildContext context) {
    Navigator.of(context).pushNamed('TBD_accountScreen');
  }

  // connect routing function with bike form screen
  void pushAddBikeForm(BuildContext context) {
    Navigator.of(context).pushNamed('TBD_bikeForm');
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: queryData.size.height * .20,
            child: DrawerHeader(
              child: Text('Quick Access',
                style: TextStyle(fontSize: queryData.textScaleFactor * 30),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Bike',
                style: TextStyle(fontSize: queryData.textScaleFactor * 20)),
            onTap: () {
              Navigator.pushNamed(context, AddBikeScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out',
                style: TextStyle(fontSize: queryData.textScaleFactor * 20)),
            onTap: () {
              context.read<AuthenticationService>().signOut();
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
          ),
        ],
      ),
    );
  }
}
