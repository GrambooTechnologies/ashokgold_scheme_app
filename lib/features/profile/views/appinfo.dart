import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoView extends StatefulWidget {
  static const String routeName = '/app-info';

  const AppInfoView({super.key});

  @override
  State<AppInfoView> createState() => _AppInfoViewState();
}

class _AppInfoViewState extends State<AppInfoView> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _packageInfo = info);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open link'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Palette.backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  SizeConfig.w(context, 16),
                  SizeConfig.h(context, 4),
                  SizeConfig.w(context, 16),
                  SizeConfig.h(context, 32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroCard(packageInfo: _packageInfo),
                    SizedBox(height: SizeConfig.h(context, 24)),
                    _SectionLabel(label: 'App'),
                    SizedBox(height: SizeConfig.h(context, 8)),
                    _InfoCard(
                      items: [
                        _InfoRowItem(
                          icon: Icons.devices_rounded,
                          iconBg: Palette.primaryColor.withOpacity(0.1),
                          iconColor: Palette.primaryColor,
                          label: 'Platform',
                          subtitle: 'Flutter · Android & iOS',
                        ),
                        _InfoRowItem(
                          icon: Icons.update_rounded,
                          iconBg: Palette.primaryColor.withOpacity(0.1),
                          iconColor: Palette.primaryColor,
                          label: 'Last updated',
                          subtitle: 'March 2025',
                        ),
                        _InfoRowItem(
                          icon: Icons.tag_rounded,
                          iconBg: Palette.primaryColor.withOpacity(0.1),
                          iconColor: Palette.primaryColor,
                          label: 'Build number',
                          subtitle: _packageInfo?.buildNumber ?? '—',
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.h(context, 24)),
                    _SectionLabel(label: 'Developed by'),
                    SizedBox(height: SizeConfig.h(context, 8)),
                    _DeveloperCard(w: w, onLaunch: _launchUrl),
                    SizedBox(height: SizeConfig.h(context, 24)),
                    _SectionLabel(label: 'Legal'),
                    SizedBox(height: SizeConfig.h(context, 8)),
                    _InfoCard(
                      items: [
                        _InfoRowItem(
                          icon: Icons.description_outlined,
                          iconBg: Colors.grey[100]!,
                          iconColor: Colors.grey[600]!,
                          label: 'Privacy policy',
                          isLink: true,
                          onTap: () => _launchUrl(
                            'http://anaswaragoldanddiamonds.in/privacy-policy',
                          ),
                        ),
                        _InfoRowItem(
                          icon: Icons.verified_outlined,
                          iconBg: Colors.grey[100]!,
                          iconColor: Colors.grey[600]!,
                          label: 'Terms of service',
                          isLink: true,
                          onTap: () => _launchUrl(
                            'http://anaswaragoldanddiamonds.in/terms',
                          ),
                        ),
                        _InfoRowItem(
                          icon: Icons.info_outline_rounded,
                          iconBg: Colors.grey[100]!,
                          iconColor: Colors.grey[600]!,
                          label: 'Open source licenses',
                          isLink: true,
                          onTap: () => showLicensePage(
                            context: context,
                            applicationName: 'Anaswara',
                            applicationVersion: _packageInfo?.version ?? '',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.h(context, 32)),
                    _Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Hero card
// ─────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final PackageInfo? packageInfo;

  const _HeroCard({required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.h(context, 28),
        horizontal: SizeConfig.w(context, 20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: SizeConfig.w(context, 72),
            height: SizeConfig.w(context, 72),
            decoration: BoxDecoration(
              color: Palette.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.layers_rounded,
              size: SizeConfig.w(context, 34),
              color: Palette.primaryColor,
            ),
          ),
          SizedBox(height: SizeConfig.h(context, 14)),
          Text(
            'Anaswara',
            style: TextStyle(
              fontSize: w * 0.055,
              fontWeight: FontWeight.w700,
              color: Palette.blackColor,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: SizeConfig.h(context, 4)),
          Text(
            'Gold Scheme Management',
            style: TextStyle(fontSize: w * 0.033, color: Colors.grey[500]),
          ),
          SizedBox(height: SizeConfig.h(context, 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Palette.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 13,
                  color: Palette.primaryColor,
                ),
                const SizedBox(width: 5),
                Text(
                  packageInfo != null
                      ? 'Version ${packageInfo!.version} (${packageInfo!.buildNumber})'
                      : 'Loading version…',
                  style: TextStyle(
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w600,
                    color: Palette.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Developer card — Gramboo Technologies
// ─────────────────────────────────────────────

class _DeveloperCard extends StatelessWidget {
  final double w;
  final Future<void> Function(String) onLaunch;

  const _DeveloperCard({required this.w, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          // Brand header
          Padding(
            padding: EdgeInsets.all(SizeConfig.w(context, 14)),
            child: Row(
              children: [
                Container(
                  width: SizeConfig.w(context, 46),
                  height: SizeConfig.w(context, 46),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.w(context, 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gramboo Technologies',
                        style: TextStyle(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Technology & Digital Solutions',
                        style: TextStyle(
                          fontSize: w * 0.029,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey[100]),

          _DevContactRow(
            icon: Icons.language_rounded,
            iconColor: Palette.primaryColor,
            iconBg: Palette.primaryColor.withOpacity(0.1),
            label: 'Website',
            value: 'www.gramboo.in',
            onTap: () => onLaunch('https://www.gramboo.in'),
          ),
          Divider(
            height: 1,
            color: Colors.grey[100],
            indent: SizeConfig.w(context, 56),
          ),
          _DevContactRow(
            icon: Icons.mail_outline_rounded,
            iconColor: const Color(0xFF4361EE),
            iconBg: const Color(0xFFEEF1FF),
            label: 'Email',
            value: 'mail@gramboo.in',
            onTap: () => onLaunch('mailto:mail@gramboo.in'),
          ),
          Divider(
            height: 1,
            color: Colors.grey[100],
            indent: SizeConfig.w(context, 56),
          ),
          _DevContactRow(
            icon: Icons.phone_outlined,
            iconColor: Colors.green[700]!,
            iconBg: Colors.green[50]!,
            label: 'Phone',
            value: '+91 90610 55533',
            onTap: () => onLaunch('tel:+919061055533'),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _DevContactRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;

  const _DevContactRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(16))
            : BorderRadius.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(context, 14),
            vertical: SizeConfig.h(context, 12),
          ),
          child: Row(
            children: [
              Container(
                width: SizeConfig.w(context, 34),
                height: SizeConfig.w(context, 34),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  size: SizeConfig.w(context, 16),
                  color: iconColor,
                ),
              ),
              SizedBox(width: SizeConfig.w(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: w * 0.029,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w500,
                        color: iconColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: SizeConfig.w(context, 4)),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: SizeConfig.w(context, 11),
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Generic info card
// ─────────────────────────────────────────────

class _InfoRowItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final bool isLink;
  final VoidCallback? onTap;

  const _InfoRowItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.isLink = false,
    this.onTap,
  });
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRowItem> items;

  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: List.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[100],
              indent: SizeConfig.w(context, 56),
            );
          }
          return _InfoRow(item: items[index ~/ 2]);
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final _InfoRowItem item;

  const _InfoRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(context, 14),
            vertical: SizeConfig.h(context, 12),
          ),
          child: Row(
            children: [
              Container(
                width: SizeConfig.w(context, 34),
                height: SizeConfig.w(context, 34),
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  size: SizeConfig.w(context, 17),
                  color: item.iconColor,
                ),
              ),
              SizedBox(width: SizeConfig.w(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: w * 0.037,
                        fontWeight: FontWeight.w500,
                        color: Palette.blackColor,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: w * 0.031,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (item.isLink)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Footer
// ─────────────────────────────────────────────

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        children: [
          Text(
            'Designed & developed by Gramboo Technologies',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: w * 0.03, color: Colors.grey[400]),
          ),
          const SizedBox(height: 4),
          Text(
            '© ${DateTime.now().year} Anaswara. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: w * 0.028, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
