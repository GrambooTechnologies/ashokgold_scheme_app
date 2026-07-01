import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x80FFFFFF),
      child: const Center(child: Loader()),
    );
  }
}
