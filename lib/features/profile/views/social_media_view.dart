import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/common/models/branch_social_media_model.dart';
import 'package:ashokgold_scheme_app/features/profile/providers/main_branch_social_media_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaView extends ConsumerWidget {
  static const String routeName = '/social-media';

  const SocialMediaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialMediaAsync = ref.watch(mainBranchSocialMediaProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Social Media',
          style: TextStyle(
            color: Palette.blackColor,
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.w(context, 18),
          ),
        ),
      ),
      body: socialMediaAsync.when(
        data: (socialMediaList) {
          if (socialMediaList.isEmpty) {
            return const Center(
              child: Text('No social media accounts available'),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(SizeConfig.w(context, 16)),
            itemCount: socialMediaList.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: SizeConfig.h(context, 10)),
            itemBuilder: (context, index) {
              final item = socialMediaList[index];
              return _SocialMediaTile(item: item);
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: Palette.primaryColor),
        ),
        error: (error, _) => Center(
          child: Text(
            'Failed to load social media accounts',
            style: TextStyle(fontSize: SizeConfig.w(context, 14)),
          ),
        ),
      ),
    );
  }
}

class _SocialMediaTile extends StatelessWidget {
  final BranchSocialMediaModel item;

  const _SocialMediaTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(SizeConfig.w(context, 14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(SizeConfig.w(context, 14)),
        onTap: () => _openProfileUrl(item.profileUrl),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(context, 14)),
          child: Row(
            children: [
              _buildLeadingIcon(context),
              SizedBox(width: SizeConfig.w(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.platformName,
                      style: TextStyle(
                        fontSize: SizeConfig.w(context, 15),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(context, 3)),
                    Text(
                      item.handle,
                      style: TextStyle(
                        fontSize: SizeConfig.w(context, 13),
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: Palette.primaryColor,
                size: SizeConfig.w(context, 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    if (item.iconUrl != null && item.iconUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.w(context, 10)),
        child: Image.network(
          item.iconUrl!,
          width: SizeConfig.w(context, 44),
          height: SizeConfig.w(context, 44),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallbackIcon(context),
        ),
      );
    }

    return _fallbackIcon(context);
  }

  Widget _fallbackIcon(BuildContext context) {
    return Container(
      width: SizeConfig.w(context, 44),
      height: SizeConfig.w(context, 44),
      decoration: BoxDecoration(
        color: Palette.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(SizeConfig.w(context, 10)),
      ),
      child: Icon(
        Icons.public_rounded,
        color: Palette.primaryColor,
        size: SizeConfig.w(context, 22),
      ),
    );
  }

  Future<void> _openProfileUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
