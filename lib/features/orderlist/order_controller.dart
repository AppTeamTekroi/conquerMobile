import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'order_source.dart';



class OrderController extends GetxController {
  final OrdersSourceImpl ordersSourceImpl = OrdersSourceImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var orderList ={}.obs;
  var postorder = {}.obs;
  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;

  var currentPage = 1.obs;
  var isLastPage = false.obs; // Track if it's the last page
  var isLoadingMore = false.obs; // Track pagination loading state
  var searchQuery = ''.obs;
  var filteredcust = [].obs;

  @override
  Future<void> Orderlist({bool isPagination = false}) async {
    print('fetching 1 api');
    try {
      if (!isPagination) {
        isLoading.value = true;
        orderList.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await ordersSourceImpl.fetchorderlist(currentPage.value,searchQuery.value);

      result.fold((failure) {
        errorMessage.value = 'Error: ${failure.message}';
      },
              (responseData) {
                if (responseData.isNotEmpty) {
                  orderList.addAll(responseData);
                  filteredcust.addAll(responseData['data']);

                  // Append new data
                  currentPage.value++; // Increment page number
                } else {
                  isLastPage.value = true;
                  isLoading.value = false;// No more data
                }
          //  orderList.value = responseData;
            print('***********Order data successfully fetched in controller');
            errorMessage.value = '';
             isLoading.value = false;
          });
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
    }finally {
      isLoading.value = false;
      isLoadingMore.value = false; // Reset loading state
    }
  }
  @override
  Future<Map<String, dynamic>> PostOrder(
      Map<String, dynamic> body, String customerId,File file) async {
    try {
      isLoading3.value = true;
      final result =
      await ordersSourceImpl.StoreOrder( body, customerId,file);
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
        if(responseData['success'] == true) {
          return {'success': true, 'data': responseData};

        }else{
          return {'success': false, 'data': responseData};
        }
      //  return {'success': true, 'data': responseData};
      });
    } catch (e) {
      isLoading3.value = false;
      errorMessage3.value = 'An error occurred: ${e.toString()}';
      return {
        'success': false,
        'message': e.toString()
      }; // Return an error response
    }
  }
}