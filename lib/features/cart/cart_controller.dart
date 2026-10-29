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
  var isLoading4 = false.obs;
  var errorMessage4 = ''.obs;
  var response = {}.obs;

// void initState(){
//   clear();
// }

void clear(){
  cartlist.value.clear();
  totalorder.value = 0;
  totalamount.value = '';
  cartitems.value = [];
  }



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
        clear();
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
      BuildContext context, Map<String, dynamic> body,String page) async {
    try {
      isLoading2.value = true;
      final result =
          await cartDataSourceImpl.UpdatetoCart(context, body,page);
      return result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
        return {
          'success': false,
          'message': failure.message
        };
      }, (responseData) {
        cardupdate.value = responseData;
        print('***********add to cart data successfully fetched in controller');
        errorMessage2.value = '';
        isLoading2.value = false;
        return {'success': true, 'data': responseData};
      });
    } catch (e) {
      isLoading2.value = false;
      errorMessage2.value = 'An error occurred: ${e.toString()};';
      return {
        'success': false,
        'message': e.toString()
      };
    }
  }


  /////opportunity cart

  @override
  Future<dynamic> Opp_addToCart(BuildContext context, String productId, int productQty,
      String customerId, String cardcode, String page) async {
    try {
      isLoading.value = true;
      final result = await cartDataSourceImpl.Opp_AddToCart(
          context, productId, productQty, customerId, cardcode,page);
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
  Future<void> opp_fetchcartlist(BuildContext context, String customerId) async {
    print('fetching 1 api');
    try {
      isLoading1.value = true;
      final result =
      await cartDataSourceImpl.Opp_fetchcartliost(context, customerId);
      result.fold((failure) {
        isLoading1.value = false;
        errorMessage1.value = 'Error: ${failure.message}';
      }, (responseData) {
        clear();
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
  // @override
  // Future<dynamic> opp_CartUpdate(
  //     BuildContext context, Map<String, dynamic> body, int cartId) async {
  //   try {
  //     isLoading2.value = true;
  //     final result =
  //     await cartDataSourceImpl.UpdatetoCart(context, body, cartId);
  //     result.fold((failure) {
  //       isLoading2.value = false;
  //       errorMessage2.value = 'Error: ${failure.message}';
  //     }, (responseData) {
  //       cardupdate.value = responseData;
  //       print('********** cart updated successfully fetched in controller');
  //       errorMessage2.value = '';
  //       isLoading2.value = false;
  //       return responseData;
  //     });
  //   } catch (e) {
  //     isLoading2.value = false;
  //     errorMessage2.value = 'An error occurred: ${e.toString()};';
  //   }
  // }


  ///order

  @override
  Future<dynamic> Order_addToCart(BuildContext context, String productId, int productQty,
      String customerId, String cardcode) async {
    try {
      isLoading.value = true;
      final result = await cartDataSourceImpl.order_AddToCart(
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
  Future<void> order_fetchcartlist(BuildContext context, String customerId) async {
    print('fetching 1 api');
    try {
      isLoading1.value = true;
      final result =
      await cartDataSourceImpl.order_fetchcartliost(context, customerId);
      result.fold((failure) {

        isLoading1.value = false;
        errorMessage1.value = 'Error: ${failure.message}';
      }, (responseData) {
        clear();
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

  // @override
  // Future<dynamic> order_CartUpdate(
  //     BuildContext context, Map<String, dynamic> body, int cartId) async {
  //   try {
  //     isLoading2.value = true;
  //     final result =
  //     await cartDataSourceImpl.UpdatetoCart(context, body, cartId);
  //     result.fold((failure) {
  //       isLoading2.value = false;
  //       errorMessage2.value = 'Error: ${failure.message}';
  //     }, (responseData) {
  //       cardupdate.value = responseData;
  //       print('********** cart updated successfully fetched in controller');
  //       errorMessage2.value = '';
  //       isLoading2.value = false;
  //       return responseData;
  //     });
  //   } catch (e) {
  //     isLoading2.value = false;
  //     errorMessage2.value = 'An error occurred: ${e.toString()};';
  //   }
  // }







  ///copy to quatation and order
   @override
    Future<Map<String, dynamic>> ConvertOQ_QO(BuildContext context, String oppId,String customerId,String page) async {
      print('fetching 1 api');
      try {
        isLoading4.value = true;
        final result =
        await cartDataSourceImpl.ConvertOQ_QO(context, oppId,customerId,page);
        return result.fold((failure) {
          isLoading4.value = false;
          errorMessage4.value = 'Error: ${failure.message}';
          return {'success': false, 'message': 'Failed to convert opportunity'};
          },
                (responseData) {
          response.value = responseData;
          errorMessage4.value = '';
          isLoading4.value = false;
          print('contttt$responseData');
          return responseData;
         // return {'success': true, 'data': responseData};
        });
      } catch (e) {
        isLoading4.value = false;
        errorMessage4.value = 'An error occurred: ${e.toString()};';
        return {'success': false, 'message': 'Failed to convert opportunity'};

      }
    }
  @override
  Future<dynamic> fetchConvertCart(BuildContext context, String customerId,String page) async {
    print('fetching 1 api');
    try {
      isLoading1.value = true;
      final result =
      await cartDataSourceImpl.fetchConvertcart(context, customerId, page);
      result.fold((failure) {
        isLoading1.value = false;
        errorMessage1.value = 'Error: ${failure.message}';
      }, (responseData) {
        clear();
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
  Future<dynamic> Convert_addToCart(BuildContext context, String productId, int productQty,
      String customerId, String cardcode,String page) async {
    try {
      isLoading.value = true;
      final result = await cartDataSourceImpl.Con_AddToCart(
          context, productId, productQty, customerId, cardcode,page);
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

}
