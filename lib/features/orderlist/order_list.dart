import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vconquer/features/Quatation/new_quatation_page.dart';
import 'package:vconquer/features/Quatation/quatation_controller.dart';
import 'package:vconquer/features/navBar.dart';
import 'package:vconquer/features/orderlist/new_order_page.dart';

import '../../ui/color/appColor.dart';
import '../../ui/richtext.dart';
import '../orderlist/order_controller.dart';
import '../Quatation/quatation_details.dart';

class OrderListScreen extends StatefulWidget {
  OrderListScreen({
    super.key,
  });
  @override
  State<OrderListScreen> createState() => _OrderListScreentate();
}

class _OrderListScreentate extends State<OrderListScreen> {
  OrderController oc = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (oc.searchQuery.value.isNotEmpty) {
      oc.searchQuery.value = '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });

    _scrollController.addListener(_scrollListener);
  }


  Future<void> _fetchData() async {
    await oc.Orderlist(isPagination: false);
    final list = oc.orderList.value;

    if (list is Map) {
      totalrecords.value = (list['recordsTotal'] ?? 0).toString();
      filterrecords.value = (list['recordsFiltered'] ?? 0).toString();

      final amount = list['totalAmount'];
      if (amount != null) {
        totalAmount.value = "₹${amount.toStringAsFixed(2)}";
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !oc.isLoadingMore.value &&
        !oc.isLastPage.value) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    await oc.Orderlist( isPagination: true);
  }

  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  var totalrecords = "0".obs;
  var filterrecords = '0'.obs;
  var totalAmount = "₹0.00".obs;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            "Orders Catalog",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () => Get.to(() => NewOrderScreen()),
                child: Row(
                  children: [
                    Text(
                      "New",
                      style: TextStyle(
                        color: AppColors.blues,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.4),
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
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
                )),
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
                  Obx(
                    () => SizedBox(
                      height: height * 0.08,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: height * 0.015),
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
            if (oc.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (oc.errorMessage.value.isNotEmpty) {
              return Center(child: Text(oc.errorMessage.value));
            } else {
              if (oc.filteredcust.isEmpty) {
                return Center(
                  child: Text(
                    'No Orders Yet ',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      oc.filteredcust.length + (oc.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == oc.filteredcust.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final item = oc.filteredcust[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: Get.height * 0.015),
                      child: InkWell(
                        onTap: () {
                          print('Order Card Pressed');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuatationDetailsScreen(
                                oppId: (item['id']).toString(),
                                page: 'order',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: Get.height * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Doc No: ${item["salesorder_no_prefix"]}',
                                        //  "Doc No: ${item["id"]}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blues),
                                      ),
                                      Container(
                                        height: height * 0.025,
                                        width: width * 0.2,
                                        decoration: BoxDecoration(
                                            color: item['status_id'] == 1
                                                ? Color.fromARGB(
                                                    255, 255, 232, 157)
                                                : Colors.lightGreen.shade200,
                                            //  Color(0Xff30CB00),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomLeft:
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: Text(
                                              item['status_id'] == 1
                                                  ? 'Open'
                                                  : 'Close',
                                              style: TextStyle(
                                                  fontSize: height * 0.01,
                                                  color: item['status_id'] == 1
                                                      ? Colors.red
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
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
                                      const Text('Order On'),
                                      Text(item["order_date"] ?? '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Quantity'),
                                      Text(
                                          (item["total_quantity"]).toString() ??
                                              '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('After Disc'),
                                      Text((item["total_after_disc"])
                                              .toString() ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Tax'),
                                      Text((item["total_tax_value"])
                                              .toString() ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Valid'),
                                      Text(item["validity"] ?? '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Term'),
                                      Text(item["payment_term"] ?? '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Doc Total'),
                                      Text((item["total_amount"]).toString() ??
                                          '- -'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Placed By'),
                                      Text(
                                        (item["user_name"]) ?? '- -',
                                        style:
                                            TextStyle(color: Colors.blue[900]),
                                      ),
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
          })),
        ]));
  }
}
