import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fali_shop/providers/data_provider.dart';
import 'package:fali_shop/screens/components/sliver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:fali_shop/models/user.dart';

import '../main.dart';

class IntroScreen extends State<MyApp> {
  Future<Widget> loadFromFuture(DataProvider userProvider) async {
    User result = FirebaseAuth.instance.currentUser;

    if (result != null) {
      var value = await FirebaseFirestore.instance
          .collection("Users")
          .doc(result.uid)
          .get();
      var user = AppUser.fromMap(value.data(), result.uid);
      userProvider.setUser(user);
    }
    return Future.value(new MyHome());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
        builder: (BuildContext context, userProvider, Widget child) {
      return SplashScreen(
          navigateAfterFuture: loadFromFuture(userProvider),
          title: new Text(
            'Bienvenue dans l\'application de Fali!',
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          image: Image.asset('assets/images/fali_shop.png', fit: BoxFit.scaleDown),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          onClick: () => print("flutter"),
          loaderColor: Colors.red);
    });
  }
}
