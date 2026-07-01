import 'package:ashokgold_scheme_app/core/providers/global_providers.dart';
import 'package:ashokgold_scheme_app/core/routes/router.dart';
import 'package:ashokgold_scheme_app/core/services/notification_service.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background/terminated message handler before any other Firebase call.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize foreground notifications & request permissions.
  await NotificationService.instance.initialize();

  final sharedPreferences = await SharedPreferences.getInstance();
  // NOTE: Do NOT call Upgrader.clearSavedSettings() in production.
  // It resets the "already prompted" state on every launch, causing the
  // update dialog to appear every time regardless of durationUntilAlertAgain.

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Anaswara Scheme App',
      debugShowCheckedModeBanner: false,
      theme: Palette.lightTheme,
      darkTheme: Palette.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return UpgradeAlert(
          upgrader: Upgrader(
            // In release builds, debug flags are OFF so the dialog only appears
            // when Play Store actually reports a newer version.
            debugLogging: false,
            debugDisplayAlways: false,

            // Uncomment and set the minimum required version when you publish
            // a mandatory update. Users on older versions will not see "Later".
            // minAppVersion: '1.0.1',

            // Re-prompt the user once a day if they dismissed the dialog.
            durationUntilAlertAgain: const Duration(days: 1),
          ),
          dialogStyle: UpgradeDialogStyle.material,
          // Hide "Ignore" so users cannot permanently skip an update.
          showIgnore: false,
          // Allow "Later" (users can postpone until tomorrow).
          showLater: true,
          // Prevent dismissing the dialog by tapping outside.
          barrierDismissible: false,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
