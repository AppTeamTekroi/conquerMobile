import 'package:flutter/material.dart';

import '../../ui/color/appColor.dart';
class CustomerEditscreen extends StatefulWidget {
  const CustomerEditscreen({super.key});

  @override
  State<CustomerEditscreen> createState() => _CustomerEditscreenState();
}

class _CustomerEditscreenState extends State<CustomerEditscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 40,
        backgroundColor: AppColors.primary,
        leading: Padding(
        padding: EdgeInsets.only(left: 12),
    child: GestureDetector(
    onTap: () {
    Navigator.of(context).pop();
    },
    child: Icon(
    Icons.arrow_back_ios_sharp,
    size: 20,
    ),
    ),
    ),
    ),
    );
    }
}
