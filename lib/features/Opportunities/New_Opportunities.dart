import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vconquer/features/Opportunities/opportunity_controller.dart';
import 'package:vconquer/features/Quatation/Quotations.dart';
import 'package:vconquer/features/customers/customer_controller.dart';
import 'package:vconquer/features/customers/customer_screen.dart';
import 'package:vconquer/features/filters_dropdown/dropdown_controller.dart';
import 'package:vconquer/features/HomeScreen/homescreen.dart';
import 'package:vconquer/features/navBar.dart';
import 'package:vconquer/features/products/Products.dart';
import 'package:vconquer/ui/CommonWidget.dart';
import '../../ui/Buttons/buttonBS.dart';
import '../../ui/ResponseDialogBox.dart';
import '../../ui/assets/loading.dart';
import '../../ui/bottomsheet_cart_widget.dart';
import '../../ui/color/appColor.dart';
import '../../ui/loading.dart';
import '../../ui/richtext.dart';
import '../../ui/textfieldWidget.dart';
import 'package:file_picker/file_picker.dart';
import '../cart/cart_controller.dart';
import '../products/Product_QuatScreen.dart';
import '../products/product_controller.dart';

class NewOpportunitiesPage extends StatefulWidget {
  const NewOpportunitiesPage({super.key});

  @override
  State<NewOpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<NewOpportunitiesPage> {



  bool isExpanded = false;
  ProductController pc = Get.find();
  DropdownController dc = Get.find();
  CustomerController customerController = Get.find();
  CartController cartController = Get.find();
  OpportunityController op = Get.find();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController deliveryterms = TextEditingController();
  final TextEditingController otherterms = TextEditingController();
  List<String> opp_type_drop = <String>['New Bussiness', 'Renewal', 'Reopen'];
  List<String> oppRenewal_type_drop = <String>[
    'iPad',
    'iPhone',
    'iPad Pro',
    'Macbook',
    'MBP',
    'MacLaptops',
    'Kiran Photography',
    'IT Infra - Laptop',
    'Single Customer'
  ];

  final TextEditingController opp_name = TextEditingController();
  final TextEditingController opp_subtype = TextEditingController();
  final TextEditingController freight = TextEditingController();

  var opp_type = "".obs;
  var opp_renewType = "".obs;
  String? saleEmployee;
  String? branch;
  var sales_employee = "".obs;

  String? category;
  String? sub_category;
  String? country;
  DateTime? validTillDate;

  var expand = true.obs;

  var bill_id = ''.obs;
  var ship_id = ''.obs;
  //var contact = ''.obs;
  String? selectedterm;

  bool _other = false;
  bool _address = false;
  bool _addition = false;
  bool _sales_form = false;
  File selectedFile = File('');
  String pickedFileName = '';
  bool filePicked = false;

  int _charCount = 0;
  @override
  void initState() {
    super.initState();
    _getBranch();
    cartController.clear();
    clear();
    // dc.fetchsalesEmpName(context);
    // dc.fetchcategories(context);
    // dc.fetchsubCategories(context);
   // dc.fetchbranches(context);
   // dc.fetchcountries(context);
   // dc.fetchpayterm(context);

    DateTime validTillDate = DateTime.now();

    // Format the date as YYYY-MM-DD
    String formattedDate =
        "${validTillDate.year}-${validTillDate.month.toString().padLeft(2, '0')}-${validTillDate.day.toString().padLeft(2, '0')}";

    // Assign the formatted date to the controller
    _dateController.text = formattedDate;

    print("Formatted Date: $formattedDate");
    print("Current Date: ${DateTime.now()}");
    print("Valid Till Date: $validTillDate"); // Debug print to check the value
  }
  void clear(){
    opp_type.value = '';
    opp_renewType.value= '';
    sales_employee.value= '';
    bill_id.value= '';
    ship_id.value= '';

    pickedFileName= '';
    total.value= '';
  }
  Future<void> getcontact(customerId) async {
  //  await dc.fetchcontact(context, customerId!);
    await dc.fetchshipping(context, customerId);
    await dc.fetchbilling(context, customerId);
  }

  Future<void> _getBranch() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      branch = _prefs.getString('branch') ?? 'Branch';
    });
  }

  void toggleExpand() {
    expand.value = !expand.value;
  }



  String? customerId;
  String? selectedCustomerName;
  String? selectedcardcode;
  String? selectedsalesemployee;
  String? selectedpay;
  String? selectedemail;
  double tax_total = 0.00;
  double discount = 0.00;
  bool _dialogShown = false;
  var _ontapproduct = false.obs;
  var total = '0.00'.obs;
  Map<int, bool> expandedStates = {};

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // Format the current date
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Create Opportunity',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor: Colors.white,
                  content: const Text(
                    "Are you sure you want to exit?",
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
                      onPressed: () {
                        Navigator.pop(context);
                        //Get.off(() => BottomNav());
                        Get.back();
                        cartController.clear();
                        // pc.clearDetails();
                        // Navigator.of(context)
                        //   ..pop(true)..pop();
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
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Opportunity #',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    branch ?? 'Branch',
                                    style: TextStyle(
                                      color: AppColors.mainblue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'Sales Opportunity-1',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  currentDate,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //hello?
                    const Row(
                      children: [
                        Text(
                          'Customer',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
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
                    // GestureDetector(
                    //   onTap: () async {
                    //     final selectedCustomer = await Get.to(
                    //         () => CustomerScreen(fromQuotation: true));
                    //
                    //     if (selectedCustomer != null) {
                    //       setState(() {
                    //         customerId = selectedCustomer['id'].toString();
                    //         selectedCustomerName = selectedCustomer['name'];
                    //         selectedcardcode = selectedCustomer['cardcode'];
                    //         selectedemail = selectedCustomer['email'];
                    //         selectedsalesemployee =
                    //             selectedCustomer['sales_emp_name'];
                    //         selectedterm.value = selectedCustomer['payment_terms'];
                    //         saleEmployee = selectedCustomer['salesEmployee'];
                    //       });
                    //       print(selectedCustomer['customer']);
                    //       print(selectedCustomer['name']);
                    //
                    //       getcontact(customerId);
                    //       await cartController.opp_fetchcartlist(context, customerId!);
                    //     }
                    //   },
                    //   child: Container(
                    //     width: width * 1,
                    //     height: 50,
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 10, horizontal: 16),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           // Show selected customer name and ID if available, otherwise prompt to select a customer
                    //           selectedCustomerName != null
                    //               ? Text(
                    //                   '$selectedCustomerName ',
                    //                   //  (ID: $customerId)
                    //                   style: const TextStyle(
                    //                       fontSize: 16, color: Colors.black87),
                    //                 )
                    //               : Row(children: [
                    //                   Container(
                    //                     padding: const EdgeInsets.all(
                    //                         2), // Adjust padding to control the size of the circle
                    //                     decoration: BoxDecoration(
                    //                       shape: BoxShape
                    //                           .circle, // Make the container circular
                    //                       color: AppColors
                    //                           .blues, // Circle background color
                    //                     ),
                    //                     child: Icon(
                    //                       Icons.add,
                    //                       size: 12,
                    //                       color: AppColors.white, // Icon color
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     width: 8,
                    //                   ),
                    //                   Text(
                    //                     'Select Customer',
                    //                     style: TextStyle(
                    //                         fontSize: 16,
                    //                         color: AppColors.blues),
                    //                   ),
                    //                 ]),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        final selectedCustomer = await Get.to(
                                () => CustomerScreen(fromQuotation: true));

                        if (selectedCustomer != null) {
                          setState(() {
                            customerId = selectedCustomer['id'].toString();
                            selectedCustomerName = selectedCustomer['name'];
                            selectedsalesemployee = selectedCustomer['sales_emp_name'];
                            saleEmployee = selectedCustomer['salesEmployee'];
                            selectedcardcode = selectedCustomer['cardcode'];
                            selectedemail = selectedCustomer['email'];
                            selectedterm = selectedCustomer['payment_terms'];
                          });
                          print(selectedCustomer['customer']);
                          print(selectedCustomer['name']);
                          getcontact(customerId);
                          await cartController.opp_fetchcartlist(
                              context, customerId!);
                        }
                      },
                      child: Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Show selected customer name and ID if available, otherwise prompt to select a customer
                              selectedCustomerName != null
                                  ? Text(
                                '$selectedCustomerName ',
                                //  (ID: $customerId)
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              )
                                  : Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(
                                      2), // Adjust padding to control the size of the circle
                                  decoration: BoxDecoration(
                                    shape: BoxShape
                                        .circle, // Make the container circular
                                    color: AppColors
                                        .blues, // Circle background color
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 12,
                                    color: AppColors.white, // Icon color
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Select Customer',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blues),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Products',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
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

                    Obx(() {
                      if (cartController.cartitems.isNotEmpty) {
                        if (cartController.totalorder.value > 0) {
                          // if (cartController.isLoading1.value) {
                          //   return const Center(
                          //       child: CircularProgressIndicator());
                          // }
                          // else if (cartController
                          //     .errorMessage1.value.isNotEmpty) {
                          //   return Center(
                          //       child:
                          //       Text(cartController.errorMessage1.value));
                          // }
                          // else {
                          final dataList = cartController.cartlist.value;
                          final maplist =
                              dataList is Map<dynamic, dynamic> ? dataList : {};

                          // final list =
                          //     maplist['result'] is Map<dynamic, dynamic>
                          //         ? maplist['result']
                          //         : {};
                          final result = maplist["data"] is List<dynamic>
                              ? maplist["data"]
                              : [];

                          return Column(children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: result.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        result[index] as Map<String, dynamic>;
                                    final isExpanded =
                                        expandedStates[index] ?? false;

                                    return GestureDetector(
                                      onTap: () {
                                        // Toggle the expanded/collapsed state for the current item
                                        setState(() {
                                          expandedStates[index] =
                                              !isExpanded; // Toggle expanded state
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      item['item_no'] ?? '--',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          // color: Colors.orange[900]
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    "💵 ${((item['subtotal'] ?? '0')).toString() ?? '- -'}",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      // Makes both the emoji and price text green
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (isExpanded)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Unit Price'),
                                                          Text((item["price"])
                                                                  .toString() ??
                                                              '- -'),
                                                        ],
                                                      ),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .spaceBetween,
                                                      //   children: [
                                                      //     const Text(
                                                      //         'Sub Total'),
                                                      //     Text((item["subtotal"])
                                                      //             .toString() ??
                                                      //         '- -'),
                                                      //   ],
                                                      // ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Quantity'),
                                                          Text(item["quantity"]
                                                              .toString()),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Discount%'),
                                                          Text((item["disc_percent"] ??
                                                                      '- -')
                                                                  .toString() ??
                                                              '- -'),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Discount'),
                                                          Text((item["disc_value"] ??
                                                              '- -')
                                                              .toString() ??
                                                              '- -'),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Price Af Disc'),
                                                          Text((item["price_af_disc"] ??
                                                              '- -')
                                                              .toString() ??
                                                              '- -'),
                                                        ],
                                                      ),

                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Total Price Af Disc'),
                                                          Text((item["price_total_af_disc"] ??
                                                              '- -')
                                                              .toString() ??
                                                              '- -'),
                                                        ],
                                                      ),


                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'TaX Rate'),
                                                          Text((item["gst_rate"])
                                                                  .toString() ??
                                                              '- -'),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                              'Tax Value'),
                                                          Text((item["gst_value"])
                                                                  .toString() ??
                                                              '- -'),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text('UoM'),
                                                          Text(item["uom"] ??
                                                              '- -'.toString()),
                                                        ],
                                                      ),
                                                      Text(
                                                        item['item_desc'] ??
                                                            '- -',
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: AppColors
                                                                .blues),
                                                        maxLines: 5,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),







                                                    ],
                                                  ),
                                                )

                                              else
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${item["quantity"]}x',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[500],
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              //   _showDiscountBottomSheet(item, item['product']["name"]);
                                                            },
                                                            child:
                                                                const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          5.0),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    // Edit
                                                                    Text(
                                                                  '',
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .mainblue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            'details',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: Colors.grey,
                                                            size: 12,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              GestureDetector(
                                                onTap: () =>
                                    showModalBottomSheet(
                                    // constraints:
                                    //     BoxConstraints.loose(Size(width, height * 0.75)),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) =>
                                    SingleChildScrollView(
                                    child: Padding(
                                    padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(
                                    context)
                                        .viewInsets
                                        .bottom,
                                    ),
                                    child: CartUpdateSheet(items:item,name:item['item_no'],page: 'opportunity',cardcode:item['customer_code']),
                                    ),
                                    ),
                                    ),




                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColors.mainblue,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              const Divider(),

                                              //               ],
                                              //                     ),
                                              //                   ),
                                              //               ],
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       );
                                              //     },
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // pc.selectedProducts.value = [];
                                // Navigator.of(context).pop();
                                await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ProductQuatscreen(
                                        customerId: customerId,
                                        cardCode: selectedcardcode,
                                        page: 'opportunity',

                                    ),
                                  ),
                                );
                                if (customerId != null)
                                  await cartController.opp_fetchcartlist(context, customerId!);

                              //  await cartController.fetchcartlist(context, customerId!);
                              },
                              child: SizedBox(
                                width: width * 0.9,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle,
                                            color: Colors.black,
                                            size: 12,
                                          ),
                                          Text(
                                            'Add More Items',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (customerId != null) {
                            print(
                                "Navigating to Products with customerId: $customerId");
                            await Get.to(() => ProductQuatscreen(
                                  customerId: customerId!,
                                  cardCode: selectedcardcode,
                                   page: 'opportunity',
                                ));
                            await cartController.opp_fetchcartlist(context, customerId!);

                           // await cartController.fetchcartlist(context, customerId!);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please Select Customer",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.orange.shade100,
                              textColor: Colors.black,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.all(
                                  2), // Adjust padding to control the size of the circle
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle, // Make the container circular
                                color: AppColors
                                    .mainblue, // Circle background color
                              ),
                              child: Icon(
                                Icons.add,
                                size: 12,
                                color: AppColors.white, // Icon color
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Add Product',
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.mainblue),
                            ),
                          ]),
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 12,
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Sales Form',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
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
                        ),
                        Spacer(),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),

                    (_sales_form)
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 6),
                                      child: Container(
                                          width: width *
                                              0.4, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                          height: height * 0.05,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Text(
                                            selectedcardcode != null
                                                ? selectedcardcode!
                                                : "customer code",
                                            style: TextStyle(
                                                color: AppColors.blues,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          )),
                                    ),
                                    // Text(
                                    //   selectedcardcode != null ? selectedcardcode! : "customer code",
                                    //   style: TextStyle(
                                    //     color: AppColors.blues,
                                    //     fontWeight: FontWeight.normal,
                                    //     fontSize: 15,
                                    //   ),
                                    //   maxLines: 1,
                                    //   overflow: TextOverflow.ellipsis, // Adds "..." if the text overflows
                                    // ),

                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                                    //   child: Container(
                                    //     width: width * 0.4, // 40% of screen width
                                    //     constraints: BoxConstraints(
                                    //       minHeight: height * 0.05, // Set minimum height to avoid text cutoff
                                    //     ),
                                    //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjusted padding
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.grey.withOpacity(0.2),
                                    //       borderRadius: BorderRadius.circular(9),
                                    //       border: Border.all(color: Colors.grey),
                                    //     ),
                                    //     child: FittedBox(
                                    //       fit: BoxFit.scaleDown, // Ensures text fits inside the box
                                    //       alignment: Alignment.centerLeft,
                                    //       child: Text(
                                    //         selectedcardcode != null ? selectedcardcode! : "customer code",
                                    //         style: TextStyle(
                                    //           color: AppColors.blues,
                                    //           fontWeight: FontWeight.normal,
                                    //           fontSize: 15,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _sales_form =
                                              false; // Toggle the visibility of the TextField
                                        });
                                      },
                                      child: Icon(
                                          Icons.close_fullscreen_outlined,
                                          size: 22,
                                          color: AppColors.blues),
                                    ),
                                    SizedBox(width: 7)
                                  ],
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 5, vertical: 6),
                                //   child: Container(
                                //       width: width,
                                //       height: height * 0.05,
                                //       padding: EdgeInsets.all(12),
                                //       decoration: BoxDecoration(
                                //         color: Colors.grey.withOpacity(0.2),
                                //         borderRadius: BorderRadius.circular(9),
                                //         border: Border.all(color: Colors.grey),
                                //       ),
                                //       child: Text(
                                //         selectedsalesemployee != null
                                //             ? selectedsalesemployee!
                                //             : "Sales Employee Name",
                                //         style: TextStyle(
                                //             color: AppColors.blues,
                                //             fontWeight: FontWeight.normal,
                                //             fontSize: 15),
                                //       )),
                                // ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 6),
                                  child: Container(
                                      width: width,
                                      height: height * 0.05,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text(
                                        saleEmployee!= null
                                            ? saleEmployee!
                                            : "Sales Employee Name",
                                        style: TextStyle(
                                            color: AppColors.blues,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      )),
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Valid Till",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 3),
                                            child: Container(
                                              height: height * 0.05,
                                              width: width * 0.5,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: TextFormField(
                                                controller: _dateController,
                                                style: TextStyle(
                                                  fontSize: height * 0.02,
                                                  color: Colors.black,
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'YYYY-MM-DD',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                    fontSize:
                                                        Get.height * 0.018,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  //  padding: EdgeInsets.all(12),
                                                ),
                                                readOnly: true,
                                                onTap: () async {
                                                  // Pick the date when the user taps the field
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                        // .add(Duration(
                                                        //     days:
                                                        //         8
                                                      //          )
                                                   // ), // Default 8 days forward
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2101),
                                                  );

                                                  if (pickedDate != null) {
                                                    // If the user picks a date, format and update the controller text and validTillDate
                                                    String formattedDate =
                                                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                                    setState(() {
                                                      _dateController.text =
                                                          formattedDate; // Update the date in the field
                                                      validTillDate =
                                                          pickedDate; // Update validTillDate with the new selected date
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Credit Days %",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 6),
                                            child: Container(
                                                width: width *
                                                    0.4, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                                height: height * 0.05,
                                                padding: EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  borderRadius:
                                                  BorderRadius.circular(9),
                                                  border:
                                                  Border.all(color: Colors.grey),
                                                ),
                                                child: Text(
                                                  selectedterm ??"payment term",
                                                  style: TextStyle(
                                                      color: AppColors.blues,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 15),
                                                )),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       horizontal: 5, vertical: 3),
                                          //   child: Container(
                                          //     width: width *
                                          //         0.45, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                          //     height: height * 0.05,
                                          //     child: Obx(() {
                                          //       if (dc.isLoading9.value) {
                                          //         return const Center(
                                          //             child:
                                          //                 CircularProgressIndicator());
                                          //       } else if (dc.errorMessage9
                                          //           .value.isNotEmpty) {
                                          //         return Center(
                                          //             child: Text(dc
                                          //                 .errorMessage9
                                          //                 .value));
                                          //       } else {
                                          //         final PayItems = dc.payterm;
                                          //         return DropdownSearch<
                                          //             dynamic>(
                                          //           items: PayItems.value,
                                          //           dropdownDecoratorProps:
                                          //               DropDownDecoratorProps(
                                          //             dropdownSearchDecoration:
                                          //                 CommonWidget
                                          //                     .dropdecoration(
                                          //               'Select Term',
                                          //               EdgeInsets.only(
                                          //                   top: 13, left: 8),
                                          //             ),
                                          //           ),
                                          //           onChanged: (dynamic?
                                          //               selectedText) {
                                          //             if (selectedText !=
                                          //                 null) {
                                          //               setState(() {
                                          //                 selectedterm.value =
                                          //                     selectedText;
                                          //                 print(selectedText);
                                          //               });
                                          //             }
                                          //           },
                                          //           dropdownBuilder: (context,
                                          //               selectedItem) {
                                          //             return Text(
                                          //               selectedItem ??
                                          //                   'Select Term',
                                          //               style: TextStyle(
                                          //                 fontWeight:
                                          //                     FontWeight.w500,
                                          //                 color: Colors
                                          //                     .grey.shade600,
                                          //               ),
                                          //             );
                                          //           },
                                          //         );
                                          //       }
                                          //     }),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Contact ",
                                    //   style: TextStyle(
                                    //     fontSize: 13,
                                    //     color: Colors.black,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 5, vertical: 3),
                                    //   child: Container(
                                    //     height: height * 0.05,
                                    //     child: Obx(() {
                                    //       if (dc.isLoading5.value) {
                                    //         return Center(
                                    //             child:
                                    //                 CircularProgressIndicator());
                                    //       } else if (dc
                                    //           .errorMessage5.value.isNotEmpty) {
                                    //         return Center(
                                    //             child: Text(
                                    //                 dc.errorMessage5.value));
                                    //       } else {
                                    //         final contactlist =
                                    //             dc.contact.value;
                                    //         final contactdata =
                                    //             contactlist is List<dynamic>
                                    //                 ? contactlist
                                    //                 : [];
                                    //
                                    //         final Map<String, String>
                                    //             dropdownMap = {
                                    //           for (var item in contactdata)
                                    //             '${item["name"]}-${item["cellolar"]}':
                                    //                 (item["id"]).toString()
                                    //         };
                                    //
                                    //         final dropdownItems =
                                    //             dropdownMap.keys.toList();
                                    //
                                    //         return Container(
                                    //           width: width,
                                    //           decoration: BoxDecoration(
                                    //               borderRadius:
                                    //                   BorderRadius.circular(9)),
                                    //           child: DropdownSearch<String>(
                                    //             items: dropdownItems,
                                    //             dropdownDecoratorProps:
                                    //                 DropDownDecoratorProps(
                                    //               dropdownSearchDecoration:
                                    //                   CommonWidget
                                    //                       .dropdecoration(
                                    //                 'Select contact',
                                    //                 EdgeInsets.only(
                                    //                     top: 13, left: 8),
                                    //               ),
                                    //             ),
                                    //             onChanged:
                                    //                 (String? conText) async {
                                    //               if (conText != null) {
                                    //                 final conId = dropdownMap[
                                    //                     conText]; // Get the ID for the selected text
                                    //                 if (conId != null) {
                                    //                   setState(() {
                                    //                     contact.value = conId;
                                    //                     print(conId);
                                    //                   });
                                    //                 }
                                    //               }
                                    //             },
                                    //             dropdownBuilder:
                                    //                 (context, selectedItem) {
                                    //               return Text(
                                    //                 selectedItem ??
                                    //                     'Select contact',
                                    //                 style: TextStyle(
                                    //                     fontWeight:
                                    //                         FontWeight.w600),
                                    //               );
                                    //             },
                                    //           ),
                                    //         );
                                    //       }
                                    //     }),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 6),
                                      child: Container(
                                          width:
                                              width, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                          height: height * 0.05,
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Text(
                                            selectedemail != null
                                                ? selectedemail!
                                                : "customer email",
                                            style: TextStyle(
                                                color: AppColors.blues,
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow
                                                    .ellipsis, // Adds "..." if the text overflows

                                                fontSize: 15),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _sales_form =
                                    !_sales_form; // Toggle the visibility of the TextField
                              });
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(
                                      2), // Adjust padding to control the size of the circle
                                  decoration: BoxDecoration(
                                    shape: BoxShape
                                        .circle, // Make the container circular
                                    color: AppColors
                                        .mainblue, // Circle background color
                                  ),
                                  child: Icon(
                                    Icons.open_in_full_rounded,
                                    size: 12,
                                    color: AppColors.white, // Icon color
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Sales Form',
                                  style: TextStyle(
                                      fontSize: 16, color: AppColors.mainblue),
                                ),
                              ]),
                            ),
                          ),
                    SizedBox(height: 10),
                    Row(children: [
                      Text(
                        'Billing Address',
                        style: TextStyle(fontSize: 12, color: AppColors.blues),
                      ),
                    ]),
                    SizedBox(
                      height: 7,
                    ),
                    Obx(() {
                      if (dc.isLoading8.value) {
                        return Center(child: CircularProgressIndicator());
                      } else if (dc.errorMessage8.value.isNotEmpty) {
                        return Center(child: Text(dc.errorMessage8.value));
                      } else {
                        final billlist = dc.billing.value;
                        final billdetails =
                            billlist is List<dynamic> ? billlist : [];
                        final Map<String, String> dropdownMap = {
                          for (var item in billdetails)
                            '${item["street"] ?? ""}, ${item["block"] ?? ""}, ${item["city"] ?? ""}, ${item["state"] ?? ""}, ${item["zip_code"] ?? ""}':
                                (item["id"]).toString()
                        };

                        final billitem = dropdownMap.keys.toList();

                        String? selectedItem =
                            billitem.isNotEmpty ? billitem[0] : null;

                        if (selectedItem != null &&
                            dropdownMap.containsKey(selectedItem)) {
                          bill_id.value = dropdownMap[selectedItem] ?? '';
                          print("Initial Selected ID: ${bill_id.value}");
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownSearch<String>(
                                items: billitem,
                                selectedItem: selectedItem,
                                onChanged: (String? newid) {
                                  if (newid != null) {
                                    final selectedbill = dropdownMap[newid];
                                    if (selectedbill != null) {
                                      if (selectedbill != null) {
                                        setState(() {
                                          bill_id.value = selectedbill;
                                          print("Selected ID: $selectedbill");
                                        });
                                      }
                                    }
                                  }
                                },
                                dropdownBuilder: (context, selectedItem) {
                                  return selectedItem != null
                                      ? Text(
                                          selectedItem,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.add_circle,
                                              color: Colors.grey.shade600,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Billing Address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        );
                                },
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    border:
                                        InputBorder.none, // Removes the outline
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),

                    SizedBox(height: 10),
                    Row(children: [
                      Text(
                        'Shipping Address',
                        style: TextStyle(fontSize: 12, color: AppColors.blues),
                      ),
                    ]),
                    SizedBox(
                      height: 7,
                    ),
                    Obx(() {
                      // Check if the data is still loading
                      if (dc.isLoading7.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      // Show error message if any
                      else if (dc.errorMessage7.value.isNotEmpty) {
                        return Center(child: Text(dc.errorMessage7.value));
                      } else {
                        // Get the shipping data
                        final shiplist = dc.shipping;
                        final shipdetail =
                            shiplist is List<dynamic> ? shiplist : [];

                        final Map<String, String> dropdownMap = {
                          for (var item in shipdetail)
                            '${item["street"] ?? ""}, ${item["block"] ?? ""}, ${item["city"] ?? ""}, ${item["state"] ?? ""}, ${item["zip_code"] ?? ""}':
                                (item["id"]).toString()
                        };

                        final shipItems = dropdownMap.keys.toList();
                        String? shippingaddress =
                            shipItems.isNotEmpty ? shipItems[0] : null;

                        if (shippingaddress != null &&
                            dropdownMap.containsKey(shippingaddress)) {
                          ship_id.value = dropdownMap[shippingaddress] ?? '';
                          print("Initial Selected ID: ${ship_id.value}");
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dropdown for shipping addresses
                              DropdownSearch<String>(
                                items: shipItems,
                                selectedItem: shippingaddress,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    final billId = dropdownMap[newValue];
                                    if (billId != null) {
                                      setState(() {
                                        ship_id.value = billId; // Update the bill_id when a new address is selected
                                        print("Selected ID: $billId");
                                      });
                                    }
                                  }
                                },
                                dropdownBuilder: (context, selectedItem) {
                                  return selectedItem != null
                                      ? Text(
                                          selectedItem,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.add_circle,
                                              color: Colors.grey.shade600,
                                              size: 17,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "Shipping Address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        );
                                },
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    border:
                                        InputBorder.none, // Removes the outline
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Additional Information',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
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
                        ),
                        Spacer(),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (_other)
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Spacer(),
                                        GestureDetector(
                                            onTap: () {
                                              _other = false;
                                            },
                                            child: Icon(
                                              Icons.close_fullscreen_outlined,
                                              size: 18,
                                              color: Colors.black54,
                                            ))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: TextField(
                                        controller: opp_name,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: "Opportunity Name:",
                                          alignLabelWithHint: true,
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade400,
                                            fontSize: 15,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Obx(()=>
                                   Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 4),
                                            child: Container(
                                                width: width,
                                                // width: width * 0.45, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                                height: height * 0.05,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.shade400,
                                                  ), // Border color and width
                                                  borderRadius: BorderRadius.circular(
                                                      5), // Rounded border
                                                ),
                                                child: Obx(
                                                  () => DropdownButton<String>(
                                                    value: opp_type_drop
                                                            .contains(opp_type.value)
                                                        ? opp_type.value
                                                        : null,
                                                    hint: Text('Opportunity Type'),
                                                    icon: const Icon(
                                                      Icons
                                                          .keyboard_arrow_down_outlined,
                                                      size: 18,
                                                    ),
                                                    onChanged: (String? value) {
                                                      if (value != null) {
                                                        opp_type.value =
                                                            value; // Directly update using GetX
                                                      }
                                                    },
                                                    items: opp_type_drop.map<
                                                            DropdownMenuItem<String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              //  color: (opp_type.value.isEmpty)?Colors.grey.shade400:Colors.black,
                                                            )),
                                                      );
                                                    }).toList(),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(height: 10),
                                          if (opp_type.value == 'Renewal')
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5.0, vertical: 4),
                                              child: Container(
                                                  width: width,
                                                  // width: width * 0.45, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                                  height: height * 0.05,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5, vertical: 0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey.shade400,
                                                    ), // Border color and width
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5), // Rounded border
                                                  ),
                                                  child: Obx(
                                                        () => DropdownButton<String>(
                                                      value: oppRenewal_type_drop
                                                          .contains(
                                                          opp_renewType.value)
                                                          ? opp_renewType.value
                                                          : null,
                                                      hint: Text(
                                                          'Opportunity Renewal Type'),
                                                      icon: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down_outlined,
                                                        size: 18,
                                                      ),
                                                      onChanged: (String? value) {
                                                        if (value != null) {
                                                          opp_renewType.value =
                                                              value; // Directly update using GetX
                                                        }
                                                      },
                                                      items: oppRenewal_type_drop.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                              (String value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child: Text(value,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: (opp_renewType
                                                                        .isEmpty)
                                                                        ? Colors
                                                                        .grey.shade400
                                                                        : Colors.black,
                                                                  )),
                                                            );
                                                          }).toList(),
                                                    ),
                                                  )),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // ),


                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: TextField(
                                        controller: opp_subtype,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: "Opportunity SubType:",
                                          alignLabelWithHint: true,
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade400,
                                            fontSize: 15,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: TextField(
                                        controller: freight,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: "Freight charges",
                                          alignLabelWithHint: true,
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade400,
                                            fontSize: 15,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        RichText(
                                          text: const TextSpan(
                                            text: "Other Terms & Conditions ",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: TextField(
                                        controller: otherterms,
                                        onChanged: (val) {
                                          setState(() {
                                            _charCount = val.length;
                                          });
                                        },
                                        maxLength: 50,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: "Other Terms & Conditions",
                                          alignLabelWithHint: true,
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade400,
                                            fontSize: 15,
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: ElevatedButton(
                                        style: CommonWidget.commonbuttonStyle,
                                        onPressed: () async {
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles(
                                            allowMultiple: true,
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'jpg',
                                              'jpeg',
                                              'png',
                                              'doc',
                                              'docx',
                                              'pdf'
                                            ],
                                          );

                                          if (result != null &&
                                              result.files.isNotEmpty) {
                                            final file = result.files.first;
                                            setState(() {
                                              selectedFile = File(file.path!);
                                              pickedFileName = file.name;
                                              filePicked = true;
                                            });
                                            //  pc.attachment = selectedFile;
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.file_download),
                                            SizedBox(width: 8),
                                            filePicked
                                                ? Text(pickedFileName)
                                                : Text('Choose File'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _other =
                                        !_other; // Toggle the visibility of the TextField
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                          2), // Adjust padding to control the size of the circle
                                      decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, // Make the container circular
                                        color: AppColors
                                            .mainblue, // Circle background color
                                      ),
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 12,
                                        color: AppColors.white, // Icon color
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Additional Information',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.mainblue),
                                    ),
                                  ]),
                                ),
                              ),
                      ],
                    ),
                  ],
                )),
          ),
          Obx(() => cartController.isLoading3.value
              ? Positioned.fill(child: shimmerLoadingOverlay())
              : SizedBox.shrink()),
          Obx(() => op.isLoading3.value
              ? Positioned.fill(child: shimmerLoadingOverlay())
              :SizedBox()),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                if (customerId != null)
                  Obx(() => Text(
                        '${cartController.totalorder.value}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amount',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                if (customerId != null)
                  Obx(() => Text(
                        '₹${cartController.totalamount.value}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )),
              ],
            ),
          // Obx(() => op.isLoading3.value
          //     ? shimmerLoadingOverlay()
          //     :

          ButtonBS(
                title: 'Place Opportunity',
                textColor: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                width: width * 0.45,
                height: height * 0.04,
                padding: 5.0,
                backgroundColor: AppColors.blues,
                borderRadius: 12,
                suffixIcon: Icons.arrow_forward_ios,
                suffixIconColor: Colors.white,
                suffixIconSize: 18,
                prefixIconSize: 0,
                separateSuffixIcon: 5,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final id = prefs.getInt('id');
                  if (customerId == null) {
                    Fluttertoast.showToast(
                      msg: "Please Select Customer",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.orange.shade100,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  if (cartController.totalorder < 0) {
                    Fluttertoast.showToast(
                      msg: "Please Add Products",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.orange.shade100,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                    return;
                  }
                  final body = {
                    "customerId": customerId,
                    "address_id": bill_id.value,
                    "address_shipto": ship_id.value,
                    "sales_emp_name": selectedsalesemployee,
                   // "contact_id": contact.value,
                    "payment_term": selectedterm,
                    "validity": _dateController.text,
                    'opportunity_name': opp_name.text,
                    'opportunity_type': opp_type.value,
                    'opportunity_renewal': opp_renewType.value,
                    'opportunity_subtype': opp_subtype.text,
                    'freight': freight.text,
                    // "remarks": remarks.text,
                    // "branch": branch,
                    // "delivery_term": deliveryterms.text,
                    "other_term_condition": otherterms.text
                  };

                  print(body);
                  LoadingOverlay.show("Please wait while posting");
                  var response = await op.PostOpportunity(context, body, customerId!,selectedFile);
                  var decodedValue = response;
                   print(decodedValue);
                  LoadingOverlay.hide();
                  if (decodedValue['success'] == true) {
                    Get.back();
                    CommonWidget.showSnackbar(status: true, message: "Your Opportunity was placed successfully");
                    await op.Opportunitylist(context, isPagination: false);

                  } else {
                    CommonWidget.showSnackbar(status:false,message: response['message'] ??
                        "Something went wrong. Please try again.");


                  }
                  // LoadingOverlay.hide();

                })
        //  ),
          ]),
        ),
      ),
    );
  }


}
