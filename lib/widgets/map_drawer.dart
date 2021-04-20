import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MapDrawer extends StatelessWidget {
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
              child: Text('Filter',
                  style: TextStyle(fontSize: queryData.textScaleFactor * 30)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Tags',
                style: TextStyle(fontSize: queryData.textScaleFactor * 20)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rating',
                style: TextStyle(fontSize: queryData.textScaleFactor * 20)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
