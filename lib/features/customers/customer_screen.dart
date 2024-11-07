import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vconquer/features/customers/customer_controller.dart';
import 'package:vconquer/features/customers/customer_editScreen.dart';

import '../../../ui/color/appColor.dart';
import '../../../ui/richtext.dart';
import 'package:shimmer/shimmer.dart';

import 'AddCustomer_screen.dart';

class CustomerScreen extends StatefulWidget {
  final bool fromQuotation;

  const CustomerScreen({super.key, required this.fromQuotation});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final CustomerController customerController = Get.put(CustomerController());

  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await customerController.fetchUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 40,
        backgroundColor: AppColors.white,
        title: Container(
          margin: EdgeInsets.only(right: 0, left: 0),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Customers",
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                // pc.searchProduct.value = val;
                // pc.searchProductByName(pc.searchProduct.value);
              },
            ),
          ),
        ),
        // actions: [
        //  // if (widget.customerId != null)
        //     Padding(
        //       padding: const EdgeInsets.only(right: 15),
        //       child: GestureDetector(
        //         child: FaIcon(
        //           FontAwesomeIcons.barcode,
        //           color: Colors.black,
        //         ),
        //       ),
        //     ),
        //  // if (widget.customerId != null)
        //     Padding(
        //       padding: const EdgeInsets.only(right: 10),
        //       child: GestureDetector(
        //         onTap: () {
        //           //   Get.to(() => CartScreen(customerId: widget.customerId));
        //         },
        //         child: Icon(
        //           Icons.shopping_cart_outlined,
        //           color: Colors.black,
        //         ),
        //       ),
        //     ),
        // ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(height: 40,
          //     child: TextField(
          //       decoration: InputDecoration(
          //         hintText: 'Search by Customer Name...',
          //         prefixIcon: Icon(Icons.search),
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //       ),
          //       onChanged: (query) {
          //         setState(() {
          //           searchQuery = query;
          //         });
          //       },
          //     ),
          //   ),
          // ),

          Obx(
            () => customerController.isLoading.value == true
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.1),
                    highlightColor: Colors.white.withOpacity(0.6),
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.grey.shade800,
                            size: 17,
                          ),
                          Text(
                            "Add New Customer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => AddCustomers(
                                onUpdate: () {
                                  // setState(() {});
                                },
                              )),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.grey.shade800,
                            size: 17,
                          ),
                          Text(
                            "Add New Customer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Obx(() {
              if (customerController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (customerController.errorMessage.value.isNotEmpty) {
                return Center(
                    child: Text(customerController.errorMessage.value));
              } else {
                final dataList = customerController.customers.value;
                final list = dataList is Map<dynamic, dynamic> ? dataList : {};
                final employeeOnDuty =
                    list["data"] is List<dynamic> ? list["data"] : [];
                return ListView.builder(
                  itemCount: employeeOnDuty.length,
                  itemBuilder: (context, index) {
                    final item = employeeOnDuty[index] as Map<String, dynamic>;
                    final int itemId = item['id'];
                    return GestureDetector(
                      onTap: () {
                        if (widget.fromQuotation) {
                          Get.back(result: {
                            'id': item['id'],
                            'name': item['card_name']
                          });
                        }
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Code: ${item["web_id"]}",
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
                                          await customerController.fetchUserID(
                                              context,
                                              itemId); // Fetch the details
                                          Get.to(() => CustomerEditscreen());
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  // fontWeight: FontWeight.w500,
                                                  color: AppColors.blues),
                                            ),
                                            Icon(
                                              Icons.edit,
                                              color: AppColors.blues,
                                              size: 14,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  CommonRichText(
                                    label: 'Card Name: ',
                                    value: item["card_name"] ?? '',
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonRichText(
                                        label: 'Email: ',
                                        value: item["e_mail"] ?? '- -',
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
                                        "📞 ${item["cellular"] ?? '- -'}",
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
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
