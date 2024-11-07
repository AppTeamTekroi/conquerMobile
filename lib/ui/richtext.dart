import 'package:flutter/material.dart';
import 'package:vconquer/ui/color/appColor.dart';

class CommonRichText extends StatelessWidget {
  final String label;
  final dynamic value;

  const CommonRichText({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 20,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: '$label',
        style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.normal,fontSize: 14),

      //  style: TextStyle(color: AppColors.blues, fontWeight: FontWeight.w500, fontSize: 15),
        children: [
          TextSpan(
            text: value.toString(), // Convert value to string
            style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.normal,fontSize: 14),
          ),
        ],
      ),
    );
  }
}