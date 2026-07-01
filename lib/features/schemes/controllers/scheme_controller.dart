import 'package:flutter_riverpod/flutter_riverpod.dart';

final schemeControllerProvider = NotifierProvider<SchemeController, bool>(
  () => SchemeController(),
);

class SchemeController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }
}
