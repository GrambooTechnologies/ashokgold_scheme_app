import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/theme.dart';
import '../models/scheme_model.dart';

class SchemeCardWidget extends StatelessWidget {
  final SchemeModel scheme;
  final VoidCallback onTap;

  const SchemeCardWidget({
    super.key,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final imageUrl = scheme.displayImageUrl;

    debugPrint(
      '--> [SchemeCardWidget] id: ${scheme.schemeId}, name: ${scheme.name}, displayImageUrl: "$imageUrl", imageList: ${scheme.imageList.map((e) => e.imageUrl).toList()}',
    );

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, h * 0.02),
        child: Container(
          width: w,
          height: h * 0.24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w * 0.05),
            color: Colors.grey[300],
          ),
          child: Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(w * 0.05),
                child: (imageUrl != null && imageUrl.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: w,
                        height: h * 0.24,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: w,
                            height: h * 0.24,
                            color: Colors.grey[300],
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          debugPrint(
                            '--> [CachedNetworkImage ERROR] url: $url, error: $error',
                          );
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: w,
                            height: h * 0.24,
                            errorBuilder: (context, err, stack) {
                              debugPrint(
                                '--> [Image.network ERROR] url: $imageUrl, error: $err',
                              );
                              return Container(
                                width: w,
                                height: h * 0.24,
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
                      )
                    : Container(
                        width: w,
                        height: h * 0.24,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
              ),
              // Content Overlay
              Padding(
                padding: EdgeInsets.only(left: w * 0.06, bottom: h * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: w * 0.22,
                      height: h * 0.033,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.02),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Explore",
                          style: GoogleFonts.akatab(
                            fontSize: w * 0.036,
                            fontWeight: FontWeight.w700,
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
