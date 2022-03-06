import 'package:fali_shop/auth/sign_up.dart';
import 'package:fali_shop/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHome extends StatelessWidget {
  AuthHome({this.user});
  final AppUser user;
  final String title = "Home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                      (Route<dynamic> route) => false);
                });
              },
            )
          ],
        ),
        body: Center(child: Text('Bienvenue!')),
        drawer: NavigateDrawer());
  }
}

class NavigateDrawer extends StatefulWidget {
  final AppUser user;
  NavigateDrawer({Key key, this.user}) : super(key: key);
  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.username) /*FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.user.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data() != null)
                      return Text(snapshot.data.data()['email']);
                    else
                      return Text(" Bonjour");
                  } else {
                    return CircularProgressIndicator();
                  }
                }),*/,
            accountName: Text(widget.user.email)
            /*FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.user.uid)
                    .get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data() != null)
                      return Text(snapshot.data.data()['name']);
                    else
                      return Text(" ");
                  } else {
                    return CircularProgressIndicator();
                  }
                })*/,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.home, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthHome(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
              icon: new Icon(Icons.settings, color: Colors.black),
              onPressed: () => null,
            ),
            title: Text('Settings'),
            onTap: () {
              print("${widget.user.userId}");
            },
          ),
        ],
      ),
    );
  }
}
