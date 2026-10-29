import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:vconquer/features/cart/cart_controller.dart';
import 'package:vconquer/ui/Buttons/CustomButton.dart';

import 'Buttons/buttonBS.dart';
import 'color/appColor.dart';

class CartUpdateSheet extends StatefulWidget {
  final Map<String, dynamic> items;
  final String name;
  final String page;

  final String cardcode;

  const CartUpdateSheet({super.key, required this.items, required this.name,required this.page,required this.cardcode});

  @override
  State<CartUpdateSheet> createState() => _CartUpdateSheetState();
}

class _CartUpdateSheetState extends State<CartUpdateSheet> {
  late TextEditingController dis;
  late TextEditingController quantity;

  late double areaprice;
  late double discountValue;
  late double priceAfterDiscount;
  late double totalAfterDiscount;
  late double gstRate;
  late double gstValue;
  late double subtotal;

  CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();

    // Initialize controllers with item values
    dis = TextEditingController(text: widget.items['disc_percent'].toString());
    quantity = TextEditingController(text: widget.items['quantity'].toString());

    areaprice = (widget.items['price'] ?? 0).toDouble();
    discountValue = (widget.items['disc_value'] ?? 0).toDouble();
    priceAfterDiscount = (widget.items['price_af_disc'] ?? 0).toDouble();
    totalAfterDiscount = (widget.items['price_total_af_disc'] ?? 0).toDouble();
    gstRate = (widget.items['gst_rate'] ?? 0).toDouble();
    gstValue = (widget.items['gst_value'] ?? 0).toDouble();
    subtotal = (widget.items['subtotal'] ?? 0).toDouble();

    // Add listeners to recalculate values dynamically
    dis.addListener(_calculateTotals);
    quantity.addListener(_calculateTotals);
  }

  @override
  void dispose() {
    dis.dispose();
    quantity.dispose();
    super.dispose();
  }

  void _calculateTotals() {
    setState(() {
      double unitPrice = areaprice;
      int qty = int.tryParse(quantity.text) ?? 0;
      double discountPercent = double.tryParse(dis.text) ?? 0;

      discountValue = unitPrice * discountPercent / 100;
      priceAfterDiscount = unitPrice - discountValue;
      totalAfterDiscount = qty * priceAfterDiscount;
      gstValue = (totalAfterDiscount * gstRate) / 100;
      subtotal = totalAfterDiscount + gstValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.of(context).size.height;
    final width =MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
          // Text(
          //     widget.cardcode ,
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   overflow: TextOverflow.ellipsis,
          //   maxLines: 1,
          // ),

          const Divider(thickness: 1, color: Colors.grey),

          Row(
            children: [
              Expanded(child: _buildTextField('Discount %', dis)),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField('Quantity', quantity)),
            ],
          ),
          const SizedBox(height: 5),

          Row(
        children: [
           Text(
            "Remove Quantity to delete the item from cart",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
          const SizedBox(height: 10),

          // Calculated Values
          _buildCalculationRow('Unit Price:', areaprice.toStringAsFixed(2)),
          const SizedBox(height: 10),

          _buildCalculationRow('Discount Value:', discountValue.toStringAsFixed(2)),
          const SizedBox(height: 10),

          _buildCalculationRow('Price After Discount:', priceAfterDiscount.toStringAsFixed(2)),
          const SizedBox(height: 10),

          _buildCalculationRow('Total After Discount:', totalAfterDiscount.toStringAsFixed(2)),
          const SizedBox(height: 10),

          _buildCalculationRow('GST:', gstValue.toStringAsFixed(2)),
          const SizedBox(height: 10),

          _buildCalculationRow('Subtotal:', subtotal.toStringAsFixed(2)),

          const SizedBox(height: 20),

          // Update Button

          Padding(
            padding: const EdgeInsets.only(bottom: 17.0),
            child: ButtonBS(title: 'Update',
              textColor: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              width: width * 0.4,
              height: height * 0.04,
              padding: 5.0,
              backgroundColor: AppColors.blu,
              borderRadius: 12,
              suffixIcon: Icons.arrow_forward_ios,
              suffixIconColor: Colors.white,
              suffixIconSize: 18,
              prefixIconSize: 0,
              separateSuffixIcon: 5,
              onPressed: () async {
                final body = {
                  "productId": widget.items['item_id'],
                  //card_code
                "customer_code": widget.cardcode,
                "customerId": widget.items['customer_id'],
                "quantities": quantity.text,
                "discount": dis.text,
                };

               if(widget.items['quantity'] != quantity.text || widget.items['disc_percent'] != dis.text) {
                     var response =await cartController.CartUpdate(context, body, widget.page);
                     var decodedvalue = response;
                     print('-----------$decodedvalue');
                     print(decodedvalue['success']);
                   //  print(decodedvalue['data']['message']);
                     if (decodedvalue !=null && decodedvalue['success'] == true) {
                    //   print(decodedvalue['data']['message']);
                    //    Fluttertoast.showToast(
                    //      msg: 'Updated',
                    //      toastLength: Toast.LENGTH_SHORT,
                    //      gravity: ToastGravity.CENTER,
                    //      backgroundColor: Colors.green.shade100,
                    //      textColor: Colors.black,
                    //      fontSize: 16.0,
                    //    );
                       Navigator.pop(context);
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Updated successfully!',style: TextStyle(color: Colors.black),),backgroundColor:Colors.green.shade100),
                       );
                       setState(() {}); // Refresh UI after update

                       if (widget.page == 'quotation')
                         await cartController.fetchcartlist(
                             context, (widget.items['customer_id']!).toString());
                       if (widget.page == 'opportunity')
                         await cartController.opp_fetchcartlist(
                             context, (widget.items['customer_id']!).toString());
                       if (widget.page == 'order')
                         await cartController.order_fetchcartlist(
                             context, (widget.items['customer_id']!).toString());
                       if (widget.page == 'co-quotation')
                         await cartController.fetchConvertCart(
                             context, (widget.items['customer_id']).toString(), 'cqo');
                       if (widget.page == 'co-opportunity')
                         await cartController.fetchConvertCart(
                             context, (widget.items['customer_id']).toString(), 'coq');
                     }

               }
               else{
                 // Fluttertoast.showToast(
                 //   msg: "No changes committed",
                 //   toastLength: Toast.LENGTH_SHORT,
                 //   gravity: ToastGravity.CENTER,
                 //   backgroundColor: Colors.green.shade100,
                 //   textColor: Colors.black,
                 //   fontSize: 16.0,
                 // );
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('No changes committed')),
                       );
               }

              },
            ),
          ),




        ],
      ),
    );
  }

  // Helper Method for Text Fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,

      ),
      keyboardType: TextInputType.number,
    );
  }

  // Helper Method for Calculation Rows
  Widget _buildCalculationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}
