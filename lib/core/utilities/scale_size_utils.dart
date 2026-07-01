import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidth;
  static late double scaleHeight;

  static const double designWidth = 411;
  static const double designHeight = 914;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;

    scaleWidth = screenWidth / designWidth;
    scaleHeight = screenHeight / designHeight;
  }

  static double w(BuildContext context, double width) {
    init(context);
    return width * scaleWidth;
  }

  static double h(BuildContext context, double height) {
    init(context);
    return height * scaleHeight;
  }

  static double sp(BuildContext context, double fontSize) {
    return w(context, fontSize);
  }
}
