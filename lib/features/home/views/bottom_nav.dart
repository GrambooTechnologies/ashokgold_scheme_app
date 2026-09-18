import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/auth/views/phone_number_view.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/views/customer_schemes_view.dart';
import 'package:ashokgold_scheme_app/features/home/views/home_view.dart';
import 'package:ashokgold_scheme_app/features/profile/views/profile_view.dart';
import 'package:ashokgold_scheme_app/features/schemes/views/schemes_list_view.dart';
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
    final customer = ref.watch(customerProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: null,

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
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
            color: Colors.black.withValues(alpha: 0.15),
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

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  NavigationDestination _destination(
    BuildContext context, {
    required double w,
    required double h,
    required String label,
    required IconData outlinedIcon,
  }) {
    return NavigationDestination(
      icon: Icon(outlinedIcon, size: w * (21 / 390)),
      selectedIcon: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * (10 / 390),
          vertical: h * (5 / 844),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.primaryColor,
              Palette.primaryColor.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(w * (14 / 390)),
          boxShadow: [
            BoxShadow(
              color: Palette.primaryColor.withValues(alpha: 0.28),
              blurRadius: w * (10 / 390),
              offset: Offset(0, h * (3 / 844)),
            ),
          ],
        ),
        child: Icon(outlinedIcon, size: w * (20 / 390), color: Colors.white),
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.fromLTRB(
        w * (12 / 390),
        h * (6 / 844),
        w * (12 / 390),
        h * (8 / 844),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(w * (24 / 390)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: w * (20 / 390),
            offset: Offset(0, h * (8 / 844)),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(w * (24 / 390)),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            height: h * (76 / 844),
            backgroundColor: Colors.white,
            indicatorColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: w * (11 / 390),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Palette.primaryColor : Colors.black54,
                letterSpacing: 0.1,
              );
            }),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              destinations: [
                _destination(
                  context,
                  w: w,
                  h: h,
                  label: 'Home',
                  outlinedIcon: CupertinoIcons.home,
                ),
                _destination(
                  context,
                  w: w,
                  h: h,
                  label: 'Schemes',
                  outlinedIcon: CupertinoIcons.rectangle_stack,
                ),
                _destination(
                  context,
                  w: w,
                  h: h,
                  label: 'My Schemes',
                  outlinedIcon: CupertinoIcons.list_bullet_below_rectangle,
                ),
                _destination(
                  context,
                  w: w,
                  h: h,
                  label: 'Profile',
                  outlinedIcon: CupertinoIcons.profile_circled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
