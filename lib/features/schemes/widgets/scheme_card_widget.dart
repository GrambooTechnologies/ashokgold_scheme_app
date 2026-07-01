import 'package:ashokgold_scheme_app/features/schemes/models/scheme_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/theme.dart';

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
                child: Image.asset(
                  "assets/banner/goldScheme.png",
                  fit: BoxFit.cover,
                  width: w,
                  height: h * 0.24,
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
