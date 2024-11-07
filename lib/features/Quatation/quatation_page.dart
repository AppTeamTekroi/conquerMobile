import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vconquer/features/Quatation/new_quatation_page.dart';
import 'package:vconquer/features/Quatation/quatation_controller.dart';
import 'package:vconquer/features/navBar.dart';

import '../../ui/color/appColor.dart';
import '../../ui/richtext.dart';
import '../orderlist/order_controller.dart';

class QuatationScreen extends StatefulWidget {
  QuatationScreen({
    super.key,
  });
  @override
  State<QuatationScreen> createState() => _QuatationScreentate();
}

class _QuatationScreentate extends State<QuatationScreen> {
  //OrderPlacedController oc = Get.put(OrderPlacedController());
  QuatationController qc = Get.put(QuatationController());
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    qc.Quatationlist(context);
    super.initState();
  }

  @override
  void dispose() {
    qc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          title: Text(
            "Quotation Catalog",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          actions: [
            Text(
              "New",
              style: TextStyle(
                color: AppColors.blues,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(onTap: () => Get.to(() => NewQuotationScreen()) ,child:
            Row(
                children: [

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.red.withOpacity(0.4),
                  width: 4,
                ),
              ),

              child:

                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 9,
                  child: Icon(
                    Icons.add,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
            ),
              ],
              )
            ),

            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(children: [
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            height: height * 0.18,
            width: MediaQuery.of(context).size.width * 0.94,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: height * 0.015),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: height * 0.08,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 147, 147, 147)),
                                ),
                                Text(
                                  "₹0.00",
                                  style: TextStyle(
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Paid',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 147, 147, 147))),
                                Text(
                                  "₹0.00",
                                  style: TextStyle(
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Pending',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 147, 147, 147)),
                                ),
                                Text(
                                  "₹0.00",
                                  style: TextStyle(
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),

                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 193, 193, 193),
                    height: 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'This Year',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.02),
                              ),
                              const Icon(CupertinoIcons.pen)
                            ],
                          ),
                          const Text(
                            "Starting date - ending date",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.filter_alt_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            CupertinoIcons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(child:
    Obx(() {
      if (qc.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (qc.errorMessage.value.isNotEmpty) {
        return Center(
            child: Text(qc.errorMessage.value));
      } else {
        final dataList = qc.quatationlist.value;
        final list = dataList is Map<dynamic, dynamic> ? dataList : {};
        final employeeOnDuty =list["data"] is List<dynamic> ? list["data"] : [];
        return ListView.builder(
            itemCount: employeeOnDuty.length,
            itemBuilder: (context, index) {
              final item = employeeOnDuty[index] as Map<String, dynamic>;

    return  Padding(
                  padding:  EdgeInsets.symmetric(vertical: 5,horizontal: Get.height * 0.015),
              child:InkWell(
                  onTap: () {
                    print('Order Card Pressed');
                    //
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         Orderdetails(
                    //             id:
                    //             oc.orderPlacedList[index].id!.toString()),
                    //   ),
                    // );
                  },
                  child:Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 5,horizontal: Get.height * 0.015),
                      child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Code: ${item["customer_webid"]}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.blues),
                                          ),
                                          // CommonRichText(
                                          //   label: 'Doc No: ',
                                          //   value: item["doc_no"] ?? '- -',
                                          // ),
                                          GestureDetector(
                                            onTap: () async {
                                              // await customerController.fetchUserID(
                                              //     context,
                                              //     itemId); // Fetch the details
                                              // Get.to(() => CustomerEditscreen());
                                            },
                                            child: Row(
                                              children: [
                                                // Text(
                                                //   "Edit",
                                                //   style: TextStyle(
                                                //       fontSize: 14,
                                                //       // fontWeight: FontWeight.w500,
                                                //       color: AppColors.blues),
                                                // ),
                                                // Icon(
                                                //   Icons.edit,
                                                //   color: AppColors.blues,
                                                //   size: 14,
                                                // )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Divider(),
                                      CommonRichText(
                                        label: 'Card Name: ',
                                        value: item["customer_commonname"] ?? '',
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonRichText(
                                            label: 'On: ',
                                            value: item["quotation_date"] ?? '- -',
                                          ),
                                          CommonRichText(
                                            label: 'Valid: ',
                                            value: item["valid_till"] ?? '- -',
                                          ),
                                          // Text(
                                          //   "📞 ${item["cellular"] ?? '- -'}",
                                          //   style: TextStyle(
                                          //     fontSize: 14,
                                          //     color: Colors.green[900],
                                          //   ),
                                          //
                                          // ),
                                          // CommonRichText(
                                          //   label: 'Veh No: ',
                                          //   value: item["vehicle_no"] ?? '- -',
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          // CommonRichText(
                                          //   label: 'Sales Emp: ',
                                          //   value: item["sales_emp_name"] ?? '- -',
                                          // ),

                                          Text(
                                            "📞 ${item["contact_id"] ?? '- -'}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.green[900],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Details",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      // fontWeight: FontWeight.w500,
                                                      color: Colors.grey),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios_outlined,
                                                  color: Colors.grey,
                                                  size: 14,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),


              ),
                  ),

    ),
    );
            });
      }
    })
    ),
        ]));
  }
}
