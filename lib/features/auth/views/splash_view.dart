import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/providers/global_providers.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/asset_constants.dart';
import 'package:ashokgold_scheme_app/core/utilities/shared_preference_constants.dart';
import 'package:ashokgold_scheme_app/features/auth/controllers/auth_controller.dart';
import 'package:ashokgold_scheme_app/features/home/views/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashView extends ConsumerStatefulWidget {
  static const String routeName = '/splash';
  const SplashView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      body: Center(child: SvgPicture.asset(AssetConstants.logoSvgw, width: 75)),
    );
  }

  Future<void> loadData() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final accessToken = prefs.getString(
        SharedPreferenceConstants.accessToken,
      );
      final refreshToken = prefs.getString(
        SharedPreferenceConstants.refreshToken,
      );

      if (!mounted) return;

      // Check if JWT token is available
      if (accessToken != null && refreshToken != null) {
        // Token available, set tokens and fetch user data
        ref.read(accessTokenProvider.notifier).update((state) {
          return accessToken;
        });

        ref.read(refreshTokenProvider.notifier).update((state) {
          return refreshToken;
        });

        ref.invalidate(dioProvider);

        // Fetch user data from /me endpoint
        await ref.read(authControllerProvider.notifier).getMe(context: context);
      } else {
        // No JWT token, navigate directly to home (guest mode)
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        context.go(BottomNav.routeName);
      }
    } catch (e) {
      if (!mounted) return;
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      // On error, go to home (guest mode)
      context.go(BottomNav.routeName);
    }
  }
}
