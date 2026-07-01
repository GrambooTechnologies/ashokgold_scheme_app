import 'package:flutter/material.dart';

class Palette {
  static const TextStyle customTextStyle = TextStyle(
    fontFamily: 'Urbanist',
    fontWeight: FontWeight.w500,
    color: blackColor,
  );
  static const Color cardBackgroundColor = Color(0xFF004082);

  // static const primaryColor = Color(0xFF231852);
  // static const primaryColor = Color.fromARGB(255, 122, 94, 7);
  // static const backgroundColor = Color(0xFFF6F6F6);
  static const backgroundColor = Color(0xFFF6F6F6);
  static const primaryColor = Color(0xFF3F3833);
  static const secondaryColor = Color(0xFF1B1913);
  static const lightColor = Color(0xFFE9E3DA);
  static const whiteColor = Colors.white;
  static const blackColor = Colors.black;
  static const redColor = Colors.red;

  static const buttonTextColor = Color.fromRGBO(231, 236, 239, 1.0);
  static const hintTextColor = Color.fromRGBO(139, 140, 137, 1.0);
  static const snackBarErrorColor = Colors.red;
  static const snackBarSuccessColor = Colors.green;
  static const shadowColor = Colors.black;
  static const cardColor = Color(0xFFFFFFFF);

  static const buttonColor = Color(0xFF2231D2);

  static final ThemeData lightTheme = ThemeData.light(useMaterial3: true)
      .copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          titleTextStyle: TextStyle(
            color: blackColor,
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(color: blackColor, size: 30),
        ),
        iconTheme: const IconThemeData(size: 30, color: blackColor),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(blackColor),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(primaryColor),
            foregroundColor: WidgetStatePropertyAll(buttonTextColor),
            fixedSize: WidgetStatePropertyAll(Size(100, 50)),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: customTextStyle,
          bodyMedium: customTextStyle,
          bodySmall: customTextStyle,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: hintTextColor, fontFamily: 'Urbanist'),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: snackBarSuccessColor,
          contentTextStyle: TextStyle(color: whiteColor),
        ),
        cardColor: cardBackgroundColor,
      );

  static final ThemeData darkTheme = ThemeData.dark(useMaterial3: true)
      .copyWith(
        scaffoldBackgroundColor: const Color(0xFF18122B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF18122B),
          titleTextStyle: TextStyle(
            color: whiteColor,
            fontSize: 20,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(color: whiteColor, size: 30),
        ),
        iconTheme: const IconThemeData(size: 30, color: whiteColor),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(whiteColor),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            backgroundColor: WidgetStatePropertyAll(primaryColor),
            foregroundColor: WidgetStatePropertyAll(buttonTextColor),
            fixedSize: WidgetStatePropertyAll(Size(100, 50)),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: hintTextColor, fontFamily: 'Urbanist'),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: snackBarSuccessColor,
          contentTextStyle: TextStyle(color: whiteColor),
        ),
        cardColor: cardBackgroundColor,
      );
}
