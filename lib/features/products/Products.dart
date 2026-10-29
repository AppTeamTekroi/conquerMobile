import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:shimmer/shimmer.dart';
import 'package:vconquer/features/products/product_controller.dart';

import '../../core/enum/post_enum_response.dart';
import '../../ui/Buttons/buttonBS.dart';
import '../../ui/color/appColor.dart';
import '../../ui/richtext.dart';
import '../cart/cart_controller.dart';

class Products extends StatefulWidget {
  final String? customerId;
  final String? cardCode;
  const Products({Key? key, this.customerId = "",this.cardCode = ""}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final ProductController productController = Get.find();
  CartController cartController = Get.find();
  final List<RxInt> quantities = [];
  final List<TextEditingController> qtyControllers = [];
  String filter = "";
  var isEditing = false;
  String dropdownValue = 'Select SQ';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    // await productController.fetchproducts(context);
    if (widget.customerId != null) {
     // await cartController.fetchcartlist(context, widget.customerId!);
    }

    final dataList = productController.productList.value;
    final cartList = cartController.cartlist.value["data"] ?? [];

    quantities.clear();
    qtyControllers.clear();

    for (int i = 0; i < dataList.length; i++) {
      final product = dataList[i];
      final productId = product['id'].toString();
      int quantity = 0;

      for (var cartItem in cartList) {
        if (cartItem['product_id'].toString() == productId) {
          quantity = cartItem['quantity'] ?? 0;
          break;
        }
      }

      quantities.add(quantity.obs);
      qtyControllers.add(TextEditingController(text: quantity.toString()));
    }

    setState(() {});
  }

  void incrementQuantity(int index) {
    setState(() {
      quantities[index].value++;
      qtyControllers[index].text = quantities[index].value.toString();
      _updateCart(index);
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (quantities[index].value > 0) {
        quantities[index].value--;
        qtyControllers[index].text = quantities[index].value.toString();
        _updateCart(index);
      }
    });
  }

  void _updateCart(int index) {
    print(widget.cardCode);
    try {
      if (widget.customerId == null) {
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
      final product = productController.productList[index];
      final response = cartController.addToCart(
        context,
        product["id"].toString(),
        quantities[index].value,
        widget.customerId!,
        widget.cardCode!,
      );
      var decodedValue = response;
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
    } catch (e) {}
  }

  int _calculateTotalQuantity() {
    return quantities.fold(0, (sum, item) => sum + item.value);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    bool _isAnyQuantityValid() {
      for (var controller in qtyControllers) {
        int? quantity = int.tryParse(controller.text);
        if (quantity != null && quantity > 0) {
          return true; // Return true if any quantity is valid
        }
      }
      return false; // No valid quantities
    }
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
                hintText: "Search Products",
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                suffixIcon: Obx(
                      () => productController.filteredList.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        'Search',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )
                      : Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),

              ),
              onChanged: (val) {
                print(';hitting in page');
                productController.searchProductByName(val);
                },
            ),
          ),
        ),
        actions: [
          if (widget.customerId != '' && widget.customerId != null)
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                child: FaIcon(
                  FontAwesomeIcons.barcode,
                  color: Colors.black,
                ),
              ),
            ),
          if (widget.customerId != '' && widget.customerId != null)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  // Get.to(() => CartScreen(customerId: widget.customerId));
                },
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => productController.productList.isEmpty
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 40,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: ((context) => AddProduct()),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 30,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: Colors.grey.shade600,
                              size: 17,
                            ),
                            Text(
                              "Add New Product",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Obx(() {
              return productController.isLoading.value
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: 20, // shimmer count
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
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Obx(() {
                          if (productController.errorMessage.value.isNotEmpty) {
                            return Center(
                                child:
                                    Text(productController.errorMessage.value));
                          } else {
                           // final dataList = productController.filteredList;

                            // if (dataList.isEmpty) {
                            //   return Center(
                            //     child: Text(
                            //       'No Products Available', // Display "0" or a custom empty message
                            //       style: TextStyle(
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   );
                            // }
                            if (productController.filteredList.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Products Found',
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            }

                            return ListView.builder(
                              itemCount: productController.filteredList.length,
                              itemBuilder: (context, index) {
                                final product = productController.filteredList[index];

                                return IntrinsicHeight(
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 30,
                                                  child: Image.asset(
                                                    "lib/ui/assets/client.png",
                                                    height: 70,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            product["item_no"] ??
                                                                'Null',
                                                            style: const TextStyle(
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                  Text("₹ ${
                                                    product["price"].toString() ??
                                                        '--'}",
                                                    style: const TextStyle(
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      fontSize: 11,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                                  ),

                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        product['item_desc'] ??
                                                            'Null',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          CommonRichText(
                                                            label: "UoM: ",
                                                            value: product[
                                                                    "uom_code"] ??
                                                                '--',
                                                          ),
                                                          CommonRichText(
                                                            label: "GST: ",
                                                            value: product[
                                                                    "gst_rate"] ??
                                                                '--',
                                                          ),
                                                          // CommonRichText(
                                                          //   label: "Stock: ",
                                                          //   value: product[
                                                          //   "in_stock"] ??
                                                          //       '--',
                                                          // ),
                                                        ],
                                                      ),
                                                  SizedBox(height: 5),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      CommonRichText(
                                                        label: "HSN : ",
                                                        value: product[
                                                        "hsn_code"] ??
                                                            '--',
                                                      ),
                                                      CommonRichText(
                                                        label: "Stock: ",
                                                        value: product[
                                                        "in_stock"] ??
                                                            '--',
                                                      ),
                                                    ],
                                                  ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .end,
                                                        children: [
                                                          CommonRichText(
                                                            label: "Price : ",
                                                            value: product[
                                                            "price"] ??
                                                                '--',
                                                          ),

                                                        ],
                                                      ),

                                                      if (widget.customerId
                                                              ?.isNotEmpty ??
                                                          false)
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  decrementQuantity(
                                                                      index),
                                                              child: Container(
                                                                height: 26,
                                                                width: 35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .orange
                                                                      .withOpacity(
                                                                          0.2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: cartController
                                                                            .isLoading1
                                                                            .value ==
                                                                        false
                                                                    ? const Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            17,
                                                                        color: Colors
                                                                            .orange,
                                                                      )
                                                                    : Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                4),
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              123,
                                                                              0),
                                                                          strokeWidth:
                                                                              2,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 40,
                                                              child: qtyControllers
                                                                          .length >
                                                                      index
                                                                  ? TextField(
                                                                      controller:
                                                                          qtyControllers[
                                                                              index],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      readOnly:
                                                                          true,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  : null
                                                            ),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  incrementQuantity(
                                                                      index),
                                                              child: Container(
                                                                height: 26,
                                                                width: 35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .orange
                                                                      .withOpacity(
                                                                          0.2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: cartController
                                                                            .isLoading1
                                                                            .value ==
                                                                        false
                                                                    ? const Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            17,
                                                                        color: Colors
                                                                            .orange,
                                                                      )
                                                                    : Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                4),
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              123,
                                                                              0),
                                                                          strokeWidth:
                                                                              2,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
                    );
            }),


          ],
        ),
        // Obx(() => cartController.isLoading1.value
        //     ? Positioned.fill(
        //         child: Container(
        //           color: Colors.black54, // Semi-transparent background
        //           child: Center(child: CircularProgressIndicator()),
        //         ),
        //       )
        //     : null,
      ]),

      floatingActionButton:
      (_isAnyQuantityValid() &  (widget.customerId !=null))
          ? FloatingActionButton.extended(
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text(
        //     'Total Quantity: ${_calculateTotalQuantity()}',
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.back();
        },
        label: Text(
          'Continue',
          style: TextStyle(color: Colors.white),
        ),
      )
          : null,
    );
  }
}
