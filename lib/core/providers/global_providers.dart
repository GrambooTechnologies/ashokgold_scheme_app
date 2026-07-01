import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final refreshTokenProvider = StateProvider<String?>((ref) => null);
final accessTokenProvider = StateProvider<String?>((ref) => null);
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
