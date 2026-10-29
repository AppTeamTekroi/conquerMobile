import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vconquer/features/Quatation/new_quatation_page.dart';
import 'package:vconquer/features/Quatation/quatation_controller.dart';
import 'package:vconquer/features/Quatation/quatation_details.dart';
import 'package:vconquer/features/navBar.dart';

import '../../ui/color/appColor.dart';
import '../../ui/richtext.dart';
import '../orderlist/order_controller.dart';

class QuatationListScreen extends StatefulWidget {
  QuatationListScreen({
    super.key,
  });
  @override
  State<QuatationListScreen> createState() => _QuatationListScreentate();
}

class _QuatationListScreentate extends State<QuatationListScreen> {
  //OrderPlacedController oc = Get.put(OrderPlacedController());
  QuatationController qc = Get.find();
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final ScrollController _scrollController = ScrollController();

  var totalrecords = "0".obs;
  var filterrecords = '0'.obs;
  var totalAmount = "₹0.00".obs;
  var sales_employee = "".obs;

  @override
  void initState() {
    super.initState();
    if (qc.searchQuery.value.isNotEmpty) {
      qc.searchQuery.value = '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });

    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchData() async {
    await qc.Quatationlist();
    final list = qc.quatationlist.value;

    if (list is Map) {
      totalrecords.value = (list['recordsTotal'] ?? 0).toString();
      filterrecords.value = (list['recordsFiltered'] ?? 0).toString();

      // If total amount is returned from the API
      final amount = list['totalAmount']; // Adjust key if different
      if (amount != null) {
        totalAmount.value = "₹${amount.toStringAsFixed(2)}"; // format as needed
      }
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
    await qc.Quatationlist(isPagination: true);
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.white,

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
            GestureDetector(onTap: () => Get.to(() => const NewQuotationScreen()) ,child:
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
                  Obx(()=> SizedBox(
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
                                  totalAmount.value,
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
                                const Text('Records',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 147, 147, 147))),
                                Text(
                                  totalrecords.value,
                                  style: TextStyle(
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Spacer(),
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
          Expanded(child: Obx(() {
            if (qc.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (qc.errorMessage.value.isNotEmpty) {
              return Center(child: Text(qc.errorMessage.value));
            } else {
              if (qc.filteredcust.isEmpty) {
                return Center(
                  child: Text(
                    'Raise your Quotation',
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              QuatationDetailsScreen(oppId: (item['id']).toString(),page: 'quotation',),
                            ),
                          );
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
                                        'Doc No: ${item["quotation_no_prefix"]}',
                                      //  "Doc No: ${item["id"]}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blues),
                                      ),
                                      // Text(
                                      //   "Code: ${item["customer_webid"]}",
                                      //   style: TextStyle(
                                      //       fontSize: 15,
                                      //       fontWeight: FontWeight.w500,
                                      //       color: AppColors.blues),
                                      // ),
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
                                      Container(
                                        height: height * 0.025,
                                        width: width * 0.2,
                                        decoration: BoxDecoration(
                                            color: item['status_id'] == 0 ?
                                            Color.fromARGB(255, 255, 232, 157):Colors.lightGreen.shade200,
                                            //  Color(0Xff30CB00),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(10))),
                                        child: Center(
                                          child: Text(
                                              item['status_id'] == 0 ? 'Open':'Close',
                                              style: TextStyle(
                                                  fontSize: height * 0.01,
                                                  color: item['status_id'] == 0 ?Colors.red:Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
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
                                          'Quatation On'),
                                      Text(item[
                                      "quotation_date"] ?? '- -'

                                      ),


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                          'Valid Till'),
                                      Text(item[
                                      "valid_till"] ?? '- -'

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
                                      "total_quantity"]).toString() ?? '- -'

                                      ),


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                          'After Disc'),
                                      Text((item[
                                      "total_after_disc"]).toString() ?? '- -'

                                      ),


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                          'Total Tax'),
                                      Text((item[
                                      "total_tax_value"]).toString() ?? '- -'

                                      ),


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                          'Valid'),
                                      Text(item[
                                      "valid_till"] ?? '- -'

                                      ),


                                    ],
                                  ),

                                  // Row(
                                  //   mainAxisAlignment:
                                  //   MainAxisAlignment
                                  //       .spaceBetween,
                                  //   children: [
                                  //     const Text(
                                  //         '📞contact_id'),
                                  //     Text(item[
                                  //     "contact_id"] ?? '- -'
                                  //
                                  //     ),
                                  //
                                  //
                                  //   ],
                                  // ),
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
                                          'Remarks'),
                                      Text(item[
                                      "remarks"] ?? '- -'

                                      ),


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                          'Doc Total'),
                                      Text((item[
                                      "total_amount"]).toString() ?? '- -'

                                      ),


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Text(
                                          'Placed By'),
                                      Text((item[
                                      "user_name"]) ?? '- -',style: TextStyle(color: Colors.blue[900]),

                                      ),


                                    ],
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