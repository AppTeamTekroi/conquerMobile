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
            print('***********Duty data successfully fetched in controller');
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
            print('***********ID data successfully fetched in controller');
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