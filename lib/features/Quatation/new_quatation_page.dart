import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vconquer/features/Quatation/quatationlst_Screen.dart';
import 'package:vconquer/features/customers/customer_controller.dart';
import 'package:vconquer/features/customers/customer_screen.dart';
import 'package:vconquer/features/filters_dropdown/dropdown_controller.dart';
import 'package:vconquer/features/homescreen.dart';
import 'package:vconquer/features/navBar.dart';
import 'package:vconquer/features/products/Products.dart';
import 'package:vconquer/ui/CommonWidget.dart';
import '../../ui/Buttons/buttonBS.dart';
import '../../ui/color/appColor.dart';
import '../../ui/richtext.dart';
import '../../ui/textfieldWidget.dart';

import '../cart/cart_controller.dart';
import '../products/Product_QuatScreen.dart';
import '../products/product_controller.dart';

class NewQuotationScreen extends StatefulWidget {
  const NewQuotationScreen({super.key});

  @override
  State<NewQuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<NewQuotationScreen> {
  bool isExpanded = false;
  ProductController pc = Get.put(ProductController());
  DropdownController dc = Get.put(DropdownController());
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController deliveryterms = TextEditingController();
  final TextEditingController otherterms = TextEditingController();

  String? branch;
  String? sales_employee;
  String? category;
  String? sub_category;
  String? country;
  DateTime? validTillDate;

  var expand = true.obs;

  var bill_id = ''.obs;
  var ship_id = ''.obs;
  var contact = ''.obs;
  var selectedterm = ''.obs;

  bool _other = false;
  bool _address = false;
  bool _addition = false;
  bool _sales_form = false;


  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _getBranch();
    // dc.fetchsalesEmpName(context);
    // dc.fetchcategories(context);
    // dc.fetchsubCategories(context);
    dc.fetchbranches(context);
    dc.fetchcountries(context);
    dc.fetchpayterm(context);

    DateTime validTillDate = DateTime.now().add(Duration(days: 7));

    // Format the date as YYYY-MM-DD
    String formattedDate = "${validTillDate.year}-${validTillDate.month.toString().padLeft(2, '0')}-${validTillDate.day.toString().padLeft(2, '0')}";

    // Assign the formatted date to the controller
    _dateController.text = formattedDate;

    print("Formatted Date: $formattedDate");
    print("Current Date: ${DateTime.now()}");
    print("Valid Till Date: $validTillDate");// Debug print to check the value
  }

  Future<void> getcontact(customerId) async {
    await dc.fetchcontact(context, customerId!);
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

  CustomerController customerController = Get.put(CustomerController());
  CartController cartController = Get.put(CartController());
  String? customerId;
  String? selectedCustomerName;
  String? selectedcardcode;
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
          'Create Quatation',
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
                                    'Quotation #',
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
                                'SQ-2',
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
                    GestureDetector(
                      onTap: () async {
                        final selectedCustomer = await Get.to(
                            () => CustomerScreen(fromQuotation: true));

                        if (selectedCustomer != null) {
                          setState(() {
                            customerId = selectedCustomer['id'].toString();
                            selectedCustomerName = selectedCustomer['name'];
                            selectedcardcode = selectedCustomer['cardcode'];
                            selectedemail = selectedCustomer['email'];
                          });
                          print(selectedCustomer['customer']);
                          print(selectedCustomer['name']);
                          getcontact(customerId);
                          await cartController.fetchcartlist(
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
                          if(cartController.cartitems.isNotEmpty) {
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
                              final maplist = dataList is Map<dynamic, dynamic>
                                  ? dataList
                                  : {};

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
                                                      MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.5,
                                                      child: Text(
                                                        item['item_no'] ?? '--',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            color: Colors
                                                                .orange[900]),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      "💵 ${((
                                                          item['subtotal'] ??
                                                              '0')).toString()?? '- -'}",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .green,
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
                                                                'Price with Unit'),
                                                            Text((item[
                                                            "price_af_disc"])
                                                                .toString() ??
                                                                '- -'
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            const Text(
                                                                'Sub Total'),
                                                            Text((item[
                                                            "subtotal"])
                                                                .toString() ??
                                                                '- -'
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
                                                            Text(item[
                                                            "quantity"]
                                                                .toString()),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            const Text(
                                                                'Discount'),
                                                            Text((item[
                                                            "discount"] ??
                                                                '- -')
                                                                .toString() ??
                                                                '- -'
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            const Text(
                                                                'GST Rate'),
                                                            Text((item[
                                                            "gst_rate"])
                                                                .toString() ??
                                                                '- -'
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            const Text(
                                                                'GST Value'),
                                                            Text((item[
                                                            "gst_value"])
                                                                .toString() ??
                                                                '- -'
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            const Text('UoM'),
                                                            Text(item["uom"] ??
                                                                '- -'
                                                                    .toString()),
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
                                                            color: Colors
                                                                .grey[500],
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                _showDiscountBottomSheet(
                                                                    item,
                                                                    item['product']
                                                                    [
                                                                    "name"]);
                                                              },
                                                              child:
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    right:
                                                                    5.0),
                                                                child: Align(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                                  child:
                                                                     // Edit
                                                                  Text('',
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
                                                              color:
                                                              Colors.grey,
                                                              size: 12,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
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
                                        builder: (context) =>
                                            ProductQuatscreen(customerId: customerId,cardCode: selectedcardcode),

                                      ),
                                    );
                                    if(customerId !=null)
                                    await cartController.fetchcartlist(context,customerId!);
                                  },
                                  child: SizedBox(
                                    width: width * 0.9,
                                    child: Padding(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey
                                              .withOpacity(0.3),
                                          borderRadius:
                                          const BorderRadius
                                              .only(
                                            bottomRight: Radius
                                                .circular(10),
                                            bottomLeft: Radius
                                                .circular(10),
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets
                                              .symmetric(
                                              vertical: 6.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Icon(
                                                Icons
                                                    .add_circle,
                                                color: Colors
                                                    .black,
                                                size: 12,
                                              ),
                                              Text(
                                                'Add More Items',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors
                                                      .black,
                                                  fontWeight: FontWeight
                                                      .w600,
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
                                ));
                                await cartController.fetchcartlist(
                                    context, customerId!);
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
                                    color:
                                    AppColors.mainblue, // Circle background color
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

                    (_sales_form)?

                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 4,vertical: 3),
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
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(color: Colors.grey),
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
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _sales_form = false; // Toggle the visibility of the TextField
                        });
                      },
                      child:
                        Icon(Icons.close_fullscreen_outlined,
                            size: 22, color: AppColors.blues),
                      ),
                                SizedBox(width: 7)
                              ],
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
                                            border:
                                                Border.all(color: Colors.grey),
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
                                                fontSize: Get.height * 0.018,
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
                                                initialDate: DateTime.now().add(
                                                    Duration(
                                                        days:
                                                            8)), // Default 8 days forward
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
                                        "Payment %",
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
                                          width: width *
                                              0.45, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                          height: height * 0.05,
                                          child: Obx(() {
                                            if (dc.isLoading9.value) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (dc.errorMessage9.value
                                                .isNotEmpty) {
                                              return Center(
                                                  child: Text(
                                                      dc.errorMessage9.value));
                                            } else {
                                              final PayItems = dc.payterm;
                                              return DropdownSearch<dynamic>(
                                                items: PayItems.value,
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      CommonWidget
                                                          .dropdecoration(
                                                    'Select Term',
                                                    EdgeInsets.only(
                                                        top: 13, left: 8),
                                                  ),
                                                ),
                                                onChanged:
                                                    (dynamic? selectedText) {
                                                  if (selectedText != null) {
                                                    setState(() {
                                                      selectedterm.value =
                                                          selectedText;
                                                      print(selectedText);
                                                    });
                                                  }
                                                },
                                                dropdownBuilder:
                                                    (context, selectedItem) {
                                                  return Text(
                                                    selectedItem ??
                                                        'Select Term',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Contact ",
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
                                    child: Obx(() {
                                      if (dc.isLoading5.value) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (dc
                                          .errorMessage5.value.isNotEmpty) {
                                        return Center(
                                            child:
                                                Text(dc.errorMessage5.value));
                                      } else {
                                        final contactlist = dc.contact.value;
                                        final contactdata =
                                            contactlist is List<dynamic>
                                                ? contactlist
                                                : [];

                                        final Map<String, String> dropdownMap =
                                            {
                                          for (var item in contactdata)
                                            '${item["name"]}-${item["cellolar"]}':
                                                (item["id"]).toString()
                                        };

                                        final dropdownItems = dropdownMap.keys.toList();

                                        return Container(
                                          width: width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9)),
                                          child: DropdownSearch<String>(
                                            items: dropdownItems,
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  CommonWidget.dropdecoration(
                                                'Select contact',
                                                EdgeInsets.only(
                                                    top: 13, left: 8),
                                              ),
                                            ),
                                            onChanged: (String? conText) async {
                                              if (conText != null) {
                                                final conId = dropdownMap[
                                                    conText]; // Get the ID for the selected text
                                                if (conId != null) {
                                                  setState(() {
                                                    contact.value = conId;
                                                    print(conId);
                                                  });
                                                }
                                              }
                                            },
                                            dropdownBuilder:
                                                (context, selectedItem) {
                                              return Text(
                                                selectedItem ??
                                                    'Select contact',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 6),
                                  child: Container(
                                      width: width, // Adjust the width as per your requirement (e.g., 40% of screen width)
                                      height: height * 0.05,
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(9),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Text(
                                        selectedemail != null
                                            ? selectedemail!
                                            : "customer email",
                                        style: TextStyle(
                                            color: AppColors.blues,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15),
                                      )),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ): GestureDetector(
                      onTap: () {
                        setState(() {
                          _sales_form = !_sales_form; // Toggle the visibility of the TextField
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
                            color:
                            AppColors.mainblue, // Circle background color
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
                        final billdetails = billlist is List<dynamic> ? billlist : [];
                        final Map<String, String> dropdownMap = {
                          for (var item in billdetails)
                            '${item["street"] ?? ""}, ${item["block"] ?? ""}, ${item["city"] ?? ""}, ${item["state"] ?? ""}, ${item["zip_code"] ?? ""}':
                                (item["id"]).toString()
                        };

                        final billitem = dropdownMap.keys.toList();

                        String? selectedItem = billitem.isNotEmpty ? billitem[0] : null;

                        if (selectedItem != null && dropdownMap.containsKey(selectedItem)) {
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
                      }
                      else {
                        // Get the shipping data
                        final shiplist = dc.shipping;
                        final shipdetail = shiplist is List<dynamic> ? shiplist : [];

                        final Map<String, String> dropdownMap = {
                          for (var item in shipdetail)
                            '${item["street"] ?? ""}, ${item["block"] ?? ""}, ${item["city"] ?? ""}, ${item["state"] ?? ""}, ${item["zip_code"] ?? ""}':
                            (item["id"]).toString()
                        };

                        final shipItems = dropdownMap.keys.toList();
                        String? shippingaddress = shipItems.isNotEmpty ? shipItems[0] : null;

                        if (shippingaddress != null && dropdownMap.containsKey(shippingaddress)) {
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
                                    border: InputBorder.none, // Removes the outline
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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

                        (_other)?
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(children: [
                              Row(children: [
                                Spacer(),
                                GestureDetector(onTap:(){
                                _other = false;

                              },child: Icon(
                                Icons.close_fullscreen_outlined,
                                size: 18,
                                color: Colors.black54,
                              ))],),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: TextField(
                                controller: remarks,
                                onChanged: (val) {
                                  setState(() {
                                    _charCount = val.length;
                                  });
                                },
                                maxLength: 100,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: "Remarks",
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ),
                                                    SizedBox(height: 10),
                                                    Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: TextField(
                              controller: deliveryterms,
                              onChanged: (val) {
                                setState(() {
                                  _charCount = val.length;
                                });
                              },
                              maxLength: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                hintText: "Deleivery Terms",
                                alignLabelWithHint: true,
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade400,
                                  fontSize: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                            ),),
                                                   // SizedBox(height: 10),
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
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: "Other Terms & Conditions",
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ),
                                                    ],),
                          )
                     :GestureDetector(
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
                                  color:
                                  AppColors.mainblue, // Circle background color
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
                                    fontSize: 16, color: AppColors.mainblue),
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
              ? Positioned.fill(
                  child: Container(
                    color: Colors.white, // Semi-transparent background
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              : SizedBox.shrink()),
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
            ButtonBS(
                title: 'Place Quatation',
                textColor: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                width: width * 0.39,
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
                    "contact_id": contact.value,
                    "payment_term": selectedterm.value,
                    "valid_till": _dateController.text,
                    "remarks": remarks.text,
                    "branch": branch,
                    "delivery_term": deliveryterms.text,
                    "other_term_condition": otherterms.text
                  };

                  print(body);

                  var response = await cartController.PostOrder(context, body, customerId!);
                  var decodedValue = response;
                 print(decodedValue);
                  if (decodedValue['success'] == true) {
                    Fluttertoast.showToast(
                      msg: "Your Quatation was placed successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green.shade100,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                    Get.back();
                  } else {
                    Fluttertoast.showToast(
                      msg: response['message'] ??
                          "Something went wrong. Please try again.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red.shade100,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                  }
                })
          ]),
        ),
      ),
    );
  }

  void _showDiscountBottomSheet(Map<String, dynamic> item, String name) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    TextEditingController areaprice =
        TextEditingController(text: item['price'].toString());
    TextEditingController advCash =
        TextEditingController(text: item['discount1'].toString());
    TextEditingController scheme =
        TextEditingController(text: item['discount2'].toString());
    TextEditingController GMB =
        TextEditingController(text: item['discount3'].toString());
    TextEditingController Spl =
        TextEditingController(text: item['discount4'].toString());
    TextEditingController Distri =
        TextEditingController(text: item['discount5'].toString());
    TextEditingController quantity =
        TextEditingController(text: item['quantities'].toString());
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Allows the modal to take more space and scroll if needed
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Initial value for calculated discount per bag
            double discountPerBag =
                _calculateDiscountPerBag(advCash, scheme, GMB, Spl, Distri);

            // Recalculate the discount on text field changes
            void _recalculateDiscount() {
              setState(() {
                discountPerBag =
                    _calculateDiscountPerBag(advCash, scheme, GMB, Spl, Distri);
              });
            }

            // Attach listeners to recalculate discount whenever text changes
            advCash.addListener(_recalculateDiscount);
            scheme.addListener(_recalculateDiscount);
            GMB.addListener(_recalculateDiscount);
            Spl.addListener(_recalculateDiscount);
            Distri.addListener(_recalculateDiscount);
            quantity.addListener(_recalculateDiscount);

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // Ensures the column takes only necessary space
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 10.0, right: 10.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text with trailing ellipsis
                              Expanded(
                                // Wrap with Expanded to make it flexible
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Add this line for ellipsis
                                  maxLines:
                                      1, // Set maxLines to 1 for a single line
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.clear),
                              )
                            ],
                          ),
                        ),

                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        // Row(children: [
                        //
                        //   _buildDiscountTextField(
                        //       'Area Price Per Unit', areaprice),f
                        //   const SizedBox(width: 5),
                        //   _buildDiscountTextField(
                        //       'Advance Cash Discount', advCash),
                        // ],),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: areaprice,
                                  //onChanged: pc.onUnitPriceChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'Unit Price',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: quantity,
                                  //onChanged: pc.onPWTChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantity',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      // Adjust the vertical padding
                                      horizontal:
                                          10.0, // Adjust the horizontal padding
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: advCash,
                                  //onChanged: pc.onUnitPriceChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'advCash',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: scheme,
                                  //onChanged: pc.onPWTChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'scheme',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      // Adjust the vertical padding
                                      horizontal:
                                          10.0, // Adjust the horizontal padding
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // _buildDiscountTextField('Scheme Discount', scheme),
                        // const SizedBox(height: 5),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: GMB,
                                  //onChanged: pc.onUnitPriceChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'GMB',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: Spl,
                                  //onChanged: pc.onPWTChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'Spl',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      // Adjust the vertical padding
                                      horizontal:
                                          10.0, // Adjust the horizontal padding
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // _buildDiscountTextField('GMB Discount', GMB),
                        // const SizedBox(height: 5),
                        // _buildDiscountTextField('Special Discount', Spl),
                        const SizedBox(
                          height: 10.0,
                        ),
                        _buildDiscountTextField('Distributor Discount', Distri),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount Per Bag:'),
                            Text(discountPerBag
                                .toString()), // Updated dynamically
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Discount:'),

                            Text((discountPerBag *
                                    (int.tryParse(quantity.text) ?? 0))
                                .toString()), // Safely parsed

                            // Recalculated dynamically
                          ],
                        ),
                        const SizedBox(height: 10),
                        ButtonBS(
                          title: 'Update',
                          textColor: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          width: w * 0.3,
                          height: 40,
                          padding: 12,
                          backgroundColor: AppColors.mainblue,
                          borderRadius: 20,
                          //suffixIcon: Icons.add,
                          suffixIconColor: AppColors.mainblue,
                          //suffixIconSize: 13,
                          prefixIconSize: 0,
                          // separateSuffixIcon: 5,
                          onPressed: () async {
                            final body = {
                              "quantities": quantity.text,
                              "status": 1,
                              "price": areaprice.text,
                              "discount1": advCash.text,
                              "discount2": scheme.text,
                              "discount3": GMB.text,
                              "discount4": Spl.text,
                              "discount5": Distri.text,
                            };
                            print(body);
                            await cartController.CartUpdate(
                                context, body, item['id']);
                            if (cartController.cardupdate.value != null) {
                              var decodedValue =
                                  cartController.cardupdate.value;
                              print("fwevraesvvfffffff$decodedValue");
                              if (decodedValue['success'] == true) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(decodedValue['message'] ??
                                        'Updated!'), // Use the message from response
                                    backgroundColor: Colors
                                        .green, // Set the background color to indicate success
                                    duration: Duration(
                                        seconds:
                                            3), // Duration for SnackBar visibility
                                  ),
                                );
                                await cartController.fetchcartlist(
                                    context, customerId!);
                              } else {
                                // Handle case where the success field is false
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(decodedValue['message'] ??
                                        'Failed to update cart.'),
                                    backgroundColor: Colors
                                        .red, // Set the background color to indicate failure
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } else {
                              // Handle null or invalid response
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Unexpected response from server. Please try again.'),
                                  backgroundColor: Colors
                                      .red, // Set the background color to indicate failure
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          //separateSuffixIcon: 5,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Obx(() => cartController.isLoading2.value
                    ? Positioned.fill(
                        child: Container(
                          color: Colors.white, // Semi-transparent background
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      )
                    : SizedBox.shrink()),
              ],
            );
          },
        );
      },
    );
  }

// Helper method to calculate discount per bag
  double _calculateDiscountPerBag(
    TextEditingController advCash,
    TextEditingController scheme,
    TextEditingController GMB,
    TextEditingController Spl,
    TextEditingController Distri,
  ) {
    double adv = double.tryParse(advCash.text) ?? 0;
    double sch = double.tryParse(scheme.text) ?? 0;
    double gmb = double.tryParse(GMB.text) ?? 0;
    double spl = double.tryParse(Spl.text) ?? 0;
    double dist = double.tryParse(Distri.text) ?? 0;

    return adv + sch + gmb + spl + dist;
  }

// Helper method to build text fields for discounts
  Widget _buildDiscountTextField(
      String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
