import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vconquer/features/Opportunities/New_Opportunities.dart';
import 'package:vconquer/features/Reports/salesReportpage.dart';
import 'package:vconquer/features/customers/customer_screen.dart';
import 'package:vconquer/features/orderlist/new_order_page.dart';
import 'package:vconquer/features/products/Products.dart';
import 'dart:math';

import 'package:vconquer/ui/color/appColor.dart';
import 'package:get/get.dart';

import '../../login/controller/login_controller.dart';
import '../../login/presentation/loginScreen.dart';
import '../Opportunities/Opportunities.dart';
import '../Quatation/new_quatation_page.dart';
import '../orderlist/order_list.dart';
import '../Quatation/Quotations.dart';
import '../VirtualAssist/virtual-assist.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LoginController lc = Get.find();
  HomescreenController hc = Get.find();
  List<String> list = <String>['This Year', '2022', '2021', '2020'];
  String dropdownValue = 'This Year';
  final List<String> images = [
    "lib/ui/assets/img1.png",
    "lib/ui/assets/img2.png",
    "lib/ui/assets/img3.png"
  ];
  List<String> names = [
    'Opportunity',
    'Quatation',
    'Orders',
    'Invoice',
    'Credit',
    'Aging',
    'Reports'
  ];
  List<IconData> icons = [
    Icons.file_copy_outlined,
    Icons.shopping_cart_outlined,
    Icons.local_shipping_outlined,
    Icons.receipt_long,
    Icons.credit_score_outlined,
    // Icons.bookmark_border_outlined,
    Icons.money,

    Icons.account_balance_wallet_outlined,
    // Icons.calculate_outlined,
  ];

  List<double> iconSizes = [
    40.0,
    40.0,
    40.0,
    43.0,
    40.0,
    40.0,
    40.0,
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
    // hc.YtdDetails(context);
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

  Widget _buildRow(String label, dynamic amount, {Color color = Colors.black}) {
    double value = 0.0;

    if (amount is num) {
      value = amount.toDouble();
    } else if (amount is String) {
      value = double.tryParse(amount) ?? 0.0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),

        Text(
          amount != null ? "₹${value.toStringAsFixed(2)}" : "--",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      //  backgroundColor: AppColors.white,
      backgroundColor: AppColors.primary,

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
                                  // final SharedPreferences _prefs =
                                  // await SharedPreferences.getInstance();
                                  // _prefs.setString('token', '');
                                  //
                                  // String? access_token =
                                  // _prefs.getString('access_token');
                                  // print(
                                  //     'Access Token after clearing: $access_token');
                                  // Get.offAll(() => const LoginScreen());
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
                           // height: 230,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            child: Obx(() {
                              if (hc.isLoading2.value) {
                                return Center(child: CircularProgressIndicator());
                              }

                              if (hc.errorMessage2.isNotEmpty) {
                                return Center(child: Text(hc.errorMessage2.value));
                              }

                              final data = hc.ytdDetails;

                              if (data.isEmpty) {
                                return Center(child: Text('--'));
                              }

                              final mtdList = data['mtd'] ?? [];
                              final ytdList = data['ytd'] ?? [];
                              final qtdList = data['qtd'] ?? [];

                              final mtd = mtdList.isNotEmpty ? mtdList[0] : null;
                              final ytd = ytdList.isNotEmpty ? ytdList[0] : null;

                              final overdueNegative = data['overdue_negative'] ?? 0;
                              final overduePositive = data['overdue_positive'] ?? 0;


                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     DropdownButton<String>(
                                    //       value: dropdownValue,
                                    //       icon: const Icon(
                                    //           Icons.keyboard_arrow_down_outlined),
                                    //       // elevation: -1,
                                    //       // elevation: 16,
                                    //       underline: Container(
                                    //         height: 0,
                                    //       ),
                                    //       style: const TextStyle(
                                    //           color: Colors.black),
                                    //       onChanged: (String? value) {
                                    //         // This is called when the user selects an item.
                                    //         setState(() {
                                    //           dropdownValue = value!;
                                    //         });
                                    //       },
                                    //       items: list
                                    //           .map<DropdownMenuItem<String>>(
                                    //               (String value) {
                                    //             return DropdownMenuItem<String>(
                                    //               value: value,
                                    //               child: Text(
                                    //                 value,
                                    //                 style: const TextStyle(fontSize: 13),
                                    //               ),
                                    //             );
                                    //           }).toList(),
                                    //     ),
                                    //     Spacer(),
                                    //     // Text(
                                    //     //   'View bills',
                                    //     //   style: TextStyle(
                                    //     //       color: AppColors.mainblue,
                                    //     //       fontWeight: FontWeight.w500),
                                    //     // )
                                    //   ],
                                    // ),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                if (ytd != null) ...[
                                                  Text("YTD:"),

                                                  _buildRow("", ytd['total_amount']),
                                                ] else ...[
                                                  Text("YTD:"),
                                                  Text("--", style: TextStyle(color: Colors.grey)),
                                                ],
                                              ],
                                            ),


                                          ],
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 1,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                            ),
                                            SizedBox(width: 15,),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                if (mtd != null) ...[
                                                  Text("MTD:(${mtd['month_name']}):"),
                                                  _buildRow("", mtd['total_amount']),
                                                ] else ...[
                                                  Text("MTD:"),
                                                  Text("--", style: TextStyle(color: Colors.grey)),
                                                ],
                                              ],
                                            ),



                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("QTD:", style: TextStyle(fontSize: 14)),
                                        if (qtdList.isNotEmpty)
                                          ...qtdList.map<Widget>((q) {
                                            final month = q['month_name'] ?? "Unknown";
                                            final amount = q['total_amount'] ?? 0;
                                            return _buildRow("$month: ", amount);
                                          }).toList()
                                        else
                                          const Text("--", style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    _buildRow("Overdue: ", overdueNegative, color: Colors.red),
                                    _buildRow("Overdue: ", overduePositive, color: Colors.green),
                                  ],
                                ),
                              );
                            })),
                        SizedBox(
                          height: 12,
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
                              itemCount: 7,
                              itemBuilder: (context, index) => SizedBox(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (index == 0) {
                                        // Get.to(() => NewQuotationScreen());

                                        Get.to(() => OpportunitiesPage());
                                      }
                                      if (index == 1) {
                                        Get.to(() => QuatationListScreen());

                                      }
                                      if (index == 2) {
                                        Get.to(()=> OrderListScreen());

                                      }

                                      if (index == 3) {
                                        //  Get.off(()=> Products());

                                      }
                                      if (index == 4) {}
                                      if (index == 5) {}
                                      if (index == 6) {
                                        Get.to(()=> ReportListScreen());

                                      }

                                    },
                                    child: Container(

                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          // border: Border(BorderSide(color: Colors.black)),

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
                                              style: TextStyle(
                                                fontSize: height *0.01,
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
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
      //   },
      //   icon: Icon(Icons.support_agent_outlined),
      //   label: Text('Ask Assistant'),
      //   tooltip: 'Chat with the Virtual Assistant',
      //   backgroundColor: Colors.orange.shade100,
      // ),

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
