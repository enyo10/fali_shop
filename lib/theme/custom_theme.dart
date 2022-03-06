import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    //1
    return ThemeData.light().copyWith(
      primaryColor: CustomColors.purple,
      buttonColor: CustomColors.purple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomColors.purple,
        foregroundColor: Colors.white
    )


    );
    //(
    //2
    /* primaryColor: CustomColors.purple,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Montserrat',*/ //3
    /* buttonTheme: ButtonThemeData(
        // 4
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: CustomColors.lightPurple,
      ),*/
    //  );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: CustomColors.deepPurple,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomColors.deepPurple,
        foregroundColor: Colors.white
      )

    );
    /*(
      primaryColor: CustomColors.darkGrey,
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Montserrat',
      textTheme: ThemeData.dark().textTheme,

      */ /*buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: CustomColors.lightPurple,
      ),*/ /*
    );*/
  }
}
