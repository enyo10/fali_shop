
import 'package:fali_shop/providers/data_provider.dart';
import 'package:fali_shop/theme/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigateDrawer extends StatefulWidget {

  NavigateDrawer({Key key,}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<DataProvider>(context, listen: false);
    var user = userProvider.user;

      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: user!=null? Text(" Bonjour ${user.username}"):Text("Bonjour"),

              accountName: user!=null?Text(user.email):Text(""),

            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.home,),
                onPressed: () => null,
              ),
              title: Text('Home'),
              onTap: () {
                /* var user = FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.uid)
                    .get();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthHome(user: user)),
                );*/
              },
            ),
            ListTile(
              leading: new IconButton(
                icon: new Icon(Icons.settings, ),
                  onPressed: () => currentTheme.toggleTheme(),
              ),
              title: Text('Settings'),
              onTap: () {

              },
            ),
          ],
        ),
    );
  }
}
