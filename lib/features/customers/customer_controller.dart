import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'customer_source.dart';


class CustomerController extends GetxController {
  final CustomerSourceImpl customerSourceRepository = CustomerSourceImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var customers = {}.obs;
  var customersID = {}.obs;
  var errorMessage1 = ''.obs;
  var isLoading1 = false.obs;
  var filteredcust = [].obs;
   var customerslist = [].obs;
  void searchProductByName(String query) {
    print(';hitting in controller: $query');

    if (query.isEmpty) {
      filteredcust.value = customerslist;
    } else {
      filteredcust.value = customerslist.where((product) {
        final itemNo = product['web_id']?.toString().toLowerCase() ?? '';
        return itemNo.contains(query.toLowerCase());
      }).toList();
    }

    filteredcust.refresh(); // Force the UI to refresh
    update(); // Notify GetX to update the UI

    // Print the filtered list for debugging
    print('Filtered List Length: ${filteredcust.length}');
    for (var product in filteredcust) {
      print('Product Item No: ${product['item_no']}');
    }
  }

  @override
  Future<void> fetchUser(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading.value = true;
      final result = await customerSourceRepository.fetchcustomer(context);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },
              (responseData) {
            customers.value = responseData;
            customerslist.value = responseData['data'];
            filteredcust.value = responseData['data'];

            // print('***********Duty data successfully fetched in controller');
            errorMessage.value = '';
            isLoading.value = false;
          }
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
    }
  }
  Future<void> fetchUserID(BuildContext context,int id) async {
    print('fetching edit api');
    try {
      isLoading1.value = true;
      final result = await customerSourceRepository.fetchid(context,id);
      result.fold((failure) {
        isLoading1.value = false;
        errorMessage1.value = 'Error: ${failure.message}';
      },
              (responseData) {
            customersID.value = responseData;
           // print('***********ID data successfully fetched in controller');
            errorMessage1.value = '';
            isLoading1.value = false;
          }
      );
    } catch (e) {
      isLoading1.value = false;
      errorMessage1.value = 'An error occurred: ${e.toString()};';
    }
  }
}