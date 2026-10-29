import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'customer_source.dart';

class CustomerController extends GetxController {
  final CustomerSourceImpl _customerSourceImpl = CustomerSourceImpl();
  // var isLoading = false.obs;
  // var errorMessage = ''.obs;
  var customers = {}.obs;
  var customersID = {}.obs;
  var errorMessage1 = ''.obs;
  var isLoading1 = false.obs;
  var filteredcust = [].obs;
 // var customerslist = [].obs;

  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;

  var customerslist = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentPage = 1.obs; // Start from page 1
  var isLastPage = false.obs; // Track if it's the last page
  var isLoadingMore = false.obs; // Track pagination loading state
  var searchQuery = ''.obs;



  //Add Customer details
  var cust_name = "".obs;
  var lead = ''.obs;
  var salesEmp = "".obs;
  var category = "".obs;
  var Subcategory = "".obs;
  var leadtype = ''.obs;
  var leadsource = ''.obs;
  var dial_code = "".obs;
  var mobileNumber1 = "".obs;
  var mobileNumber2 = "".obs;

  var email = "".obs;
  var gstNumber_billing = "".obs;
  var gstNumber_shipping = "".obs;

  var companyName = "".obs;
  var postData = false.obs;
  var detailLoading = false.obs;
  var leadsourcenew = "".obs;
  var notes = "".obs;
  var expectedDate = "".obs;
  var address_1_billing = "".obs;
  var country_billing = "".obs;
  var pincode_billing = "".obs;
  var city_billing = "".obs;
  var state_billing = "".obs;
  var billing_same_as_shipping = 0.obs;
  var address_1_shipping = "".obs;
  var country_shipping = "".obs;
  var pincode_shipping = "".obs;
  var city_shipping = "".obs;
  var state_shipping = "".obs;
  var searchCustomer = "".obs;

  var oem = "".obs;
  var size = "".obs;
  var solutionarchitech = "".obs;


  void removeContact(int index) {
    contact_name.removeAt(index);
    contact_desig.removeAt(index);
    contact_email.removeAt(index);
    phoneNumber.removeAt(index);
    altPhoneNumber.removeAt(index);
  }
  List<dynamic> phoneNumber = [].obs;
  List<dynamic> altPhoneNumber = [].obs;
  List<dynamic> contact_email = [].obs;
  List<dynamic> contact_name = [].obs;
  List<dynamic> contact_desig = [].obs;

  var altphoneNumber = "".obs;
  // var contact_email = "".obs;
  // var contact_name = "".obs;
  // var contact_desig = "".obs;

   ////////

  // void searchProductByName(String query) {
  //   print(';hitting in controller: $query');
  //
  //   if (query.isEmpty) {
  //     filteredcust.value = customerslist;
  //   } else {
  //     filteredcust.value = customerslist.where((product) {
  //       // final itemNo = product['web_id']?.toString().toLowerCase() ?? '';
  //       final itemNo = product['card_name']?.toString().toLowerCase() ?? '';
  //
  //       return itemNo.contains(query.toLowerCase());
  //     }).toList();
  //   }
  //
  //   filteredcust.refresh(); // Force the UI to refresh
  //   update(); // Notify GetX to update the UI
  //
  //   // Print the filtered list for debugging
  //   print('Filtered List Length: ${filteredcust.length}');
  //   for (var product in filteredcust) {
  //     print('Product Item No: ${product['item_no']}');
  //   }
  // }

  void addContact(String name, String desig, String phone, String altphone, String email){
    contact_name.add(name);
    contact_desig.add(desig);
    phoneNumber.add(phone);
    altPhoneNumber.add(altphone);
    contact_email.add(email);
  }

  void initializeVariables({bool billing = false, bool shipping = false}) {
    if (billing) {
      gstNumber_billing.value = '';
      address_1_billing.value = '';
      pincode_billing.value = '';
      city_billing.value = '';
      state_billing.value = '';
      country_billing.value = '';
    }
    if (shipping) {
      gstNumber_shipping.value = '';
      address_1_shipping.value = '';
      pincode_shipping.value = '';
      city_shipping.value = '';
      state_shipping.value = '';
      country_shipping.value = '';
    }
  }
  @override
  Future<void> fetchUser({bool isPagination = false}) async {
    try {
      if (!isPagination) {
        isLoading.value = true;
        customerslist.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await _customerSourceImpl.fetchcustomer( currentPage.value,searchQuery.value);

      result.fold((failure) {
        errorMessage.value = 'Error: ${failure.message}';
      }, (responseData) {
        if (responseData['data'].isNotEmpty) {
          customerslist.addAll(responseData['data']); // Append new data
          filteredcust.assignAll(customerslist); // Update displayed list
          currentPage.value++; // Increment page number
        } else {
          isLastPage.value = true; // No more data
        }
        errorMessage.value = '';
      });
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false; // Reset loading state
    }
  }


  // Future<void> fetchUser(BuildContext context) async {
  //   print('fetching 1 api');
  //   try {
  //     isLoading.value = true;
  //     final result = await customerSourceRepository.fetchcustomer(context);
  //     result.fold((failure) {
  //       isLoading.value = false;
  //       errorMessage.value = 'Error: ${failure.message}';
  //     }, (responseData) {
  //       customers.value = responseData;
  //       customerslist.value = responseData['data'];
  //
  //       errorMessage.value = '';
  //       isLoading.value = false;
  //     });
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = 'An error occurred: ${e.toString()};';
  //   }
  // }

  // @override
  // Future<void> fetchUser(BuildContext context) async {
  //   print('fetching 1 api');
  //   try {
  //     isLoading.value = true;
  //     final result = await customerSourceRepository.fetchcustomer(context);
  //     result.fold((failure) {
  //       isLoading.value = false;
  //       errorMessage.value = 'Error: ${failure.message}';
  //     }, (responseData) {
  //       customers.value = responseData;
  //       customerslist.value = responseData['data'];
  //       filteredcust.value = responseData['data'];
  //
  //       // print('***********Duty data successfully fetched in controller');
  //       errorMessage.value = '';
  //       isLoading.value = false;
  //     });
  //   } catch (e) {
  //     isLoading.value = false;
  //     errorMessage.value = 'An error occurred: ${e.toString()};';
  //   }
  // }

  Future<void> fetchUserID(BuildContext context, int id) async {
    print('fetching edit api');
    try {
      isLoading1.value = true;
      final result = await _customerSourceImpl.fetchid(context, id);
      result.fold((failure) {
        isLoading1.value = false;
        errorMessage1.value = 'Error: ${failure.message}';
      }, (responseData) {
        customersID.value = responseData;
        // print('***********ID data successfully fetched in controller');
        errorMessage1.value = '';
        isLoading1.value = false;
      });
    } catch (e) {
      isLoading1.value = false;
      errorMessage1.value = 'An error occurred: ${e.toString()};';
    }
  }

  @override
  Future<dynamic> postCustomerData(BuildContext context) async {
    print('fetching 1 api');
    var data = jsonEncode({

      "card_name": cust_name.value,
      "u_trpbpnm": cust_name.value,
      "customer_types": lead.value,
      "lead_type": leadtype.value,
      "lead_source": leadsource.value,
      "define_new": leadsourcenew.value,
      "sales_name": salesEmp.value,
      "notes": notes.value,
      "email": email.value,
      "phone1": mobileNumber1.value,
      // "phone2": mobileNumber2.value,

      "category": category.value,
      "subcategory": Subcategory.value,
      "exp_conversion_date": expectedDate.value,
      "oem_list" : oem.value,
      "opportunity_size":size.value,
      "solution_architect_name":solutionarchitech.value,

      "billing_same_as_shipping": billing_same_as_shipping.value,
      "gst_number": gstNumber_shipping.value,
      "street": address_1_shipping.value,
      "country": country_shipping.value,
      "state": state_shipping.value,
      "new_city": city_shipping.value,
      "zip_code": pincode_shipping.value,

      "gst_number_billing": gstNumber_billing.value,
      "street_billing": address_1_billing.value,
      "country_billing": country_billing.value,
      "state_billing": state_billing.value,
      "new_city_billing": city_billing.value,
      "zip_code_billing": pincode_billing.value,

      // Contact arrays
      "gst_cnt_name": contact_name,
      "gst_cnt_desig": contact_desig,
      "gst_cnt_contactno": phoneNumber,
      "gst_cnt_tel1": altPhoneNumber,
      "gst_cnt_email": contact_email,
    });
    print(data);

    try {
      isLoading3.value = true;
      final result = await _customerSourceImpl.storeCustomer(context, data);
      var responseData;

      result.fold((failure) {
        isLoading3.value = false;
        errorMessage3.value = 'Error: ${failure.message}';
        // responseData.clear();
        responseData = failure.message;
      },
            (res) => responseData = res,

      );
      isLoading3.value = false;

      return responseData;

    } catch (e) {
      isLoading3.value = false;
      errorMessage3.value = 'An error occurred: ${e.toString()}';
      print('Exception: $e');
      throw Exception(errorMessage3.value);
    }
  }
}
