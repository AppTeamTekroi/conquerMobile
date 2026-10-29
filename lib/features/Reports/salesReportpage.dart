import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vconquer/features/Quatation/new_quatation_page.dart';
import 'package:vconquer/features/Quatation/quatation_controller.dart';
import 'package:vconquer/features/Quatation/quatation_details.dart';
import 'package:vconquer/features/Reports/report_controller.dart';
import 'package:vconquer/features/navBar.dart';

import '../../ui/color/appColor.dart';
import '../../ui/richtext.dart';
import '../orderlist/order_controller.dart';

class ReportListScreen extends StatefulWidget {
  ReportListScreen({
    super.key,
  });
  @override
  State<ReportListScreen> createState() => _QuatationListScreentate();
}

class _QuatationListScreentate extends State<ReportListScreen> {
  //OrderPlacedController oc = Get.put(OrderPlacedController());
  ReportController qc = Get.find();
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final ScrollController _scrollController = ScrollController();

  var totalrecords = "0".obs;
  var filterrecords = '0'.obs;
  var saleAmount = "".obs;
  var sales_employee = "".obs;
  var lineAmount = "₹0.00".obs;
  bool showConsolation = false;
//₹0.00
  @override
  void initState() {

    super.initState();
    qc.searchQuery.value = '';
    // dropdownValue = list.first;

    // _fetchData();
    _scrollController.addListener(_scrollListener); // ADD THIS LINE

  }

  Future<void> _fetchData() async {
    await qc.Reportlist(context,dropdownValue!);

    // switch (dropdownValue) {
    //   case 'Sales Report':
    //     await qc.Reportlist(context,dropdownValue);
    //     print("Sales Report selected");
    //     break;
    //
    //   // case 'Opportunity Report':
    //   //   await qc.Reportlist(context,dropdownValue);
    //   //   print("Opportunity Report selected");
    //   //   break;
    //
    //   case 'Consolation Report':
    //     await qc.Reportlist(context,dropdownValue);
    //     print("Consolation Report selected");
    //     break;
    //
    //   // case 'CT Report':
    //   //   await qc.Reportlist(context,dropdownValue);
    //   //   print("CT Report selected");
    //   //   break;
    //
    //   default:
    //   // Handle unexpected value
    //     print("Unknown report selected");
    // }


    // await qc.Reportlist(context);
    final list = qc.reportlist.value;

    if (list is Map) {
      totalrecords.value = (list['recordsTotal'] ?? 0).toString();
      filterrecords.value = (list['recordsFiltered'] ?? 0).toString();
      var value = list['Sales_return'];
      saleAmount.value = value != null ? double.parse(value.toString()).toStringAsFixed(2) : '';
      lineAmount.value = (list['line_total'].toStringAsFixed(2));


      // recordsFiltered
      // If total amount is returned from the API
      // final amount = list['totalAmount']; // Adjust key if different
      // if (amount != null) {
      //   lineAmount.value = "₹${amount.toStringAsFixed(2)}"; // format as needed
      // }
    }
  }
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !qc.isLoadingMore.value &&
        !qc.isLastPage.value) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    await qc.Reportlist(context, dropdownValue!, isPagination: true);
  }

  List<String> list = <String>['Sales Report','Consolation Report' ];

   String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          // backgroundColor: AppColors.blues,
          backgroundColor:Colors.white54,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                hint: Text('Select Report'),
                style: const TextStyle(color: Colors.black),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                     _fetchData();
                  });
                },
                items: list.map<DropdownMenuItem<String>>(
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
            //   Text(
            //     "Sales Reports",
            //     style: TextStyle(
            //       fontSize: 18,
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // Icon(Icons.arrow_drop_down_sharp,color: Colors.white,)
            ],
          ),
          leading: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios,color: Colors.black,)),

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
                  Obx(()=> SizedBox(
                    height: height * 0.08,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if(saleAmount.value != '')
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sale Return',
                                style: TextStyle(
                                    color:
                                    Color.fromARGB(255, 147, 147, 147)),
                              ),
                              Text(
                                saleAmount.value,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Line Total',
                                style: TextStyle(
                                    color:
                                    Color.fromARGB(255, 147, 147, 147)),
                              ),
                              Text(
                                lineAmount.value,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Records',
                                  style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 147, 147, 147))),
                              Text(
                                totalrecords.value,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          // const Spacer(),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     const Text(
                          //       'UnApproved',
                          //       style: TextStyle(
                          //           color:
                          //           Color.fromARGB(255, 147, 147, 147)),
                          //     ),
                          //     Text(
                          //       filterrecords,
                          //       style: TextStyle(
                          //           fontSize: height * 0.025,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),

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
              return const Center(child: CircularProgressIndicator());
            } else if (qc.errorMessage.value.isNotEmpty) {
              return Center(child: Text(qc.errorMessage.value));
            } else {
              if (qc.filteredcust.isEmpty) {
                return Center(
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                  qc.filteredcust.length + (qc.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == qc.filteredcust.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final item = qc.filteredcust[index];
                    return  Padding(
                      padding:  EdgeInsets.symmetric(vertical: 5,horizontal: Get.height * 0.015),
                      child:InkWell(
                        onTap: () {
                          print('Order Card Pressed');

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         QuatationDetailsScreen(oppId: (item['id']).toString(),page: 'quotation',),
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
                              child:

                              (dropdownValue == 'Consolation Report')?
                              consolationReturn(item):
                                SalesReturn(item)
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text(
                              //           'Doc No: ${item["DocNo"]}',
                              //           //  "Doc No: ${item["id"]}",
                              //           style: TextStyle(
                              //               fontSize: 15,
                              //               fontWeight: FontWeight.w500,
                              //               color: AppColors.blues),
                              //         ),
                              //         Text(
                              //           "Whs: ${item["WhsCode"]}",
                              //           style: TextStyle(
                              //               fontSize: 15,
                              //               fontWeight: FontWeight.w500,
                              //               color: AppColors.blues),
                              //         ),
                              //         // Container(
                              //         //   height: height * 0.020,
                              //         //   width: width * 0.2,
                              //         //   decoration: BoxDecoration(
                              //         //       color: item['status_id'] == 1?
                              //         //       Color.fromARGB(255, 255, 232, 157):
                              //         //       Color(0Xff30CB00),
                              //         //       borderRadius: BorderRadius.only(
                              //         //           topRight: Radius.circular(20),
                              //         //           bottomLeft: Radius.circular(10))),
                              //         //   child: Center(
                              //         //     child:
                              //         //
                              //         //     Text(item['status_id'] == 1 ? 'Open' : 'Close',
                              //         //         style: TextStyle(
                              //         //             fontSize: height * 0.009,
                              //         //             color: item['status_id'] == 1 ?Colors.red:Colors.white,
                              //         //             fontWeight: FontWeight.bold)),
                              //         //     // Text(
                              //         //     //     item['status_name'] ?? '- -',
                              //         //     //     style: TextStyle(
                              //         //     //         fontSize: height * 0.009,
                              //         //     //         color: item['status_id'] == 1?Colors.red:Colors.white,
                              //         //     //         fontWeight: FontWeight.bold)),
                              //         //   ),
                              //         // ),
                              //
                              //       ],
                              //     ),
                              //     // CommonRichText(
                              //     //   label: 'Doc No: ',
                              //     //   value: item["doc_no"] ?? '- -',
                              //     // ),
                              //     // GestureDetector(
                              //     //   onTap: () async {
                              //     //     // await customerController.fetchUserID(
                              //     //     //     context,
                              //     //     //     itemId); // Fetch the details
                              //     //     // Get.to(() => CustomerEditscreen());
                              //     //   },
                              //     //   child: Row(
                              //     //     children: [
                              //     //       // Text(
                              //     //       //   "Edit",
                              //     //       //   style: TextStyle(
                              //     //       //       fontSize: 14,
                              //     //       //       // fontWeight: FontWeight.w500,
                              //     //       //       color: AppColors.blues),
                              //     //       // ),
                              //     //       // Icon(
                              //     //       //   Icons.edit,
                              //     //       //   color: AppColors.blues,
                              //     //       //   size: 14,
                              //     //       // )
                              //     //     ],
                              //     //   ),
                              //     // )
                              //
                              //     Divider(),
                              //
                              //
                              //     CommonRichText(
                              //       label: 'Card Name: ',
                              //       value: item["customer_commonname"] ?? '',
                              //     ),
                              //
                              //
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'Doc Date'),
                              //         Text(item[
                              //         "DocDate"] ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'Quantity'),
                              //         Text((item[
                              //         "Quantity"]).toString() ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'Price'),
                              //         Text((item[
                              //         "Price"]).toString() ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'LineTotal'),
                              //         Text((item[
                              //         "LineTotal"]).toString() ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'AcctCode'),
                              //         Text(item[
                              //         "AcctCode"] ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'GroupName-Code'),
                              //         Text('${item["GroupCode"] ?? '- -'}-${item["GroupName"] ?? '- -'}'),
                              //
                              //
                              //       ],
                              //     ),
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'Term'),
                              //         Text(item[
                              //         "payment_term"] ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'Type'),
                              //         Text(item[
                              //         "Type"] ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment
                              //           .spaceBetween,
                              //       children: [
                              //         const Text(
                              //             'NumAtCard'),
                              //         Text((item[
                              //         "NumAtCard"]).toString() ?? '- -'
                              //
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //     // Row(
                              //     //   mainAxisAlignment:
                              //     //   MainAxisAlignment
                              //     //       .spaceBetween,
                              //     //   children: [
                              //     //     const Text(
                              //     //         'Placed By'),
                              //     //     Text((item[
                              //     //     "user_name"]) ?? '- -',style: TextStyle(color: Colors.blue[900]),
                              //     //
                              //     //     ),
                              //     //
                              //     //
                              //     //   ],
                              //     // ),
                              //     Text(item[
                              //     "Dscription"] ?? '- -'
                              //
                              //     ),
                              //     // Row(
                              //     //   mainAxisAlignment:
                              //     //   MainAxisAlignment.spaceBetween,
                              //     //   children: [
                              //     //     // CommonRichText(
                              //     //     //   label: 'Sales Emp: ',
                              //     //     //   value: item["sales_emp_name"] ?? '- -',
                              //     //     // ),
                              //     //
                              //     //     Text(
                              //     //       "📞 ${item["contact_id"] ?? '- -'}",
                              //     //       style: TextStyle(
                              //     //         fontSize: 14,
                              //     //         color: Colors.green[900],
                              //     //       ),
                              //     //     ),
                              //
                              //     // CommonRichText(
                              //     //   label: 'Term: ',
                              //     //   value: item["payment_term"] ?? '- -',
                              //     // ),
                              //     // CommonRichText(
                              //     //   label: 'Remarks: ',
                              //     //   value: item["remarks"] ?? '- -',
                              //     // ),
                              //     // CommonRichText(
                              //     //   label: 'Tax: ',
                              //     //   value: item["taxes"] ?? '- -',
                              //     // ),
                              //
                              //     // GestureDetector(
                              //     //   onTap: () {},
                              //     //   child: Row(
                              //     //     children: [
                              //     //       Text(
                              //     //         "Details",
                              //     //         style: TextStyle(
                              //     //             fontSize: 14,
                              //     //             // fontWeight: FontWeight.w500,
                              //     //             color: Colors.grey),
                              //     //       ),
                              //     //       Icon(
                              //     //         Icons.arrow_forward_ios_outlined,
                              //     //         color: Colors.grey,
                              //     //         size: 14,
                              //     //       )
                              //     //     ],
                              //     //   ),
                              //     // )
                              //
                              //   ],
                              // ),
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


  Widget SalesReturn(item,){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Doc No: ${item["DocNo"]}',
              //  "Doc No: ${item["id"]}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blues),
            ),
            Text(
              "Whs: ${item["WhsCode"]}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blues),
            ),
            // Container(
            //   height: height * 0.020,
            //   width: width * 0.2,
            //   decoration: BoxDecoration(
            //       color: item['status_id'] == 1?
            //       Color.fromARGB(255, 255, 232, 157):
            //       Color(0Xff30CB00),
            //       borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(20),
            //           bottomLeft: Radius.circular(10))),
            //   child: Center(
            //     child:
            //
            //     Text(item['status_id'] == 1 ? 'Open' : 'Close',
            //         style: TextStyle(
            //             fontSize: height * 0.009,
            //             color: item['status_id'] == 1 ?Colors.red:Colors.white,
            //             fontWeight: FontWeight.bold)),
            //     // Text(
            //     //     item['status_name'] ?? '- -',
            //     //     style: TextStyle(
            //     //         fontSize: height * 0.009,
            //     //         color: item['status_id'] == 1?Colors.red:Colors.white,
            //     //         fontWeight: FontWeight.bold)),
            //   ),
            // ),

          ],
        ),
        // CommonRichText(
        //   label: 'Doc No: ',
        //   value: item["doc_no"] ?? '- -',
        // ),
        // GestureDetector(
        //   onTap: () async {
        //     // await customerController.fetchUserID(
        //     //     context,
        //     //     itemId); // Fetch the details
        //     // Get.to(() => CustomerEditscreen());
        //   },
        //   child: Row(
        //     children: [
        //       // Text(
        //       //   "Edit",
        //       //   style: TextStyle(
        //       //       fontSize: 14,
        //       //       // fontWeight: FontWeight.w500,
        //       //       color: AppColors.blues),
        //       // ),
        //       // Icon(
        //       //   Icons.edit,
        //       //   color: AppColors.blues,
        //       //   size: 14,
        //       // )
        //     ],
        //   ),
        // )

        Divider(),


        CommonRichText(
          label: 'Card Name: ',
          value: item["customer_commonname"] ?? '',
        ),


        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'Doc Date'),
            Text(item[
            "DocDate"] ?? '- -'

            ),


          ],
        ),

        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'Quantity'),
            Text((item[
            "Quantity"]).toString() ?? '- -'

            ),


          ],
        ),
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'Price'),
            Text((item[
            "Price"]).toString() ?? '- -'

            ),


          ],
        ),
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'LineTotal'),
            Text((item[
            "LineTotal"]).toString() ?? '- -'

            ),


          ],
        ),
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'AcctCode'),
            Text(item[
            "AcctCode"] ?? '- -'

            ),


          ],
        ),

        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'GroupName-Code'),
            Text('${item["GroupCode"] ?? '- -'}-${item["GroupName"] ?? '- -'}'),


          ],
        ),
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'Term'),
            Text(item[
            "payment_term"] ?? '- -'

            ),


          ],
        ),
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'Type'),
            Text(item[
            "Type"] ?? '- -'

            ),


          ],
        ),
        Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            const Text(
                'NumAtCard'),
            Expanded(
              child: Text((item[
              "NumAtCard"]).toString() ?? '- -'

              ),
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment:
        //   MainAxisAlignment
        //       .spaceBetween,
        //   children: [
        //     const Text(
        //         'Placed By'),
        //     Text((item[
        //     "user_name"]) ?? '- -',style: TextStyle(color: Colors.blue[900]),
        //
        //     ),
        //
        //
        //   ],
        // ),
        Text(item[
        "Dscription"] ?? '- -'

        ),
        // Row(
        //   mainAxisAlignment:
        //   MainAxisAlignment.spaceBetween,
        //   children: [
        //     // CommonRichText(
        //     //   label: 'Sales Emp: ',
        //     //   value: item["sales_emp_name"] ?? '- -',
        //     // ),
        //
        //     Text(
        //       "📞 ${item["contact_id"] ?? '- -'}",
        //       style: TextStyle(
        //         fontSize: 14,
        //         color: Colors.green[900],
        //       ),
        //     ),

        // CommonRichText(
        //   label: 'Term: ',
        //   value: item["payment_term"] ?? '- -',
        // ),
        // CommonRichText(
        //   label: 'Remarks: ',
        //   value: item["remarks"] ?? '- -',
        // ),
        // CommonRichText(
        //   label: 'Tax: ',
        //   value: item["taxes"] ?? '- -',
        // ),

        // GestureDetector(
        //   onTap: () {},
        //   child: Row(
        //     children: [
        //       Text(
        //         "Details",
        //         style: TextStyle(
        //             fontSize: 14,
        //             // fontWeight: FontWeight.w500,
        //             color: Colors.grey),
        //       ),
        //       Icon(
        //         Icons.arrow_forward_ios_outlined,
        //         color: Colors.grey,
        //         size: 14,
        //       )
        //     ],
        //   ),
        // )

      ],
    );
  }
  Widget consolationReturn(item,){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Doc No: ${item["DocNum"]}',
              //  "Doc No: ${item["id"]}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blues),
            ),
            Text(
              item['Type'],
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blues),
            ),
            
            // Container(
            //   height: height * 0.020,
            //   width: width * 0.2,
            //   decoration: BoxDecoration(
            //       color: item['status_id'] == 1?
            //       Color.fromARGB(255, 255, 232, 157):
            //       Color(0Xff30CB00),
            //       borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(20),
            //           bottomLeft: Radius.circular(10))),
            //   child: Center(
            //     child:
            //
            //     Text(item['status_id'] == 1 ? 'Open' : 'Close',
            //         style: TextStyle(
            //             fontSize: height * 0.009,
            //             color: item['status_id'] == 1 ?Colors.red:Colors.white,
            //             fontWeight: FontWeight.bold)),
            //     // Text(
            //     //     item['status_name'] ?? '- -',
            //     //     style: TextStyle(
            //     //         fontSize: height * 0.009,
            //     //         color: item['status_id'] == 1?Colors.red:Colors.white,
            //     //         fontWeight: FontWeight.bold)),
            //   ),
            // ),

          ],
        ),
        // CommonRichText(
        //   label: 'Doc No: ',
        //   value: item["doc_no"] ?? '- -',
        // ),
        // GestureDetector(
        //   onTap: () async {
        //     // await customerController.fetchUserID(
        //     //     context,
        //     //     itemId); // Fetch the details
        //     // Get.to(() => CustomerEditscreen());
        //   },
        //   child: Row(
        //     children: [
        //       // Text(
        //       //   "Edit",
        //       //   style: TextStyle(
        //       //       fontSize: 14,
        //       //       // fontWeight: FontWeight.w500,
        //       //       color: AppColors.blues),
        //       // ),
        //       // Icon(
        //       //   Icons.edit,
        //       //   color: AppColors.blues,
        //       //   size: 14,
        //       // )
        //     ],
        //   ),
        // )

        Divider(),


        CommonRichText(
          label: 'Card Name: ',
          value: '  (${item['CardCode']})    ${item["customer_name"] ?? ''}',
        ),



        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showConsolation = !showConsolation;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Text(
                        showConsolation ? 'Close' : 'Details',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        showConsolation
                            ? Icons.close_fullscreen_outlined
                            : Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),


        if(showConsolation == true)
Column(children: [

  buildRow('Posting Date', item['PostingDate']),
        buildRow('Doc Entry', item['DocEntry']),
        buildRow('Old Invoice No', item['U_OldInvNo']),
        buildRow('Reference No', item['Reference_No']),
        buildRow('Group Name', item['Group_Name']),
        buildRow('Total', item['Total']),
        buildRow('Due Date', item['DueDate']),
        buildRow('Payment Group', item['PymntGroup']),
        buildRow('Due Amount', item['DueAmount']),
        buildRow('Days Over Due', item['Days_Over_Due']),
        buildRow('EMP Over Due Days', item['EMP_Over_Due_Days']),
        buildRow('EMP Over Due Amount', item['EMP_Over_Due_Amount']),
        buildRow('Sales Employee', item['SalesEmployee']),
        buildRow('Department', item['Department']),
        buildRow('Name', item['Name']),
        buildRow('Balance', item['Balance']),
        buildRow('Group Code', item['GroupCode']),
        buildRow('Branch', item['Branch']),
],),




      ],
    );
  }
  Widget buildRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            // style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          Text(value?.toString() ?? '- -'),
        ],
      ),
    );
  }

}