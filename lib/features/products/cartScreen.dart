// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:shaurya_erp/features/products/product_controller.dart';
// import '../../ui/Buttons/buttonBS.dart';
// import '../../ui/color/appColor.dart';
// import '../cart/cart_controller.dart';
//
// class CartScreen extends StatefulWidget {
//   final String? customerId;
//   CartScreen({super.key, required this.customerId});
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// List<TextEditingController> qtyControllers = [];
//
// class _CartScreenState extends State<CartScreen> {
//   final ProductController pc = Get.put(ProductController());
//   final CartController cc = Get.put(CartController());
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       cartlist();
//     });
//   }
//
//   Future<void> cartlist() async {
//     await cc.fetchcartlist(context, widget.customerId!);
//   }
//
//   // @override
//   // void dispose() {
//   //   // Dispose of the TextEditingControllers to prevent memory leaks
//   //   for (var controller in qtyControllers) {
//   //     controller.dispose();
//   //   }
//   //   super.dispose();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         toolbarHeight: 70,
//         leadingWidth: 40,
//         backgroundColor: AppColors.white,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 12),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: const Icon(
//               Icons.arrow_back_ios_sharp,
//               size: 20,
//             ),
//           ),
//         ),
//         title: const Text('Cart'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Obx(() {
//             if (cc.isLoading1.value) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (cc.errorMessage1.value.isNotEmpty) {
//               return Center(child: Text(cc.errorMessage1.value));
//             } else {
//               final dataList = cc.cartlist.value;
//               final maplist = dataList is Map<dynamic, dynamic> ? dataList : {};
//               final list = maplist['result'] is Map<dynamic, dynamic>
//                   ? maplist['result']
//                   : {};
//               final result = list["data"] is List<dynamic> ? list["data"] : [];
//
//               if (result.isEmpty) {
//                 return const Center(child: Text('No products in cart'));
//               }
//
//               return Expanded(
//                 // Use Expanded to make the list scrollable
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
//                   child: ListView.builder(
//                     itemCount: result.length,
//                     itemBuilder: (context, index) {
//                       final item = result[index] as Map<String, dynamic>;
//
//                       // Add controllers for each item if not already added
//                       if (qtyControllers.length < result.length) {
//                         qtyControllers.add(TextEditingController());
//                       }
//
//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 5),
//                         decoration: BoxDecoration(
//                           color: AppColors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // Expanded around the Text to take up the remaining space
//                                   Expanded(
//                                     child: Container(
//                                       child: Text(
//                                         "${item['product']["name"] ?? ''}",
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.normal,
//                                           overflow: TextOverflow.clip,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   // IconButton at the end
//                                   // IconButton(
//                                   //   onPressed: () async {
//                                   //     int cartId = item['id'];
//                                   //     final body = {
//                                   //       "status": 0,
//                                   //     };
//                                   //     await cc.CartUpdate(context, body, cartId);
//                                   //     Fluttertoast.showToast(
//                                   //       msg: "Cart Item removed",
//                                   //       toastLength: Toast.LENGTH_SHORT,
//                                   //       gravity: ToastGravity.CENTER,
//                                   //       timeInSecForIosWeb: 1,
//                                   //       backgroundColor: Colors.green.shade100,
//                                   //       textColor: Colors.black,
//                                   //       fontSize: 16.0,
//                                   //     );
//                                   //     await cc.fetchcartlist(context, widget.customerId!);
//                                   //   },
//                                   //   icon: Icon(Icons.close_outlined),
//                                   // ),
//
//                                   GestureDetector(
//                                   onTap: () async {
//                                     int cartId = item['id'];
//                                     final body = {
//                                       "status": 0,
//                                     };
//                                     await cc.CartUpdate(context, body, cartId);
//                                     Fluttertoast.showToast(
//                                       msg: "Cart Item removed",
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.CENTER,
//                                       timeInSecForIosWeb: 1,
//                                       backgroundColor: Colors.green.shade100,
//                                       textColor: Colors.black,
//                                       fontSize: 16.0,
//                                     );
//                                     await cc.fetchcartlist(context, widget.customerId!);
//
//                                    },
//                                   child: Container(
//                                     height: 26,
//                                     width: 35,
//                                     decoration: BoxDecoration(
//                                         color: Colors.orange.withOpacity(0.2),
//                                         borderRadius: BorderRadius.circular(15)),
//                                     // backgroundColor: selectedQty.value > 0
//                                     //     ? AppColors.mainblue
//                                     //     : Colors.grey,
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 0, vertical: 0),
//                                       child: const Icon(
//                                         Icons.close,
//                                         size: 18,
//                                         color: Colors.orange,
//                                       ),
//                                     ),
//                                   ),
//
//                                   ),
//
//
//                                 ],
//                               ),
//                               Container(
//                                 width: Get.width * 0.46,
//                                 child: Text.rich(
//                                   TextSpan(
//                                     children: [
//                                       const TextSpan(
//                                         text: 'Price: ',
//                                         style: TextStyle(fontWeight: FontWeight.w400),
//                                       ),
//                                       TextSpan(
//                                         text: (item["price"]?.toString() ?? '--'),
//                                         style: const TextStyle(fontWeight: FontWeight.normal),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//
//                               Container(
//                                 // width: Get.width * 0.46,
//                                 child: Text.rich(
//                                   TextSpan(
//                                     children: [
//                                       const TextSpan(
//                                         text: 'Total Amount: ',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       TextSpan(
//                                         text:
//                                             (item["total_amount"]?.toString() ??
//                                                 '--'),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 // width: Get.width * 0.46,
//                                 child: Text.rich(
//                                   TextSpan(
//                                     children: [
//                                       const TextSpan(
//                                         text: 'Quantity: ',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       TextSpan(
//                                         text: (item["quantities"]?.toString() ??
//                                             '--'),
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     width: Get.width * 0.4,
//                                     height: 30,
//                                     child: TextField(
//                                       controller: qtyControllers[index],
//                                       keyboardType: TextInputType.number,
//                                       decoration: InputDecoration(
//                                         hintText: "Add More Quantity",
//                                         border: OutlineInputBorder(),
//                                         contentPadding: EdgeInsets.symmetric(
//                                             vertical: 5, horizontal: 10),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 1),
//                                   ButtonBS(
//                                     title: 'ADD',
//                                     textColor: Colors.white,
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600,
//                                     padding: 0.0,
//                                     backgroundColor: Colors.orange[500],
//                                     borderRadius: 20,
//                                     onPressed: () {
//                                       int? quantity = int.tryParse(
//                                           qtyControllers[index].text);
//                                       if (quantity != null && quantity > 0) {
//                                         FocusScope.of(context).unfocus();
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           SnackBar(
//                                               content: Text(
//                                                   'Please enter a quantity greater than zero.')),
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             }
//           }),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 90,
//         decoration: const BoxDecoration(color: Colors.white),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Total Amount',
//                 style:
//                     TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//               ),
//               Obx(() => Text(
//                     '₹${cc.totalorder.value}',
//                     style: const TextStyle(
//                         color: Colors.black, fontWeight: FontWeight.w600),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
