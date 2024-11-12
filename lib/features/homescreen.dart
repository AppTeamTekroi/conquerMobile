import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vconquer/features/customers/customer_screen.dart';
import 'package:vconquer/features/orderlist/order_page.dart';
import 'package:vconquer/features/products/Products.dart';
import 'dart:math';

import 'package:vconquer/ui/color/appColor.dart';
import 'package:get/get.dart';

import '../login/controller/login_controller.dart';
import '../login/presentation/loginScreen.dart';
import 'Quatation/new_quatation_page.dart';
import 'Quatation/quatation_page.dart';
import 'Quatation/quatationlst_Screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LoginController lc = Get.put(LoginController());
  List<String> list = <String>['This Year', '2022', '2021', '2020'];
  String dropdownValue = 'This Year';
  final List<String> images = [
    "lib/ui/assets/img1.png",
    "lib/ui/assets/img2.png",
    "lib/ui/assets/img3.png"
  ];
  List<String> names = [
    'Quatation',
    'Orders',
    'Invoice',
    'Credit',
    'Aging',
  ];
  List<IconData> icons = [
    Icons.shopping_cart_outlined,
    Icons.local_shipping_outlined,
    Icons.receipt_long,
    Icons.credit_score_outlined,
   // Icons.bookmark_border_outlined,
    Icons.money,

    // Icons.account_balance_wallet_outlined,
    // Icons.calculate_outlined,
  ];

  List<double> iconSizes = [
    40.0,
    40.0,
    40.0,
    43.0,
    40.0,
    // 40.0,
    // 40.0,
    // 40.0,
    // 40.0
  ];
  bool _dialogShown = false;
  late ScrollController _scrollController;
  Color _appBarColor = Colors.transparent; // Initial color
  static const double kExpandedHeight = 150.0;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset > kExpandedHeight - kToolbarHeight) {
            _appBarColor = AppColors.blues;
          } else {
            _appBarColor = Colors.transparent; // Change back to transparent
          }
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: kExpandedHeight,
            pinned: true,
            backgroundColor: _appBarColor, // Use the dynamic color
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: RightCurveClipper(),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                  ),
                  items: images.map((imgPath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            imgPath,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            title: Row(
              children: [
                Image(
                  image: AssetImage("lib/ui/assets/client.png"),
                  height: 50,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () async {
                      bool shouldLogout = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            backgroundColor: Colors.white,
                            content: const Text(
                              "Are you sure you want to logout?",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: AppColors.mainblue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  await lc.logOutUser();
                                  final SharedPreferences _prefs =
                                      await SharedPreferences.getInstance();
                                  _prefs.setString('token', '');

                                  String? access_token =
                                      _prefs.getString('access_token');
                                  print(
                                      'Access Token after clearing: $access_token');
                                  Get.offAll(() => const LoginScreen());
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "No",
                                  style: TextStyle(
                                    color: AppColors.mainblue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldLogout == true) {
                        lc.logOutUser();
                      }
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Icon(Icons.notification_add, color: Colors.white),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '➤  OVERVIEW',
                            style: TextStyle(color: Colors.green[900]),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                            height: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down_outlined),
                                        // elevation: -1,
                                        // elevation: 16,
                                        underline: Container(
                                          height: 0,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        onChanged: (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            dropdownValue = value!;
                                          });
                                        },
                                        items: list
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      Spacer(),
                                      Text(
                                        'View bills',
                                        style: TextStyle(
                                            color: AppColors.mainblue,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sales',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            '₹400.00',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.26,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 1,
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Purchases',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                '₹0.0',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '✦ CAPABILITIES ✦',
                            style: TextStyle(color: Colors.green[900]),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        // Text(
                        //   'FEATURES',
                        //   style: TextStyle(color: Colors.green[900]),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisExtent: 92,
                                crossAxisSpacing: 0.0,
                                mainAxisSpacing: 0.0,
                              ),
                              // itemCount: pc.productDataList[0].listings!.length,
                              itemCount: 5,
                              itemBuilder: (context, index) => SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (index == 0) {
                                       // Get.to(() => NewQuotationScreen());

                                        Get.to(() => QuatationListScreen());

                                      }
                                      if (index == 1) {
                                         Get.to(()=> QuatationScreen());
                                      }
                                      if (index == 2) {
                                        //  Get.off(()=> Products());
                                      }

                                      if (index == 3) {}
                                      if (index == 4) {}

                                    },
                                    child: Container(
                                     height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          // border: Border.all(width: 1),
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              icons[index],
                                              color: AppColors.blues,
                                              size: iconSizes[index],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              names[index],
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 1, // Number of items in the list
            ),
          )
        ],
      ),
    );
  }
}

class RightCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40); // Start point
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 90); // Create curve
    path.lineTo(size.width, 0); // Line to the top right corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
