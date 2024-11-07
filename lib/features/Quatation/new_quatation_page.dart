import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vconquer/features/customers/customer_controller.dart';
import 'package:vconquer/features/customers/customer_screen.dart';
import 'package:vconquer/features/homescreen.dart';
import 'package:vconquer/features/navBar.dart';
import 'package:vconquer/features/products/Products.dart';
import '../../ui/Buttons/buttonBS.dart';
import '../../ui/color/appColor.dart';
import '../../ui/richtext.dart';
import '../../ui/textfieldWidget.dart';

import '../cart/cart_controller.dart';
import '../products/product_controller.dart';

class NewQuotationScreen extends StatefulWidget {
  const NewQuotationScreen({super.key});

  @override
  State<NewQuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<NewQuotationScreen> {
  bool isExpanded = false;
  ProductController pc = Get.put(ProductController());
  CustomerController customerController = Get.put(CustomerController());
  CartController cartController = Get.put(CartController());
  String? customerId;
  String? selectedCustomerName;
  double tax_total = 0.00;
  double discount = 0.00;
  bool _dialogShown = false;
  var _ontapproduct = false.obs;
  var total = '0.00'.obs;
  Map<int, bool> expandedStates =
      {};


  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

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
            fontWeight: FontWeight.w400,
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
                       // Get.back();
                        //  _dialogShown = true;
                      Get.off(() => BottomNav());
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
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quotation #',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    'Edit',
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
                        // Navigate to customer selection page and wait for result
                        final selectedCustomer =
                        await Get.to(() => CustomerScreen(fromQuotation: true));

                        if (selectedCustomer != null) {
                          setState(() {
                            customerId = selectedCustomer['id'].toString();
                            selectedCustomerName = selectedCustomer['name'];
                          });
                          print(selectedCustomer['customer']);
                          print(selectedCustomer['name']);

                          await cartController.fetchcartlist(
                              context, customerId!);
                        }
                      },
                      child: Container(
                        width: w * 1,
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
                                        'Select Customer',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.mainblue),
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
                    GestureDetector(
                      onTap: () async {
                        if (customerId != null) {
                          print(
                              "Navigating to Products with customerId: $customerId");
                          await Get.to(() => Products(customerId: customerId!));
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //hello?
                    const Row(
                      children: [
                        Text(
                          'Cart Items',
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
                    (customerId != null)
                        ? Obx(() {
                            if (cartController.isLoading1.value) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (cartController
                                .errorMessage1.value.isNotEmpty) {
                              return Center(
                                  child:
                                      Text(cartController.errorMessage1.value));
                            } else {
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

                              if (result.isEmpty) {
                                return const Center(
                                    child: Text('Add products to cart'));
                              }

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
                                                        selectedCustomerName
                                                             ??
                                                            '--',

                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      '₹ ${double.tryParse(item['total_amount'] ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                                                      //  '₹ ${item['product']['price'].toString()}',

                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    // Expanded(
                                                    //   child: IconButton(
                                                    //     onPressed: () async {
                                                    //       int cartId =
                                                    //           item['id'];
                                                    //       final body = {
                                                    //         "status": 0,
                                                    //       };
                                                    //       await cartController
                                                    //           .CartUpdate(
                                                    //               context,
                                                    //               body,
                                                    //               cartId);
                                                    //       Fluttertoast
                                                    //           .showToast(
                                                    //         msg:
                                                    //             "Cart Item removed",
                                                    //         toastLength: Toast
                                                    //             .LENGTH_SHORT,
                                                    //         gravity:
                                                    //             ToastGravity
                                                    //                 .CENTER,
                                                    //         timeInSecForIosWeb:
                                                    //             1,
                                                    //         backgroundColor:
                                                    //             Colors.green
                                                    //                 .shade100,
                                                    //         textColor:
                                                    //             Colors.black,
                                                    //         fontSize: 16.0,
                                                    //       );
                                                    //       await cartController
                                                    //           .fetchcartlist(
                                                    //               context,
                                                    //               customerId!);
                                                    //     },
                                                    //     icon: Icon(Icons
                                                    //         .close_outlined),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),

                                                // IconButton(
                                                //   onPressed: () async {
                                                //     int cartId = item['id'];
                                                //     final body = {
                                                //       "status": 0
                                                //     };
                                                //
                                                //     // Call the update method directly
                                                //     await cartController
                                                //         .CartUpdate(context,
                                                //             body, cartId);
                                                //     await cartController
                                                //         .fetchcartlist(
                                                //             context,
                                                //             customerId!);
                                                //   },
                                                //   icon: Icon(Icons.close,
                                                //       size: 14),
                                                //     // )
                                                //   ],
                                                // ),
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
                                                            Text(item[
                                                                    "taxable_price"]
                                                                .toString()),
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
                                                            Text(item[
                                                                    "discount"]
                                                                .toString()),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                                'Excise'),
                                                            Text(item["excise"]
                                                                .toString()),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text('UoM'),
                                                            Text(item["uom"]
                                                                .toString()),
                                                          ],
                                                        ),
                                                        Text(
                                                          selectedCustomerName ??
                                                              'Null',

                                                          style:
                                                              const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
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
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
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
                                                                  child: Text(
                                                                    'Edit',
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .mainblue,
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ]);
                            }
                          })
                        : SizedBox.shrink()
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
                  'Total Amount',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                if (customerId != null)
                  Obx(() => Text(
                        '₹${cartController.totalorder.value}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      )),
              ],
            ),
            ButtonBS(
                title: 'Buy Now',
                textColor: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                width: w * 0.35,
                height: h * 0.04,
                padding: 5.0,
                backgroundColor: AppColors.mainblue,
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
                  final body = {
                    "customerId": customerId,
                    "userId": id,
                    "branch": 1
                  };
                  var response = await cartController.PostOrder(
                      context, body, customerId!);
                  var decodedValue = response;

                  if (decodedValue['success'] == true) {
                    Fluttertoast.showToast(
                      msg: "Your order was placed successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green.shade100,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                   // Get.off(() => OrderPlacedScreen());
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
                            await cartController.CartUpdate(context, body, item['id']);
                            if (cartController.cardupdate.value !=null) {
                              var decodedValue = cartController.cardupdate.value;
                               print("fwevraesvvfffffff$decodedValue");
                              if (decodedValue['success'] == true) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(decodedValue['message'] ?? 'Updated!'), // Use the message from response
                                    backgroundColor: Colors.green, // Set the background color to indicate success
                                    duration: Duration(seconds: 3), // Duration for SnackBar visibility
                                  ),
                                );
                                await cartController.fetchcartlist(
                                    context, customerId!);
                              } else {
                                // Handle case where the success field is false
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(decodedValue['message'] ?? 'Failed to update cart.'),
                                    backgroundColor: Colors.red, // Set the background color to indicate failure
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } else {
                              // Handle null or invalid response
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Unexpected response from server. Please try again.'),
                                  backgroundColor: Colors.red, // Set the background color to indicate failure
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
