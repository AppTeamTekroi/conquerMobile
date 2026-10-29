import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vconquer/features/Quatation/new_quatation_page.dart';
import 'package:vconquer/features/Quatation/quatation_controller.dart';
import 'package:vconquer/features/cart/cart_controller.dart';
import 'package:vconquer/features/orderlist/new_order_page.dart';
import 'package:vconquer/ui/richtext.dart';

import '../../ui/Buttons/buttonBS.dart';
import '../../ui/CommonWidget.dart';
import '../../ui/color/appColor.dart';
import '../Conversion/ConvertionPage.dart';
import '../Conversion/NewConversionOrder.dart';
import 'pdfview.dart';
import '../customers/customer_screen.dart';

class QuatationDetailsScreen extends StatefulWidget {
  final String? oppId;
  final String page;
  const QuatationDetailsScreen({Key? key, this.oppId = "",this.page = ""}) : super(key: key);
  @override
  State<QuatationDetailsScreen> createState() => _QuatationScreentate();
}

class _QuatationScreentate extends State<QuatationDetailsScreen> {
  QuatationController qc = Get.find();
  CartController cart = Get.find();
  String? pdf_file;
  var customerId = ''.obs;
  var status = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      qc.Quatationdetails(context, widget.oppId!,widget.page);
    });
  }
  Future<void> _launchURL(url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          (widget.page == "opportunity")? "OPPORTUNITY DETAILS":(widget.page == "quotation")?"QU0TATION DETAILS":"ORDER DETAILS",

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
                    return Container(
                      height: height,
                      child: ListView.builder(
                        itemCount: 7, // shimmer count
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Container(
                                        height: 20,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                          BorderRadius.circular(7),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 10),
                                      child: Container(
                                        height: 30,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (qc.errorMessage2.value.isNotEmpty) {
                    return Center(child: Text(qc.errorMessage2.value));
                  } else {
                    final dataList = qc.quatationdetails.value;
                   // final list = dataList is Map<dynamic, dynamic> ? dataList : {};
                    final map =  dataList['quotation'];
                    final items = dataList["quotation_items"] is List<dynamic>
                        ? dataList["quotation_items"]
                        : [];
                    pdf_file = dataList['pdf_file'];
                    if(map == null || map['customer_id'] == null){
                      return Text('Reload the page ${map['customer_id']}');
                    }
                    customerId.value = map['customer_id'].toString();
                    // if (map['status_id'] == 1) {
                    //   status = true;
                    // } else {
                    //   status = false;
                    // }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        status = (map['status_id'] == 1);
                      });
                    });
                  //  print(status);
                    // print(map);
                    // print(map['customer_id']);
                    //
                    // print('egbhrntjmkyghnbfv$customerId');
                   // print(map['quotation']['customer_commonname']);
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
                                      Text(map['customer_commonname'] ??
                                            '--',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black87),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Row(
                              //   children: [
                              //     Text(
                              //       '⇢ SALES EMPLOYEE',
                              //       style: TextStyle(
                              //           color: Colors.orange[900],
                              //           fontWeight: FontWeight.w500),
                              //     ),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     Icon(
                              //       Icons.info,
                              //       size: 18,
                              //       color: Colors.black54,
                              //     )
                              //   ],
                              // ),
                              // const SizedBox(
                              //   height: 5,
                              // ),
                              // Container(
                              //   width: width * 1,
                              //   height: 50,
                              //   padding: const EdgeInsets.symmetric(
                              //       vertical: 10, horizontal: 16),
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              //   child: SingleChildScrollView(
                              //     scrollDirection: Axis.horizontal,
                              //     child: Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         // Show selected customer name and ID if available, otherwise prompt to select a customer
                              //         Text(map
                              //         ['customer_commonname'] ??
                              //             '--',
                              //           style: const TextStyle(
                              //               fontSize: 16, color: Colors.black87),
                              //         ),
                              //
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 10),
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
                                            "💵 ${item['subtotal'] ?? '- -'}",
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
                                            'Quantity: ${item['quantity']?.toString() ?? '--'}',
                                            style: const TextStyle(color: Colors.black87),
                                          ),
                                          CommonRichText(
                                            label: 'GST: ',
                                            value: "₹${item['gst_value']?.toString() ?? '--'}",
                                          ),
                                          CommonRichText(
                                            label: 'GST: ',
                                            value: "${
                                          item['gst_rate']?.toString() ?? '--'
                                        }%",
                                          ),

                                        ],
                                      ),

                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //
                                      //
                                      //
                                      //   ],
                                      // ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text(
                                          //   'UOM: ${item['uom_code']?.toString() ?? '--'}',
                                          //   style: const TextStyle(color: Colors.black87),
                                          // ),
                                          CommonRichText(
                                            label: 'Unit: ',
                                            value: item['price']?.toString() ?? '--',
                                          ),
                                          Text(
                                            'Disc: ₹${item['disc_value']?.toString() ?? '--'}',
                                            style: const TextStyle(color: Colors.black87),
                                          ),

                                          CommonRichText(
                                            label: 'Disc: ',
                                            value: '${
                                              item['disc_percent']?.toString() ?? '--'
                                            }%'
                                          ),
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          CommonRichText(
                                            label: 'Price Af Disc: ',
                                            value: item['price_af_disc']?.toString() ?? '--',
                                          ),
                                          CommonRichText(
                                            label: 'Price Total Af Disc: ',
                                            value: item['price_total_af_disc']?.toString() ?? '--',
                                          ),
                                        ],
                                      ),

                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(
                                      //       'Subtotal: ${item['subtotal']?.toString() ?? '--'}',
                                      //       style: const TextStyle(color: Colors.black87),
                                      //     ),
                                      //     CommonRichText(
                                      //       label: 'GST Rate: ',
                                      //       value: item['gst_rate']?.toString() ?? '--',
                                      //     ),
                                      //     CommonRichText(
                                      //       label: 'GST Val: ',
                                      //       value: item['gst_value']?.toString() ?? '--',
                                      //     ),
                                      //   ],
                                      // ),

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
                              //  height: 50,

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
                                    '${map["street"] ?? ""},${map["city"] ?? ""}, ${map["state"] ?? ""},${map["country"] ?? ""}, ${map["zip_code"] ?? ""}',

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
                 // height: 50,

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
                  '${(map["ship_street"]) ?? ""},${map["ship_city"] ?? ""}, ${map["ship_state"] ?? ""},${map["ship_country"] ?? ""}, ${map["ship_zip_code"] ?? ""}',

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
                              Row(
                                children: [
                                  Text(
                                    '⇢ Sales Form',
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
                              ),                              Container(
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
                                        if(map["quotation_no_prefix"] !=null)

                                          Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Quotation'),
                                            Text(map[
                                            "quotation_no_prefix"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),
                                        if(map["opportunity_no_prefix"] !=null)
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Opportunity'),
                                            Text(map[
                                            "opportunity_no_prefix"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),

                                        if(map["payment_term"] !=null)

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
                                        ),

                                        if(map["quotation_date"] !=null)

                                          Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'SQ Date'),
                                            Text(map[
                                            "quotation_date"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),
                                        if(map["opportunity_date"] !=null)

                                          Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'OP Date'),
                                            Text(map[
                                            "opportunity_date"] ??
                                                '- -'
                                                    .toString()),
                                          ],
                                        ),
                                        if(map["valid_till"] !=null)

                                        Row(
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
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                                'Freight'),
                                            Text(map[
                                            "freight"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Freight: ',
                                            //   value: map["freight"] ?? '- -',
                                            // ),
                                          ],
                                        ),
                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Validity'),
                                            Text(map[
                                            "validity"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Validity: ',
                                            //   value: map["validity"] ?? '- -',
                                            // ),
                                          ],
                                        ), Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Opportunity Name'),
                                            Text(map[
                                            "opportunity_name"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Opportunity Name: ',
                                            //   value: map["opportunity_name"] ?? '- -',
                                            // ),
                                          ],
                                        ), Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Opportunity Type'),
                                            Text(map[
                                            "opportunity_type"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Opportunity Type: ',
                                            //   value: map["opportunity_type"] ?? '- -',
                                            // ),
                                          ],
                                        ), Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Opportunity Renewal'),
                                            Text(map[
                                            "opportunity_renewal"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Opportunity Opportunity: ',
                                            //   value: map["opportunity_renewal"] ?? '- -',
                                            // ),
                                          ],
                                        ), Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Opportunity Subtype'),
                                            Text(map[
                                            "opportunity_subtype"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Opportunity Opportunity: ',
                                            //   value: map["opportunity_subtype"] ?? '- -',
                                            // ),
                                          ],
                                        ),
                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Warranty'),
                                            Text(map[
                                            "warranty"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Warranty: ',
                                            //   value: map["Warranty"] ?? '- -',
                                            // ),
                                          ],
                                        ),
                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'TAX'),
                                            Text(map[
                                            "tax"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'TAX: ',
                                            //   value: map["tax"] ?? '- -',
                                            // ),
                                          ],
                                        ), Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Delivery'),
                                            Text(map[
                                            "delivery"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),
                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Contact Name'),
                                            Text(map[
                                            "contact_name"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Company Address'),
                                            Text(map[
                                            "companyaddress"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Company Name'),
                                            Text(map[
                                            "companyname"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),


                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Approval Require'),
                                            Text(map[
                                            "approval_require"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Sap Doc Entry'),
                                            Text(map[
                                            "sap_doc_entry"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Sap Doc Number'),
                                            Text(map[
                                            "sap_doc_number"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Sap Inv Number'),
                                            Text(map[
                                            "sap_inv_number"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Approval Draft Docentry'),
                                            Text((map["approval_draft_docentry"] ?? '- -').toString()),
                                            // // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Approval Draft DocNumber'),
                                            Text((map["approval_draft_docnum"] ?? '- -').toString()),
                                            // // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Approval Draft DocNumber'),
                                            Text((map[
                                            "approval_draft_docnum"] ??
                                                '- -')
                                                    .toString()),
                                            // // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),
                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Q-Status'),
                                            Text(map[
                                            "qstatus"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                        // Row(mainAxisAlignment:
                                        // MainAxisAlignment
                                        //     .spaceBetween,
                                        //   children: [
                                        //     const Text(
                                        //         'Opportunity Id'),
                                        //     Text(map[
                                        //     "opportunity_id"] ??
                                        //         '- -'
                                        //             .toString()),
                                        //     // CommonRichText(
                                        //     //   label: 'Delivery: ',
                                        //     //   value: map["delivery"] ?? '- -',
                                        //     // ),
                                        //   ],
                                        // ),

                                        Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Payment Term'),
                                            Text(map[
                                            "payment_term"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Quotation Date'),
                                            Text(map[
                                            "quotation_date"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Valid Till'),
                                            Text(map[
                                            "valid_till"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),
                                       Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Freight'),
                                            Text(map[
                                            "freight"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Validity'),
                                            Text(map[
                                            "validity"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Other Term Condition'),
                                            Text(map[
                                            "other_term_condition"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Quotation No Prefix'),
                                            Text(map[
                                            "quotation_no_prefix"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),


                                      Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Total Quantity'),
                                            Text((map[
                                            "total_quantity"] ?? '- -').toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

                                      Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Total After Disc'),
                                            Text((map[
                                            "total_after_disc"] ??
                                                '- -'
                                                    ).toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Total Tax Value'),
                                            Text((map[
                                            "total_tax_value"] ??
                                                '- -'
                                                    ).toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Total Amount'),
                                            Text((map[
                                            "total_amount"] ??
                                                '- -'
                                                    ).toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Sales Emp Name'),
                                            Text(map[
                                            "sales_emp_name"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),



Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Delivery Term'),
                                            Text(map[
                                            "delivery_term"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Warranty'),
                                            Text(map[
                                            "warranty"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),

Row(mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                          children: [
                                            const Text(
                                                'Tax'),
                                            Text(map[
                                            "tax"] ??
                                                '- -'
                                                    .toString()),
                                            // CommonRichText(
                                            //   label: 'Delivery: ',
                                            //   value: map["delivery"] ?? '- -',
                                            // ),
                                          ],
                                        ),


                                        // Row(mainAxisAlignment:
                                        // MainAxisAlignment
                                        //     .spaceBetween,
                                        //   children: [
                                        //     const Text(
                                        //         'Attachements'),
                                        //     Text(map[
                                        //     "attachements"] ??
                                        //         '- -'
                                        //             .toString()),
                                        //     // CommonRichText(
                                        //     //   label: 'Delivery: ',
                                        //     //   value: map["delivery"] ?? '- -',
                                        //     // ),
                                        //   ],
                                        // ),
                                  SizedBox(height: 20,),
                                      if (map["attachements"] != null)
                                        GestureDetector(
                                          onTap: () {

                                            if (map[
                                            "attachements"] != null && map[
                                            "attachements"] != '') {
                                              _launchURL(map[
                                              "attachements"]);
                                            }
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.file_copy_outlined,
                                                color: Color(0xFFC09500),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'View Attachments',
                                                style: CommonWidget.commontextstyle,
                                              ),
                                            ],
                                          ),
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

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











          (widget.page == 'order')
              ? const Text('Waiting for order update')
              :(status) ?
               ButtonBS(
                title: (widget.page == "opportunity")
                    ? "Convert to Quotation"
                    : "Convert to Orders",
                textColor: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                width: width * 0.5,
                height: height * 0.04,
                padding: 5.0,
                borderRadius: 12,
                suffixIcon: Icons.arrow_forward_ios,
                suffixIconColor: Colors.green,
                suffixIconSize: 18,
                prefixIconSize: 0,
                separateSuffixIcon: 5,
                bordercolor: Colors.green,
                onPressed: () async {
                  if (widget.oppId == null || customerId.value == null) {
                    Fluttertoast.showToast(msg: "Invalid data, please try again.");
                    return;
                  }
                  String conversionType =
                  (widget.page == "opportunity") ? "coq" : "cqo";
                  var response = await cart.ConvertOQ_QO(
                      context, widget.oppId!, customerId.value, conversionType);

                  if (response['success'] == true) {
                    Get.to(() => (widget.page == "opportunity")
                        ? NewConversionScreen(
                        oppId: '${widget.oppId}',
                        page: 'coq',
                        customerid: customerId.value)
                        : NewConversionOrderScreen(
                        quotationId: '${widget.oppId}',
                        page: 'cqo',
                        customerid: customerId.value));
                  } else {
                    Fluttertoast.showToast(
                      msg: response['message'] ??
                          "Something went wrong while Converting, Please try again.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red.shade100,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                  }
                },
              ):ButtonBS(
                title: 'Closed',
                textColor: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                width: width * 0.47,
                height: height * 0.04,
                padding: 5.0,
                borderRadius: 12,
                suffixIcon: Icons.closed_caption_disabled,
                suffixIconColor: Colors.red,
                suffixIconSize: 18,
                prefixIconSize: 0,
                separateSuffixIcon: 5,
                bordercolor: Colors.red,
              ),

               // // Obx(() {
               //    if (widget.page == 'order')
               //       Text('Waiting for order update'),
               //
               //    if (status.value == 1 && widget.page != 'order')
               //       ButtonBS(
               //          title:
               //          (widget.page == "opportunity")
               //              ? "Convert to Quotation"
               //              : "Convert to Orders",
               //          textColor: Colors.green,
               //          fontSize: 15,
               //          fontWeight: FontWeight.w600,
               //          width: width * 0.47,
               //          height: height * 0.04,
               //          padding: 5.0,
               //          // backgroundColor: AppColors.blues,
               //          borderRadius: 12,
               //          suffixIcon: Icons.arrow_forward_ios,
               //          suffixIconColor: Colors.green,
               //          suffixIconSize: 18,
               //          prefixIconSize: 0,
               //          separateSuffixIcon: 5,
               //          bordercolor: Colors.green,
               //          onPressed: () async {
               //            if (widget.page == "opportunity") {
               //              var response = await cart.ConvertOQ_QO(
               //                  context, widget.oppId!, customerId.value, 'coq');
               //              var decodedValue = response;
               //              //  var decodedValue = cart.response.value;
               //              print('$decodedValue');
               //              if (decodedValue['success'] == true) {
               //                Get.to(() =>
               //                    NewConversionScreen(oppId: '${widget.oppId}',
               //                        page: 'coq',
               //                        customerid: customerId.value));
               //              } else {
               //                Fluttertoast.showToast(
               //                  msg: response['message'] ??
               //                      "Something went wrong while Converting, Please try again.",
               //                  toastLength: Toast.LENGTH_SHORT,
               //                  gravity: ToastGravity.CENTER,
               //                  backgroundColor: Colors.red.shade100,
               //                  textColor: Colors.black,
               //                  fontSize: 16.0,
               //                );
               //              }
               //            }
               //            else {
               //              var response = await cart.ConvertOQ_QO(
               //                  context, widget.oppId!, customerId.value, 'cqo');
               //              print('innnnnnnn$response');
               //
               //              var decodedValue = response;
               //              print('$decodedValue');
               //              if (decodedValue['success'] == true) {
               //                Get.to(() =>
               //                    NewConversionOrderScreen(
               //                        quotationId: '${widget.oppId}',
               //                        page: 'cqo',
               //                        customerid: customerId.value));
               //              } else {
               //                Fluttertoast.showToast(
               //                  msg: response['message'] ??
               //                      "Something went wrong while Converting, Please try again.",
               //                  toastLength: Toast.LENGTH_SHORT,
               //                  gravity: ToastGravity.CENTER,
               //                  backgroundColor: Colors.red.shade100,
               //                  textColor: Colors.black,
               //                  fontSize: 16.0,
               //                );
               //              }
               //              //  Get.to(NewOrderScreen());
               //            }
               //          }
               //      ),
               //
               //
               //    if (status.value == 2)
               //       ButtonBS(
               //        title: 'Closed',
               //        textColor: Colors.red,
               //        fontSize: 15,
               //        fontWeight: FontWeight.w600,
               //        width: width * 0.47,
               //        height: height * 0.04,
               //        padding: 5.0,
               //        // backgroundColor: AppColors.blues,
               //        borderRadius: 12,
               //        suffixIcon: Icons.closed_caption_disabled,
               //        suffixIconColor: Colors.red,
               //        suffixIconSize: 18,
               //        prefixIconSize: 0,
               //        separateSuffixIcon: 5,
               //        bordercolor: Colors.red,
               //      )

            //    }
              //  ),
    //     Obx(() {
    //       if (widget.page != 'order') {
    //         return Text('Waiting for order update');
    //       }
    //       if (status.value == 1) {
    //         return ButtonBS(
    //             title:
    //             (widget.page == "opportunity")
    //                 ? "Convert to Quotation"
    //                 : "Convert to Orders",
    //             textColor: Colors.green,
    //             fontSize: 15,
    //             fontWeight: FontWeight.w600,
    //             width: width * 0.47,
    //             height: height * 0.04,
    //             padding: 5.0,
    //             // backgroundColor: AppColors.blues,
    //             borderRadius: 12,
    //             suffixIcon: Icons.arrow_forward_ios,
    //             suffixIconColor: Colors.green,
    //             suffixIconSize: 18,
    //             prefixIconSize: 0,
    //             separateSuffixIcon: 5,
    //             bordercolor: Colors.green,
    //             onPressed: () async {
    //               if (widget.page == "opportunity") {
    //                 var response = await cart.ConvertOQ_QO(
    //                     context, widget.oppId!, customerId.value, 'coq');
    //                 var decodedValue = response;
    //                 //  var decodedValue = cart.response.value;
    //                 print('$decodedValue');
    //                 if (decodedValue['success'] == true) {
    //                   Get.to(() =>
    //                       NewConversionScreen(oppId: '${widget.oppId}',
    //                           page: 'coq',
    //                           customerid: customerId.value));
    //                 } else {
    //                   Fluttertoast.showToast(
    //                     msg: response['message'] ??
    //                         "Something went wrong while Converting, Please try again.",
    //                     toastLength: Toast.LENGTH_SHORT,
    //                     gravity: ToastGravity.CENTER,
    //                     backgroundColor: Colors.red.shade100,
    //                     textColor: Colors.black,
    //                     fontSize: 16.0,
    //                   );
    //                 }
    //               }
    //               else {
    //                 var response = await cart.ConvertOQ_QO(
    //                     context, widget.oppId!, customerId.value, 'cqo');
    //                 print('innnnnnnn$response');
    //
    //                 var decodedValue = response;
    //                 print('$decodedValue');
    //                 if (decodedValue['success'] == true) {
    //                   Get.to(() =>
    //                       NewConversionOrderScreen(
    //                           quotationId: '${widget.oppId}',
    //                           page: 'cqo',
    //                           customerid: customerId.value));
    //                 } else {
    //                   Fluttertoast.showToast(
    //                     msg: response['message'] ??
    //                         "Something went wrong while Converting, Please try again.",
    //                     toastLength: Toast.LENGTH_SHORT,
    //                     gravity: ToastGravity.CENTER,
    //                     backgroundColor: Colors.red.shade100,
    //                     textColor: Colors.black,
    //                     fontSize: 16.0,
    //                   );
    //                 }
    //                 //  Get.to(NewOrderScreen());
    //               }
    //             }
    //         );
    //       }
    //
    // if (status.value == 2) {
    //   return ButtonBS(
    //     title: 'Closed',
    //     textColor: Colors.red,
    //     fontSize: 15,
    //     fontWeight: FontWeight.w600,
    //     width: width * 0.47,
    //     height: height * 0.04,
    //     padding: 5.0,
    //     // backgroundColor: AppColors.blues,
    //     borderRadius: 12,
    //     suffixIcon: Icons.closed_caption_disabled,
    //     suffixIconColor: Colors.red,
    //     suffixIconSize: 18,
    //     prefixIconSize: 0,
    //     separateSuffixIcon: 5,
    //     bordercolor: Colors.red,
    //   );
    // }
    // return Text('Something Wronmg');
    //     }
    // ),


                //   if (widget.page == 'order') {
                //     return const Text('Waiting for order update');
                //   }
                //
                //   if (status.value != 1) {
                //     return ButtonBS(
                //       title: 'Closed',
                //       textColor: Colors.red,
                //       fontSize: 15,
                //       fontWeight: FontWeight.w600,
                //       width: width * 0.47,
                //       height: height * 0.04,
                //       padding: 5.0,
                //       borderRadius: 12,
                //       suffixIcon: Icons.closed_caption_disabled,
                //       suffixIconColor: Colors.red,
                //       suffixIconSize: 18,
                //       prefixIconSize: 0,
                //       separateSuffixIcon: 5,
                //       bordercolor: Colors.red,
                //     );
                //   }
                //
                //   return ButtonBS(
                //     title: (widget.page == "opportunity") ? "Convert to Quotation" : "Convert to Orders",
                //     textColor: Colors.green,
                //     fontSize: 15,
                //     fontWeight: FontWeight.w600,
                //     width: width * 0.47,
                //     height: height * 0.04,
                //     padding: 5.0,
                //     borderRadius: 12,
                //     suffixIcon: Icons.arrow_forward_ios,
                //     suffixIconColor: Colors.green,
                //     suffixIconSize: 18,
                //     prefixIconSize: 0,
                //     separateSuffixIcon: 5,
                //     bordercolor: Colors.green,
                //     onPressed: () async {
                //       if (widget.oppId == null || customerId.value == null) {
                //         Fluttertoast.showToast(msg: "Invalid data, please try again.");
                //         return;
                //       }
                //
                //       String conversionType = (widget.page == "opportunity") ? "coq" : "cqo";
                //       var response = await cart.ConvertOQ_QO(context, widget.oppId!, customerId.value, conversionType);
                //
                //       if (response['success'] == true) {
                //         Get.to(() => (widget.page == "opportunity")
                //             ? NewConversionScreen(oppId: '${widget.oppId}', page: 'coq', customerid: customerId.value)
                //             : NewConversionOrderScreen(quotationId: '${widget.oppId}', page: 'cqo', customerid: customerId.value));
                //       } else {
                //         Fluttertoast.showToast(
                //           msg: response['message'] ?? "Something went wrong while converting, Please try again.",
                //           toastLength: Toast.LENGTH_SHORT,
                //           gravity: ToastGravity.CENTER,
                //           backgroundColor: Colors.red.shade100,
                //           textColor: Colors.black,
                //           fontSize: 16.0,
                //         );
                //       }
                //     },
                //   );
                // })


              ]
          )
        ),
      ),
    );
  }
}
