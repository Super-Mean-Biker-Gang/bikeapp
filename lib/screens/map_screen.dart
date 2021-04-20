import 'package:bikeapp/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  static const routeName = 'map_screen';

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
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 10, bottom: 5),
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Stack(
                  children: [
                    TextField(
                      style: TextStyle(fontSize: 25),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 25),
                        hintText: 'Search a location',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 55),
                      ),
                      cursorColor: Colors.blue,
                      cursorHeight: 30,
                    ),
                    Builder(
                        builder: (context) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print('Asks for location permissions');
                                  },
                                  tooltip: 'Find my device location',
                                  icon: Icon(Icons.location_pin,
                                      color: Colors.green, size: 40),
                                ),
                                Row(children: [
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Scaffold.of(context).openDrawer();
                                          },
                                          tooltip: 'Filter bikes',
                                          icon: Icon(Icons.filter_alt,
                                              color: Colors.blue, size: 40),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Scaffold.of(context)
                                                .openEndDrawer();
                                          },
                                          tooltip: 'Account Access',
                                          icon: Icon(
                                              Icons.account_circle_outlined,
                                              color: Colors.blue,
                                              size: 40),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ],
                            )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
          child: ListView(
        children: [
          Container(
            height: 100,
            child: DrawerHeader(
                child: Text('Quick Access', style: TextStyle(fontSize: 30))),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Account', style: TextStyle(fontSize: 20)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Bike', style: TextStyle(fontSize: 20)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out', style: TextStyle(fontSize: 20)),
            onTap: () {
              context.read<AuthenticationService>().signOut();
            },
          ),
        ],
      )),
      drawer: Drawer(
          child: ListView(
        children: [
          Container(
            height: 100,
            child: DrawerHeader(
                child: Text('Filter', style: TextStyle(fontSize: 30))),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Tags', style: TextStyle(fontSize: 20)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rating', style: TextStyle(fontSize: 20)),
            onTap: () {},
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Centers user on the map');
        },
        tooltip: 'Center map on Location',
        child: Icon(Icons.my_location),
      ),
    );
  }
}
