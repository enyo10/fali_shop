import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import 'email_login.dart';
import 'email_sign_up.dart';

class SignUp extends StatelessWidget {
  final String title = " S'inscrire";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Fali App",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: 'Roboto')),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Email,
                  text: "S'enrégistrer avec Email",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmailSignUp()),
                    );
                  },
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Google,
                  text: "S'enregistrer avec Google",
                  onPressed: () {},
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: SignInButton(
                  Buttons.Twitter,
                  text: "S'enregister avec Twitter",
                  onPressed: () {},
                )),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: GestureDetector(
                    child: Text("Se connecter par Email",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailLogIn()),
                      );
                    }))
          ]),
        ));
  }
}
