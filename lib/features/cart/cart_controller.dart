import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'cart_source.dart';

class CartController extends GetxController {
  final CartDataSourceImpl cartDataSourceImpl = CartDataSourceImpl();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var cartlist = {}.obs;
  var addtocart = {}.obs;
  var postorder = {}.obs;
  var errorMessage1 = ''.obs;
  var isLoading1 = false.obs;
  var cardupdate = {}.obs;
  var errorMessage2 = ''.obs;
  var isLoading2 = false.obs;
  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;
  var totalorder = 0.obs;
  var totalamount = ''.obs;
  var cartitems = [].obs;

  @override
  Future<dynamic> addToCart(BuildContext context, String productId, int productQty,
      String customerId, String cardcode) async {
    try {
      isLoading.value = true;
      final result = await cartDataSourceImpl.AddToCart(
          context, productId, productQty, customerId, cardcode);
      return result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
        return {
          'success': false,
          'message': failure.message
        };
      }, (responseData) {
        addtocart.value = responseData;
        print('***********add to cart data successfully fetched in controller');
        errorMessage.value = '';
        isLoading.value = false;
        return {'success': true, 'data': responseData};
      });
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
      return {
        'success': false,
        'message': e.toString()
      };
    }
  }

  @override
  Future<void> fetchcartlist(BuildContext context, String customerId) async {
    print('fetching 1 api');
    try {
      isLoading1.value = true;
      final result =
          await cartDataSourceImpl.fetchcartliost(context, customerId);
      result.fold((failure) {
        isLoading1.value = false;
        errorMessage1.value = 'Error: ${failure.message}';
      }, (responseData) {
        cartlist.value = responseData;
         totalorder.value = cartlist.value['total_quantity'];
         totalamount.value = (cartlist.value['total_amount']).toString();
         cartitems.value = cartlist.value['data'];
       // print('***********cart data successfully fetched in controller');
        errorMessage1.value = '';
        isLoading1.value = false;
      });
    } catch (e) {
      isLoading1.value = false;
      errorMessage1.value = 'An error occurred: ${e.toString()};';
    }
  }

  @override
  Future<dynamic> CartUpdate(
      BuildContext context, Map<String, dynamic> body, int cartId) async {
    try {
      isLoading2.value = true;
      final result =
          await cartDataSourceImpl.UpdatetoCart(context, body, cartId);
      result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
      }, (responseData) {
        cardupdate.value = responseData;
        print('********** cart updated successfully fetched in controller');
        errorMessage2.value = '';
        isLoading2.value = false;
        return responseData;
      });
    } catch (e) {
      isLoading2.value = false;
      errorMessage2.value = 'An error occurred: ${e.toString()};';
    }
  }

  @override
  Future<Map<String, dynamic>> PostOrder(BuildContext context,
      Map<String, dynamic> body, String customerId) async {
    try {
      isLoading3.value = true;
      final result =
          await cartDataSourceImpl.OrderStore(context, body, customerId);
      return result.fold((failure) {
        isLoading3.value = false;
        errorMessage3.value = 'Error: ${failure.message}';
        return {
          'success': false,
          'message': failure.message
        }; // Return a failure response
      }, (responseData) {
        postorder.value = responseData;
        print('********** order successfully fetched in controller');
        errorMessage3.value = '';
        isLoading3.value = false;
        return {'success': true, 'data': responseData};
      });
    } catch (e) {
      isLoading3.value = false;
      errorMessage2.value = 'An error occurred: ${e.toString()}';
      return {
        'success': false,
        'message': e.toString()
      }; // Return an error response
    }
  }
}
