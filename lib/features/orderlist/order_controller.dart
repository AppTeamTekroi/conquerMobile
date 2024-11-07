import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'order_source.dart';



class OrderPlacedController extends GetxController {
  final OrdersSourceImpl ordersSourceImpl = OrdersSourceImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var orderList = [].obs;


  @override
  Future<void> fetchOrders(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading.value = true;
      final result = await ordersSourceImpl.fetchorderlist(context);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },
              (responseData) {
            orderList.value = responseData['data'];
            print(
                '***********Order data successfully fetched in controller');
            errorMessage.value = '';
            isLoading.value = false;
          }
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
    }
  }
}