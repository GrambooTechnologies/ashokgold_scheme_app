import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/home/widgets/gold_rate_card.dart';
import 'package:ashokgold_scheme_app/features/home/providers/bottom_nav_mixin.dart';
import 'dart:async';
import 'package:ashokgold_scheme_app/features/home/models/banner_model.dart';
import 'package:ashokgold_scheme_app/features/home/providers/banner_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/asset_constants.dart';
import 'package:ashokgold_scheme_app/features/notifications/views/notification_inbox_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ashokgold_scheme_app/features/profile/views/social_media_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ashokgold_scheme_app/features/settings/views/privacy_policy_view.dart';

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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(color: Palette.whiteColor, width: w, height: h * 0.05),
          SizedBox(
            width: w,
            child: Padding(
              padding: EdgeInsets.fromLTRB(w * 0.08, h * 0.03, w * 0.08, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: w * 0.2,
                    child: Image.asset("assets/images/Vector.png"),
                  ),

                  GestureDetector(
                    onTap: () => context.push(NotificationInboxView.routeName),

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Palette.primaryColor.withOpacity(0.15),
                          width: 0.7,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(CupertinoIcons.bell, size: w * 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: h * 0.024),
          // _InstagramHighlightsSection(h: h, w: w),
          const GoldRateCard(),
          _BannerSection(h: h, w: w),
          SizedBox(height: h * 0.02),
          _ShortcutSection(h: h, w: w),
          SizedBox(height: h * 0.025),
          _BenefitsAndRedemptionSection(h: h, w: w),

          // Footer Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Divider(color: Colors.grey.withOpacity(0.12), thickness: 1),
          ),
          SizedBox(height: h * 0.02),
          Container(
            width: w,
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                Text(
                  "FOLLOW US FOR DAILY UPDATES",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.w700,
                    color: Palette.blackColor.withOpacity(0.5),
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: h * 0.012),
                GestureDetector(
                  onTap: () {
                    context.push(SocialMediaView.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Palette.lightColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.15),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AssetConstants.socialMedia,
                          height: w * 0.045,
                        ),
                        SizedBox(width: w * 0.02),
                        Text(
                          "Social Media Channels",
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: w * 0.03,
                            fontWeight: FontWeight.w600,
                            color: Palette.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.025),
                GestureDetector(
                  onTap: () {
                    context.push(PrivacyPolicyView.routeName);
                  },
                  child: Text(
                    "About Ashok Gold  •  Terms & Conditions  •  Privacy Policy",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.02),
        ],
      ),
    );
  }
}

// ── Remaining widgets (added back for carousel) ────────────────────────────────────────────

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

        return _BannerCarousel(banners: banners, h: h, w: w);
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

class _BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  final double h;
  final double w;

  const _BannerCarousel({
    required this.banners,
    required this.h,
    required this.w,
  });

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0, initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && widget.banners.isNotEmpty) {
        int nextPage = _currentPage + 1;
        if (nextPage >= widget.banners.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.w,
          height: widget.w,
          child: PageView.builder(
            controller: _pageController,
            // itemCount: widget.banners.length,
            itemCount: 1,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.hasContentDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - value.abs()).clamp(0.0, 1.0);
                  } else {
                    value = index == 0 ? 1.0 : 0.0;
                  }
                  return Opacity(
                    opacity: Curves.easeOut.transform(value),
                    child: child,
                  );
                },
                child: SizedBox(
                  width: widget.w,
                  height: widget.w,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://i.pinimg.com/1200x/92/31/2b/92312b20aa966d039dff961990e75084.jpg',
                    // imageUrl: widget.banners[index].bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.grey[300]),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return _BannerErrorPlaceholder(h: widget.h, w: widget.w);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: widget.h * 0.01),
        // Minimalist dot indicator below the image
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 16.0 : 4.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Palette.primaryColor
                    : Palette.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerShimmerLoader extends StatelessWidget {
  final double h;
  final double w;

  const _BannerShimmerLoader({required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.grey[300], width: w, height: h * 0.22),
    );
  }
}

class _NoBannersPlaceholder extends StatelessWidget {
  final double h;
  final double w;

  const _NoBannersPlaceholder({required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h * 0.22,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 32, color: Colors.grey[400]),
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
      width: w,
      height: h * 0.22,
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.broken_image, size: 32, color: Colors.grey[400]),
      ),
    );
  }
}

// ── Benefits and Redemption Section ──────────────────────────────────────────

class _BenefitsAndRedemptionSection extends StatelessWidget {
  final double h;
  final double w;

  const _BenefitsAndRedemptionSection({required this.h, required this.w});

  Widget _goldGradientShader(Widget child) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFFFAEC), Color(0xFFFCDD24), Color(0xFFE67E22)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: child,
    );
  }

  Widget _buildBenefitItem({
    required Widget iconWidget,
    required String text,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _goldGradientShader(iconWidget),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFDFBF7),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = w * 0.42;

    return Column(
      children: [
        // 1. Golden Brown Benefits Section
        Container(
          width: w,
          decoration: const BoxDecoration(
            color: Color(0xFF9E723B), // base warm gold/brown
            image: DecorationImage(
              image: AssetImage(AssetConstants.goldBg),
              fit: BoxFit.cover,
              opacity: 0.12, // subtle mandala pattern overlay
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: h * 0.04,
            horizontal: w * 0.05,
          ),
          child: Column(
            children: [
              Text(
                'Benefits of Gold\nTree Plans',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: w * 0.075,
                  height: 1.15,
                  color: const Color(0xFFFFDF7A), // golden color
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: h * 0.05),
              // Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBenefitItem(
                    iconWidget: SizedBox(
                      width: 44,
                      height: 44,
                      child: CustomPaint(painter: _PendantDisplayPainter()),
                    ),
                    text: 'Own your dream jewellery\nat the best value',
                    width: itemWidth,
                  ),
                  _buildBenefitItem(
                    iconWidget: SizedBox(
                      width: 44,
                      height: 44,
                      child: CustomPaint(painter: _ChecklistPainter()),
                    ),
                    text: 'Easy monthly advance\nplans',
                    width: itemWidth,
                  ),
                ],
              ),
              SizedBox(height: h * 0.05),
              // Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBenefitItem(
                    iconWidget: SizedBox(
                      width: 44,
                      height: 44,
                      child: CustomPaint(
                        painter: _NecklacePainter(isElaborate: false),
                      ),
                    ),
                    text: 'Redeem at your\nconvenience: In-store',
                    width: itemWidth,
                  ),
                  _buildBenefitItem(
                    iconWidget: SizedBox(
                      width: 44,
                      height: 44,
                      child: CustomPaint(painter: _GoldCoinPainter()),
                    ),
                    text: 'Enjoy gold rate & other\nexclusive benefits',
                    width: itemWidth,
                  ),
                ],
              ),
              SizedBox(height: h * 0.05),
              // Row 3 (Centered)
              Center(
                child: _buildBenefitItem(
                  iconWidget: SizedBox(
                    width: 48,
                    height: 40,
                    child: CustomPaint(painter: _GoldBarsPainter()),
                  ),
                  text:
                      'Attractive Gold, Diamond &\nSilver redemption benefits',
                  width: w * 0.65,
                ),
              ),
            ],
          ),
        ),

        // 2. Cream/Off-white Redemption Section
        Container(
          width: w,
          color: Palette.backgroundColor, // soft cream background
          padding: EdgeInsets.symmetric(
            vertical: h * 0.04,
            horizontal: w * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Redeem your accumulated gold, in a blink!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF3F3833),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Turn your accumulated gold into stunning jewellery at\nyour nearest Bhima store',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: w * 0.031,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3F3833).withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(height: h * 0.03),
              // Cards Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildStepCard(
                      stepNumber: "1",
                      illustration: _goldGradientShader(
                        SizedBox(
                          width: 55,
                          height: 45,
                          child: CustomPaint(
                            painter: _NecklacePainter(isElaborate: true),
                          ),
                        ),
                      ),
                      text:
                          "Choose your favourite\njewellery from Bhima\nJewels",
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: _buildStepCard(
                      stepNumber: "2",
                      illustration: _buildCreditCardIllustration(),
                      text: "Show your GT card at\ncheckout in-store",
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.04),
              // Conditions
              Text(
                'Conditions:',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: w * 0.034,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3F3833),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              _buildConditionPoint('Redemption starts after 180 days*'),
              _buildConditionPoint(
                '*For 100% benefits, redemption starts after 360 days',
              ),
              _buildConditionPoint(
                'Checkout your near by Bhima Jewels store using the store locator option',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required Widget illustration,
    required String text,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          width: double.infinity,
          height: h * 0.22,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEFE8DD), width: 1.5),
          ),
          padding: EdgeInsets.fromLTRB(8, h * 0.035, 8, 12),
          child: Column(
            children: [
              Expanded(child: Center(child: illustration)),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3F3833),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFFCDD24),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  color: Color(0xFF3F3833),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditCardIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: -0.12,
          child: Container(
            width: w * 0.14,
            height: w * 0.09,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFD54F),
                  Color(0xFFFFB300),
                  Color(0xFFFF8F00),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8F00).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 4,
                  top: 4,
                  child: Container(
                    width: 6,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(0.5),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Icon(
                    Icons.contactless,
                    size: 8,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -4,
          child: Icon(
            Icons.pan_tool,
            size: 16,
            color: const Color(0xFF8D6E63).withOpacity(0.95),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '- ',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom Painters for Golden Icons ─────────────────────────────────────────

class _PendantDisplayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.25, h * 0.85);
    path.lineTo(w * 0.2, h * 0.5);
    path.quadraticBezierTo(w * 0.2, h * 0.2, w * 0.5, h * 0.2);
    path.quadraticBezierTo(w * 0.8, h * 0.2, w * 0.8, h * 0.5);
    path.lineTo(w * 0.75, h * 0.85);
    path.lineTo(w * 0.85, h * 0.85);
    path.lineTo(w * 0.15, h * 0.85);
    canvas.drawPath(path, paint);

    final chain = Path();
    chain.moveTo(w * 0.35, h * 0.35);
    chain.quadraticBezierTo(w * 0.5, h * 0.65, w * 0.65, h * 0.35);
    canvas.drawPath(chain, paint);

    canvas.drawCircle(Offset(w * 0.5, h * 0.62), 3.5, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChecklistPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final board = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.25, h * 0.2, w * 0.5, h * 0.7),
      const Radius.circular(3),
    );
    canvas.drawRRect(board, paint);

    final clip = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.38, h * 0.12, w * 0.24, h * 0.1),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(clip, fillPaint);

    canvas.drawLine(
      Offset(w * 0.38, h * 0.4),
      Offset(w * 0.62, h * 0.4),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.38, h * 0.55),
      Offset(w * 0.62, h * 0.55),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.38, h * 0.7),
      Offset(w * 0.55, h * 0.7),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NecklacePainter extends CustomPainter {
  final bool isElaborate;

  _NecklacePainter({required this.isElaborate});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.15, h * 0.25);
    path.quadraticBezierTo(w * 0.5, h * 0.72, w * 0.85, h * 0.25);
    canvas.drawPath(path, paint);

    if (isElaborate) {
      final innerPath = Path();
      innerPath.moveTo(w * 0.25, h * 0.25);
      innerPath.quadraticBezierTo(w * 0.5, h * 0.6, w * 0.75, h * 0.25);
      canvas.drawPath(innerPath, paint);

      canvas.drawCircle(Offset(w * 0.38, h * 0.42), 2.0, fillPaint);
      canvas.drawCircle(Offset(w * 0.62, h * 0.42), 2.0, fillPaint);
      canvas.drawCircle(Offset(w * 0.5, h * 0.5), 2.0, fillPaint);
    }

    canvas.drawCircle(Offset(w * 0.5, h * 0.65), 3.0, fillPaint);

    final pendant = Path();
    pendant.moveTo(w * 0.5, h * 0.7);
    pendant.lineTo(w * 0.42, h * 0.82);
    pendant.lineTo(w * 0.5, h * 0.94);
    pendant.lineTo(w * 0.58, h * 0.82);
    pendant.close();
    canvas.drawPath(pendant, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoldCoinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final w = size.width;
    final h = size.height;

    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.42, paint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '₹',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(w * 0.5 - textPainter.width / 2, h * 0.5 - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoldBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final w = size.width;
    final h = size.height;

    _drawBar(canvas, w * 0.08, h * 0.52, w * 0.4, h * 0.35, paint, strokePaint);
    _drawBar(canvas, w * 0.52, h * 0.52, w * 0.4, h * 0.35, paint, strokePaint);
    _drawBar(canvas, w * 0.3, h * 0.18, w * 0.4, h * 0.35, paint, strokePaint);
  }

  void _drawBar(
    Canvas canvas,
    double x,
    double y,
    double width,
    double height,
    Paint fill,
    Paint stroke,
  ) {
    final path = Path();
    path.moveTo(x + width * 0.15, y);
    path.lineTo(x + width * 0.85, y);
    path.lineTo(x + width, y + height);
    path.lineTo(x, y + height);
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Instagram Highlights Section ─────────────────────────────────────────────

class _HighlightItem {
  final String title;
  final String imageUrl;
  final String instagramUrl;

  const _HighlightItem({
    required this.title,
    required this.imageUrl,
    required this.instagramUrl,
  });
}

final List<_HighlightItem> _highlights = [
  const _HighlightItem(
    title: 'Showroom',
    imageUrl:
        'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=300&q=80',
    instagramUrl: 'https://www.instagram.com/ashokgoldanddiamonds/',
  ),
  const _HighlightItem(
    title: 'New Arrivals',
    imageUrl:
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=300&q=80',
    instagramUrl: 'https://www.instagram.com/ashokgoldanddiamonds/',
  ),
  const _HighlightItem(
    title: 'Bridal Collection',
    imageUrl:
        'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=300&q=80',
    instagramUrl: 'https://www.instagram.com/ashokgoldanddiamonds/',
  ),
  const _HighlightItem(
    title: 'Gold Scheme',
    imageUrl:
        'https://images.unsplash.com/photo-1610375461246-83df859d849d?w=300&q=80',
    instagramUrl: 'https://www.instagram.com/ashokgoldanddiamonds/',
  ),
  const _HighlightItem(
    title: 'Reviews',
    imageUrl:
        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&q=80',
    instagramUrl: 'https://www.instagram.com/ashokgoldanddiamonds/',
  ),
];

class _InstagramHighlightsSection extends StatelessWidget {
  final double h;
  final double w;

  const _InstagramHighlightsSection({required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h * 0.12,
      width: w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
        itemCount: _highlights.length,
        itemBuilder: (context, index) {
          final item = _highlights[index];
          return GestureDetector(
            onTap: () async {
              final url = Uri.parse(item.instagramUrl);
              try {
                final launched = await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
                if (!launched) {
                  await launchUrl(url, mode: LaunchMode.platformDefault);
                }
              } catch (_) {
                try {
                  await launchUrl(url, mode: LaunchMode.platformDefault);
                } catch (e) {
                  debugPrint('Could not launch URL: $e');
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: w * 0.04),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: w * 0.155,
                    height: w * 0.155,
                    padding: const EdgeInsets.all(2.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFEA9F),
                          Color(0xFFFFC043),
                          Color(0xFFE58F00),
                          Color(0xFFFFC043),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[200]),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: w * 0.027,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3F3833),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Shortcut Section under Banner Carousel ────────────────────────────────────

class _ShortcutSection extends StatelessWidget {
  final double h;
  final double w;

  const _ShortcutSection({required this.h, required this.w});

  Widget _goldGradientShader(Widget child) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFFEA9F), Color(0xFFFFC043), Color(0xFFE58F00)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
      child: Row(
        children: [
          Expanded(
            child: _buildCard(
              context,
              icon: CupertinoIcons.rectangle_stack,
              title: "Explore Schemes",
              subtitle: "Browse Plans",
              targetIndex: 1,
            ),
          ),
          SizedBox(width: w * 0.04),
          Expanded(
            child: _buildCard(
              context,
              icon: CupertinoIcons.list_bullet_below_rectangle,
              title: "My Schemes",
              subtitle: "Joined list",
              targetIndex: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int targetIndex,
  }) {
    return GestureDetector(
      onTap: () {
        final bottomNav = context
            .findAncestorStateOfType<BottomNavShortcutMixin>();
        bottomNav?.navigateTo(targetIndex);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7A5E07).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFAF6EE),
                shape: BoxShape.circle,
              ),
              child: _goldGradientShader(
                Icon(icon, size: 20, color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3F3833),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: const Color(0xFF3F3833).withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
