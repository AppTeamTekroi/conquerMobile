import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerLoadingOverlay() {
  return Container(
    color: Colors.black.withValues(alpha: 0.5), // Semi-transparent overlay
    child: Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.white,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  );
}


//
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// Widget shimmerLoadingOverlay() {
//   return Container(
//     color: Colors.white, // Keeps the background light
//     child: Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         children: List.generate(5, (index) => shimmerItem()), // Example items
//       ),
//     ),
//   );
// }
//
// // Example shimmer loading block
// Widget shimmerItem() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//     child: Container(
//       width: double.infinity,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(10),
//       ),
//     ),
//   );
// }
