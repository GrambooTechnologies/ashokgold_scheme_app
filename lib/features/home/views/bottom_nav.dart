import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/auth/views/phone_number_view.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/views/customer_schemes_view.dart';
import 'package:ashokgold_scheme_app/features/home/views/home_view.dart';
import 'package:ashokgold_scheme_app/features/profile/views/profile_view.dart';
import 'package:ashokgold_scheme_app/features/schemes/views/schemes_list_view.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utilities/scale_size_utils.dart';
import '../providers/bottom_nav_mixin.dart';

class BottomNav extends ConsumerStatefulWidget {
  static const String routeName = '/bottom-nav';

  const BottomNav({super.key});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav>
    with BottomNavShortcutMixin {
  final List<Widget> _pages = [
    const HomeView(),
    const SchemesListView(),
    CustomerSchemesView(),
    const ProfileView(),
  ];

  int _currentIndex = 0;

  @override
  void navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final customer = ref.watch(customerProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: null,

      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Palette.primaryColor,
        backgroundColor: Palette.backgroundColor,
        color: Palette.whiteColor,
        index: _currentIndex,
        items: <Widget>[
          Icon(
            CupertinoIcons.home,
            size: w * 0.06,
            color: _currentIndex == 0
                ? Palette.whiteColor
                : Palette.primaryColor,
          ),
          Icon(
            CupertinoIcons.rectangle_stack,
            size: w * 0.06,
            color: _currentIndex == 1
                ? Palette.whiteColor
                : Palette.primaryColor,
          ),
          Icon(
            CupertinoIcons.list_bullet_below_rectangle,
            size: w * 0.06,
            color: _currentIndex == 2
                ? Palette.whiteColor
                : Palette.primaryColor,
          ),
          Icon(
            CupertinoIcons.profile_circled,
            size: w * 0.06,
            color: _currentIndex == 3
                ? Palette.whiteColor
                : Palette.primaryColor,
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      // ✅ Stack for Floating Guest Banner
      body: Stack(
        children: [
          // Main Page
          _pages[_currentIndex],

          // Guest Login Banner
          if (customer == null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16, // Above bottom nav
              child: _guestLoginBanner(context),
            ),
        ],
      ),
    );
  }

  // ✅ Floating Guest Container
  Widget _guestLoginBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Palette.primaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Palette.whiteColor),

          const SizedBox(width: 5),

          // Text
          SizedBox(
            width: SizeConfig.w(context, 200),
            child: Text(
              'You are in Guest Mode. Please login to continue.',
              style: TextStyle(
                height: 1.1,
                color: Palette.whiteColor,
                fontSize: SizeConfig.w(context, 13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          // Login Button
          TextButton(
            onPressed: () {
              context.push(PhoneNumberView.routeName);
            },
            style: TextButton.styleFrom(foregroundColor: Palette.whiteColor),
            child: const Text(
              'LOGIN',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
