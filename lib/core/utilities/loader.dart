import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool? isLinear;

  const Loader({super.key, this.isLinear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLinear == null || isLinear == false
          ? const CircularProgressIndicator()
          : const LinearProgressIndicator(),
    );
  }
}
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class Loader extends StatefulWidget {
//   const Loader({super.key});
//
//   @override
//   State<Loader> createState() => _LoaderState();
// }
//
// class _LoaderState extends State<Loader> {
//   int dotCount = 1;
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       setState(() {
//         dotCount++;
//         if (dotCount > 3) dotCount = 1;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   String get dots => '.' * dotCount;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 24,
//         vertical: 12,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Animated dots
//           Text(
//             dots,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//
//           const SizedBox(width: 6),
//
//           // Loading text
//           const Text(
//             "Loading",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
