import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:vconquer/features/Quatation/quatation_controller.dart';
import 'package:vconquer/features/orderlist/order_page.dart';
import 'package:vconquer/ui/richtext.dart';

import '../../ui/Buttons/buttonBS.dart';
import '../../ui/CommonWidget.dart';
import '../../ui/color/appColor.dart';
import '../Quatation/pdfview.dart';
import '../customers/customer_screen.dart';

class QuatationDetailsScreen extends StatefulWidget {
  final String? customerId;
  const QuatationDetailsScreen({Key? key, this.customerId = ""}) : super(key: key);
  @override
  State<QuatationDetailsScreen> createState() => _QuatationScreentate();
}

class _QuatationScreentate extends State<QuatationDetailsScreen> {
  QuatationController qc = Get.put(QuatationController());

  String? pdf_file;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      qc.Quatationdetails(context, widget.customerId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          "QU0TATION DETAILS",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        // actions: [
        //   GestureDetector(
        //     onTap: () => Get.to(() => NewOrderScreen()),
        //     child: Row(
        //       children: [
        //         Text(
        //           'New',
        //           style: TextStyle(
        //               color: Colors.green[900], fontWeight: FontWeight.w500),
        //         ),
        //         Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(100),
        //             border: Border.all(
        //                 color: Colors.red.withOpacity(0.4), width: 4),
        //           ),
        //           child: CircleAvatar(
        //             backgroundColor: Colors.red,
        //             radius: 9,
        //             child: Icon(Icons.add, size: 14, color: Colors.white),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   SizedBox(width: 10),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
              children: [
                // Row(
                //   children: [
                //     Container(
                //         decoration: BoxDecoration(
                //           // borderRadius: BorderRadius.circular(100),
                //           // border: Border.all(color: Colors.red.withOpacity(0.4), width: 4),
                //         ),
                //         child: Text(
                //           'COPY FROM QUATATION',
                //           style: TextStyle(
                //               color: Colors.green[900],
                //               fontWeight: FontWeight.w500),
                //         )),
                //   ],
                // ),
                // SizedBox(height: 8),
                // Obx(() {
                //   if (qc.isLoading.value) {
                //     return Center(child: CircularProgressIndicator());
                //   } else if (qc.errorMessage.value.isNotEmpty) {
                //     return Center(child: Text(qc.errorMessage.value));
                //   } else {
                //     final dataList = qc.quatationlist.value;
                //     final list = dataList is Map<dynamic, dynamic> ? dataList : {};
                //     final employeeOnDuty = list["data"] is List<dynamic> ? list["data"] : [];
                //
                //     final Map<String, String> dropdownMap = {
                //       for (var item in employeeOnDuty)
                //         '  ${item["id"]}-(${item["customer_webid"]}) - ${item["customer_commonname"]}':
                //         (item["id"]).toString()
                //     };
                //
                //     // Extract keys (display text) for DropdownSearch items
                //     final dropdownItems = dropdownMap.keys.toList();
                //
                //     return Container(
                //       width: width,
                //       decoration:
                //       BoxDecoration(borderRadius: BorderRadius.circular(9)),
                //       child: DropdownSearch<String>(
                //         items: dropdownItems,
                //         dropdownDecoratorProps: DropDownDecoratorProps(
                //           dropdownSearchDecoration: InputDecoration(
                //             hintText: 'Select SQ',
                //             contentPadding: const EdgeInsets.all(8.0),
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(9),
                //             ),
                //             enabledBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(9),
                //               borderSide: BorderSide(color: Colors.grey),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(9),
                //               borderSide: BorderSide(color: Colors.grey),
                //             ),
                //             hintStyle: const TextStyle(
                //                 color: Colors.black, fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //         onChanged: (String? selectedText) async {
                //           if (selectedText != null) {
                //             final selectedId = dropdownMap[
                //             selectedText]; // Get the ID for the selected text
                //             if (selectedId != null) {
                //               setState(() {
                //                 dropdownValue = selectedId;
                //                 print(selectedId);
                //               });
                //               await qc.Quatationdetails(context, selectedId);
                //             }
                //           }
                //         },
                //         dropdownBuilder: (context, selectedItem) {
                //           return Text(
                //             selectedItem ?? 'Select Sales Quotation',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w600),
                //           );
                //         },
                //       ),
                //     );
                //   }
                // }),
                //dropdownValue != null && dropdownValue!.isNotEmpty?
                Obx(() {
                  if (qc.isLoading2.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (qc.errorMessage2.value.isNotEmpty) {
                    return Center(child: Text(qc.errorMessage2.value));
                  } else {
                    final dataList = qc.quatationdetails.value;
                    final list = dataList is Map<dynamic, dynamic> ? dataList : {};
                    final map =  list['quotation'];
                    final items = list["quotation_items"] is List<dynamic>
                        ? list["quotation_items"]
                        : [];
                    pdf_file = list['pdf_file'];
                    print(map
                    ['customer_commonname']);
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child:
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '⇢ CUSTOMER',
                                    style: TextStyle(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.info,
                                    size: 18,
                                    color: Colors.black54,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: width * 1,
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Show selected customer name and ID if available, otherwise prompt to select a customer
                                      Text(map
                                        ['customer_commonname'] ??
                                            '--',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black87),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    ' ⇢  PRODUCTS',
                                    style: TextStyle(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  // Icon(
                                  //   Icons.info,
                                  //   size: 18,
                                  //   color: Colors.black54,
                                  // )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              // Display each item in the quotation_items list
                              ...items.map((item) {

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['item_no'] ?? 'N/A',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            "💵 ${item['price'] ?? '- -'}",
                                            style: TextStyle(
                                              color: Colors.green,  // Makes both the emoji and price text green
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),

                                      Text(
                                        item['item_desc'] ?? 'No description',
                                        style: const TextStyle(color: Colors.black54),
                                      ),
                                      const SizedBox(height: 10),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Qty: ${item['quantity']?.toString() ?? '--'}',
                                            style: const TextStyle(color: Colors.black87),
                                          ),
                                          CommonRichText(
                                            label: 'GST Rate: ',
                                            value: item['gst_rate']?.toString() ?? '--',
                                          ),
                                          CommonRichText(
                                            label: 'GST Val: ',
                                            value: item['gst_value']?.toString() ?? '--',
                                          ),
                                        ],
                                      ),

                                      // GST Details

                                    ],
                                  ),


                                );
                              }).toList(),
                              Row(
                                children: [
                                  Text(
                                    '⇢ Billing Address',
                                    style: TextStyle(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  // Icon(
                                  //   Icons,
                                  //   size: 18,
                                  //   color: Colors.black54,
                                  // )
                                ],
                              ),
                              Container(
                                width: width * 1,
                                height: 50,

                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Show selected customer name and ID if available, otherwise prompt to select a customer
                                      Text(
                                    '${map["street"] ?? ""},${map["city"] ?? ""}, ${map["state"] ?? ""}, ${map["zip_code"] ?? ""}',

                                    //  (ID: $customerId)
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black87),
                                      )

                                      // "cellolar": null,
                                      // "street": null,
                                      // "city": null,
                                      // "state": null,
                                      // "country": null,
                                      // "zip_code": null,
                                      // "ship_street": null,
                                      // "ship_city": null,
                                      // "ship_state": null,
                                      // "ship_country": null,
                                      // "ship_zip_code": null

                                    ],
                                  ),

                                ),
                              ),


                  Row(
                  children: [
                  Text(
                  '⇢ Shipping Address',
                  style: TextStyle(
                  color: Colors.orange[900],
                  fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                  width: 5,
                  ),
                  // Icon(
                  //   Icons,
                  //   size: 18,
                  //   color: Colors.black54,
                  // )
                  ],
                  ),
                  Container(
                  width: width * 1,
                  height: 50,

                  padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                  // Show selected customer name and ID if available, otherwise prompt to select a customer
                  Text(
                  '${map["ship_street"] ?? ""},${map["ship_city"] ?? ""}, ${map["ship_state"] ?? ""}, ${map["ship_zip_code"] ?? ""}',

                  //  (ID: $customerId)
                  style: const TextStyle(
                  fontSize: 16, color: Colors.black87),
                  )

                  // "cellolar": null,
                  // "street": null,
                  // "city": null,
                  // "state": null,
                  // "country": null,
                  // "zip_code": null,
                  // "ship_street": null,
                  // "ship_city": null,
                  // "ship_state": null,
                  // "ship_country": null,
                  // "ship_zip_code": null

                  ],
                  ),
                  )
                  ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Code'),
                                            Text(map[
                                            "customer_code"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Payment'),
                                            Text(map[
                                            "payment_term"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'SQ-ON'),
                                            Text(map[
                                            "quotation_date"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Valid Till'),
                                            Text(map[
                                            "valid_till"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Contact To'),
                                            Text(map[
                                            "contact_name"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Cell'),
                                            Text(map[
                                            "cellolar"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),
                                        CommonRichText(
                                          label: 'Remarks: ',
                                          value: map["remarks"] ?? '- -',
                                        ),
                                        CommonRichText(
                                          label: 'Delivery Terms: ',
                                          value: map["delivery_term"] ?? '- -',
                                        ),




                                      ])
                              ),
                            ],
                          ),
                        ),

                      ],
                    );
                  }
                }),

              ]
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            GestureDetector(
              onTap: () {
                print(pdf_file);
                if (pdf_file != null && pdf_file != '') {
                  Get.to(() => pdfview(pdf: pdf_file!));
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.link_outlined,
                    color: Color(0xFFC09500),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'View PDF',
                    style: CommonWidget.commontextstyle,
                  ),
                ],
              ),
            ),



            ButtonBS(
              title: 'Place Order',
              textColor: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              width: width * 0.35,
              height: height * 0.04,
              padding: 5.0,
              backgroundColor: AppColors.blues,
              borderRadius: 12,
              suffixIcon: Icons.arrow_forward_ios,
              suffixIconColor: Colors.white,
              suffixIconSize: 18,
              prefixIconSize: 0,
              separateSuffixIcon: 5,
              onPressed: () async {},
              // final id = prefs.getInt('id');
              // if (customerId == null) {
              //   Fluttertoast.showToast(
              //     msg: "Please Select Customer",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     backgroundColor: Colors.orange.shade100,
              //     textColor: Colors.black,
              //     fontSize: 16.0,
              //   );
              //   return;
              // }
              // final body = {
              //   "customerId": customerId,
              //   "userId": id,
              //   "branch": 1
              // };
              // var response = await cartController.PostOrder(
              //     context, body, customerId!);
              // var decodedValue = response;
              //
              // if (decodedValue['success'] == true) {
              //   Fluttertoast.showToast(
              //     msg: "Your order was placed successfully",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     backgroundColor: Colors.green.shade100,
              //     textColor: Colors.black,
              //     fontSize: 16.0,
              //   );
              //   // Get.off(() => OrderPlacedScreen());
              // } else {
              //   Fluttertoast.showToast(
              //     msg: response['message'] ??
              //         "Something went wrong. Please try again.",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     backgroundColor: Colors.red.shade100,
              //     textColor: Colors.black,
              //     fontSize: 16.0,
              //   );
              // }
            )
          ]),
        ),
      ),
    );
  }
}
