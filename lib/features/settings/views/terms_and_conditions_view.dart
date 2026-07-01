import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/settings/providers/app_content_provider.dart';
import 'package:ashokgold_scheme_app/features/settings/models/app_content_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TermsAndConditionsView extends ConsumerWidget {
  static const String routeName = '/terms-and-conditions';

  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(termsAndConditionsProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Palette.blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: contentAsync.when(
        data: (content) {
          final contentType = AppContentTypeParser.fromValue(
            content.contentType,
          );
          final title = content.title?.trim();

          if (contentType == AppContentType.markdown) {
            return Markdown(
              data: content.content,
              padding: const EdgeInsets.all(16),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null && title.isNotEmpty) ...[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(content.content, style: const TextStyle(height: 1.6)),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: Palette.primaryColor),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
