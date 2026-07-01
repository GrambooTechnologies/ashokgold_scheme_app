import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/auth_guard.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/views/scheme_joining_view.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_detail_response_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/scheme_detail_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/selected_payment_amount_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/widgets/scheme_chip_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/translator/languageProvider.dart';
import '../providers/translated_scheme_provider.dart';
import '../widgets/benefit_point_card_widget.dart';
import '../widgets/smart_plus_calculator_widget.dart';

class SchemeDetailView extends ConsumerStatefulWidget {
  static const String routeName = '/scheme-detail';

  static String routePath(String schemeId) => '/scheme-detail/$schemeId';
  final String schemeId;

  const SchemeDetailView({super.key, required this.schemeId});

  @override
  ConsumerState<SchemeDetailView> createState() => _SchemeDetailViewState();
}

class _SchemeDetailViewState extends ConsumerState<SchemeDetailView> {
  String? schemeId;

  @override
  void initState() {
    super.initState();
    schemeId = stringOrNull(widget.schemeId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedPaymentAmountProvider.notifier).clearAmount();
      // Ensure language resets to English on each fresh open
      ref.read(languageProvider.notifier).state = 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    final schemeAsync = ref.watch(translatedSchemeProvider(schemeId!));
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        actions: [
          Consumer(
            builder: (context, ref, _) {
              // ── FIX: trim() guards against any accidental whitespace ──
              final lang = ref.watch(languageProvider).trim();
              final isEnglish = lang == 'en';

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // ── FIX: use trimmed, consistent values ──
                      ref.read(languageProvider.notifier).state = isEnglish
                          ? 'ml'
                          : 'en';
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // English pill
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isEnglish
                                  ? Palette.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'English',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isEnglish
                                    ? Colors.white
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                          // Malayalam pill
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: !isEnglish
                                  ? Palette.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'മലയാളം',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: !isEnglish
                                    ? Colors.white
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: schemeAsync.when(
        data: (scheme) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Images Carousel
              _SchemeImagesCarousel(
                images: scheme.images,
                width: w,
                height: h * 0.24,
              ),
              // Content
              Padding(
                padding: EdgeInsets.symmetric(
                  // horizontal: w * 0.05,
                  vertical: h * 0.02,
                ),
                child: buildContent(
                  context: context,
                  scheme: scheme,
                  h: h,
                  w: w,
                ),
              ),
            ],
          ),
        ),
        loading: () => const Loader(),
        error: (error, _) => ErrorRetryWidget(
          message: 'Error: ${error.toString()}',
          onRetry: () {
            ref.invalidate(schemeDetailProvider(schemeId!));
            ref.invalidate(translatedSchemeProvider(schemeId!));
          },
        ),
      ),
    );
  }

  Widget buildContent({
    required BuildContext context,
    required SchemeDetailByIdResponseModel scheme,
    required double h,
    required double w,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Text(
            scheme.name,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: w * 0.06,
              fontWeight: FontWeight.w500,
              color: Palette.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: h * 0.01),

        /// Chips
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Row(
            children: [
              SchemeChipWidget(text: scheme.schemeCode),
              SizedBox(width: w * 0.02),
              SchemeChipWidget(
                text: '${scheme.schemeDetails.installmentCount} Months',
                color: Palette.cardBackgroundColor,
              ),
            ],
          ),
        ),

        SizedBox(height: h * 0.02),

        // Description
        if (scheme.description != null && scheme.description!.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
            child: Text(
              scheme.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: w * 0.036,
                color: Palette.blackColor,
                height: 1.5,
              ),
            ),
          ),
        ],

        SizedBox(height: h * 0.02),

        // Benefit Points Section
        if (scheme.benefitPoints.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: _ExpandableSection(
              title: 'Key Benefits of Gold Plan',
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: scheme.benefitPoints.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final p = scheme.benefitPoints[i];
                  return BenefitPointListTile(
                    description: p.benefitPointDescription,
                    index: i,
                  );
                },
              ),
            ),
          ),
        ],

        // Benefit Calculator Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          child: _ExpandableSection(
            title: 'Scheme Benefit Calculator',
            child: SmartPlusCalculatorWidget(
              schemeId: scheme.schemeId,
              schemeName: scheme.name,
            ),
          ),
        ),

        // Terms and Conditions
        if (scheme.termsAndConditions.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: _ExpandableSection(
              title: 'Terms & Conditions',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: scheme.termsAndConditions
                    .map(
                      (tc) => Padding(
                        padding: EdgeInsets.only(bottom: h * 0.008),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${tc.termConditionPriority}. ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: w * 0.035,
                                    fontWeight: FontWeight.w600,
                                    color: Palette.blackColor,
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                tc.termConditionDescription,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: w * 0.035,
                                      color: Palette.blackColor,
                                      height: 1.5,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: h * 0.01),
        ],

        /// Join Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
          child: Consumer(
            builder: (context, ref, child) {
              final selectedAmount = ref.watch(selectedPaymentAmountProvider);

              return Material(
                color: Palette.primaryColor,
                borderRadius: BorderRadius.circular(w * 0.04),
                elevation: 2,
                shadowColor: Palette.primaryColor.withOpacity(0.3),
                child: InkWell(
                  onTap: () {
                    if (!AuthGuard.requireAuth(context, ref)) return;
                    context.push(
                      SchemeJoiningView.routePath(
                        schemeId: scheme.schemeId,
                        amount: selectedAmount,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(w * 0.04),
                  child: Container(
                    width: w,
                    padding: EdgeInsets.symmetric(vertical: h * 0.018),
                    alignment: Alignment.center,
                    child: Text(
                      'Join Now',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: h * 0.03),
      ],
    );
  }
}

class _SchemeImagesCarousel extends StatefulWidget {
  final List<SchemeImageModel> images;
  final double width;
  final double height;

  const _SchemeImagesCarousel({
    required this.images,
    required this.width,
    required this.height,
  });

  @override
  State<_SchemeImagesCarousel> createState() => _SchemeImagesCarouselState();
}

class _SchemeImagesCarouselState extends State<_SchemeImagesCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      /*
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 40),
        ),
      );
      */
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Image.asset(
          "assets/banner/goldScheme.png",
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
              ),
            );
          },
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          // Image Carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              /*
              final imageUrl = widget.images[index].imageUrl;

              if (imageUrl == null || imageUrl.isEmpty) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
                );
              }

              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: widget.width,
                height: widget.height,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.grey[300]),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              );
              */
              return Image.asset(
                "assets/banner/goldScheme.png",
                fit: BoxFit.cover,
                width: widget.width,
                height: widget.height,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Indicator Dots
          if (widget.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 8 : 6,
                      height: _currentIndex == index ? 8 : 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExpandableSection extends StatefulWidget {
  final String title;
  final Widget child;

  const _ExpandableSection({required this.title, required this.child});

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    _iconTurns = _controller.drive(
      Tween<double>(
        begin: 0.0,
        end: 0.5,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Palette.blackColor.withOpacity(0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _toggleExpanded,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Palette.blackColor,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _iconTurns,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Palette.primaryColor.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Palette.primaryColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: _heightFactor,
              axisAlignment: -1.0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
