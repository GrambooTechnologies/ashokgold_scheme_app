import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/asset_constants.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/home/providers/banner_provider.dart';
import 'package:ashokgold_scheme_app/features/home/widgets/gold_rate_card.dart';

import 'package:ashokgold_scheme_app/features/profile/views/social_media_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ashokgold_scheme_app/features/settings/views/privacy_policy_view.dart';

import '../../../core/utilities/scale_size_utils.dart';
import '../providers/bottom_nav_mixin.dart';

class HomeView extends ConsumerStatefulWidget {
  static const String routeName = '/home';

  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final customer = ref.watch(customerProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(color: Palette.whiteColor, width: w, height: h * 0.05),
          SizedBox(
            height: h * 0.24,
            width: w,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Palette.primaryColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(w * 0.05),
                    ),
                  ),
                  height: h * 0.2,
                  width: w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.08,
                      vertical: h * 0.06,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello,',
                                style: TextStyle(
                                  fontSize: w * .036,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Urbanist',
                                  color: Palette.whiteColor,
                                ),
                              ),
                              Text(
                                customer?.fullName ?? "Please Login...",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: w * .046,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Urbanist',
                                  color: Palette.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: w * 0.06,
                          backgroundImage: const AssetImage(
                            AssetConstants.staticProfile,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const GoldRateCard(),
              ],
            ),
          ),
          SizedBox(height: h * 0.02),

          // ── Shortcut Navigation Widgets ──────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.055),
            child: Row(
              children: [
                Expanded(
                  child: _ShortcutCard(
                    icon: Icons.layers_rounded,
                    title: 'Explore Schemes',
                    onTap: () {
                      // Navigate to second tab (index 1 — SchemesListView)
                      final bottomNav = context
                          .findAncestorStateOfType<BottomNavShortcutMixin>();
                      bottomNav?.navigateTo(1);
                    },
                  ),
                ),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: _ShortcutCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'My Schemes',
                    onTap: () {
                      // Navigate to third tab (index 2 — CustomerSchemesView)
                      final bottomNav = context
                          .findAncestorStateOfType<BottomNavShortcutMixin>();
                      bottomNav?.navigateTo(2);
                    },
                  ),
                ),
              ],
            ),
          ),

          // ────────────────────────────────────────────────────────────────
          SizedBox(height: h * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest Offers',
                  style: TextStyle(
                    fontSize: w * .036,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                    color: Palette.blackColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: w * .033,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Urbanist',
                      color: Palette.blackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.01),
          _BannerSection(h: h, w: w),
          SizedBox(height: SizeConfig.w(context, 31)),
          Text(
            "Follow us to get daily updates",
            style: TextStyle(
              fontSize: SizeConfig.w(context, 15),
              color: Colors.black,
              height: 1.5,
            ),
          ),
          SizedBox(height: SizeConfig.h(context, 10)),
          GestureDetector(
            onTap: () {
              context.push(SocialMediaView.routeName);
            },
            child: Image.asset(
              AssetConstants.socialMedia,
              height: SizeConfig.h(context, 24),
            ),
          ),
          SizedBox(height: SizeConfig.h(context, 18)),
          GestureDetector(
            onTap: () {
              context.push(PrivacyPolicyView.routeName);
            },
            child: Text(
              "About Ananswara  .  Terms & Conditions  .  Privacy Policy",
              style: TextStyle(
                fontSize: SizeConfig.w(context, 11),
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: h * 0.02),
        ],
      ),
    );
  }
}

// ── Shortcut Card Widget ─────────────────────────────────────────────────────

class _ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: h * 0.018,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
              spreadRadius: -2,
              offset: Offset(-1, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Palette.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Palette.primaryColor, size: w * 0.05),
            ),
            SizedBox(width: w * 0.02),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                style: TextStyle(
                  height: 1.2,
                  fontSize: w * 0.032,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Urbanist',
                  color: Palette.blackColor,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Palette.primaryColor.withOpacity(0.02),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: Palette.primaryColor,
                size: w * 0.045,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

mixin _BottomNavShortcutMixin on State {
  void navigateTo(int index);
}

// ── Remaining widgets (unchanged) ────────────────────────────────────────────

class _BannerSection extends ConsumerWidget {
  final double h;
  final double w;

  const _BannerSection({required this.h, required this.w});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) {
          return _NoBannersPlaceholder(h: h, w: w);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: banners.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.015),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: banners[index].bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.grey[300]),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return _BannerErrorPlaceholder(h: h, w: w);
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () {
        return _BannerShimmerLoader(h: h, w: w);
      },
      error: (error, stackTrace) {
        return _NoBannersPlaceholder(h: h, w: w);
      },
    );
  }
}

class _BannerShimmerLoader extends StatelessWidget {
  final double h;
  final double w;

  const _BannerShimmerLoader({required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.015),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(color: Colors.grey[300], height: h * 0.12),
            ),
          ),
        );
      },
    );
  }
}

class _NoBannersPlaceholder extends StatelessWidget {
  final double h;
  final double w;

  const _NoBannersPlaceholder({required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(w * 0.05, 0, w * 0.05, h * 0.015),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: h * 0.12,
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 32,
                  color: Colors.grey[400],
                ),
                SizedBox(height: h * 0.01),
                Text(
                  'No Banners Available',
                  style: TextStyle(
                    fontSize: w * 0.036,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerErrorPlaceholder extends StatelessWidget {
  final double h;
  final double w;

  const _BannerErrorPlaceholder({required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h * 0.12,
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.broken_image, size: 32, color: Colors.grey[400]),
      ),
    );
  }
}
