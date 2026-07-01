import 'package:flutter/material.dart';

mixin BottomNavShortcutMixin<T extends StatefulWidget> on State<T> {
  void navigateTo(int index);
}