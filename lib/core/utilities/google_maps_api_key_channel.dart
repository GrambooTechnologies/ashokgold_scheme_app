import 'package:flutter/services.dart';

/// Utility for setting Google Maps API key at runtime via platform channel.
/// Use this for iOS (and Android if you implement a native handler).
class GoogleMapsApiKeyChannel {
  static const MethodChannel _channel = MethodChannel(
    'com.ashokgold_scheme_app/maps_api_key',
  );

  /// Sets the Google Maps API key at runtime.
  /// Call this after fetching the API key from backend and before showing any map.
  static Future<void> setApiKey(String apiKey) async {
    await _channel.invokeMethod('setApiKey', {'apiKey': apiKey});
  }
}
