import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dropdown_source.dart';


class DropdownController extends GetxController {
  final DropdownSourceImpl dropdownSourceImpl = DropdownSourceImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var branch = [].obs;
  var categories = [].obs;
  var subCategories = [].obs;
  var salesEmpName = [].obs;
  var countries = [].obs;
  var searchByGstin = [].obs;
  var errorMessage1 = ''.obs;
  var errorMessage2 = ''.obs;
  var errorMessage3= ''.obs;
  var errorMessage4 = ''.obs;
  var errorMessage5 = ''.obs;
  var isLoading1 = false.obs;
  var isLoading2 = false.obs;
  var isLoading3 = false.obs;
  var isLoading4 = false.obs;
  var isLoading5 = false.obs;

  var contact = [].obs;
  var isLoading6 = false.obs;
  var errorMessage6 = ''.obs;

  var shipping = [].obs;
  var isLoading7 = false.obs;
  var errorMessage7 = ''.obs;

  var billing = [].obs;
  var isLoading8 = false.obs;
  var errorMessage8 = ''.obs;



  var payterm = [].obs;
  var isLoading9 = false.obs;
  var errorMessage9 = ''.obs;






  @override
  Future<void> fetchbranches(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading.value = true;
      final result = await dropdownSourceImpl.fetchbranches(context);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },
              (responseData) {
            branch.value = responseData;
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

  @override
  Future<void> fetchcategories(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading1.value = true;
      final result = await dropdownSourceImpl.fetchcategories(context);
      result.fold((failure) {
        isLoading1.value = false;
        errorMessage1.value = 'Error: ${failure.message}';
      },
              (responseData) {
            categories.value = responseData;
            print('***********Duty data successfully fetched in controller');
            errorMessage1.value = '';
            isLoading1.value = false;
          }
      );
    } catch (e) {
      isLoading1.value = false;
      errorMessage1.value = 'An error occurred: ${e.toString()};';
    }
  }

  @override
  Future<void> fetchsubCategories(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading2.value = true;
      final result = await dropdownSourceImpl.fetchsubCategories(context);
      result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
      },
              (responseData) {
            subCategories.value = responseData;
            print('***********Duty data successfully fetched in controller');
            errorMessage2.value = '';
            isLoading2.value = false;
          }
      );
    } catch (e) {
      isLoading2.value = false;
      errorMessage2.value = 'An error occurred: ${e.toString()};';
    }
  }

  @override
  Future<void> fetchsalesEmpName(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading3.value = true;
      final result = await dropdownSourceImpl.fetchsalesEmpName(context);
      result.fold((failure) {
        isLoading3.value = false;
        errorMessage3.value = 'Error: ${failure.message}';
      },
              (responseData) {
            salesEmpName.value = responseData;
            print('***********Duty data successfully fetched in controller');
            errorMessage3.value = '';
            isLoading3.value = false;
          }
      );
    } catch (e) {
      isLoading3.value = false;
      errorMessage3.value = 'An error occurred: ${e.toString()};';
    }
  }

  @override
  Future<void> fetchcountries(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading4.value = true;
      final result = await dropdownSourceImpl.fetchcountries(context);
      result.fold((failure) {
        isLoading4.value = false;
        errorMessage4.value = 'Error: ${failure.message}';
      },
              (responseData) {
            countries.value = responseData;
            print('***********Duty data successfully fetched in controller');
            errorMessage4.value = '';
            isLoading4.value = false;
          }
      );
    } catch (e) {
      isLoading4.value = false;
      errorMessage4.value = 'An error occurred: ${e.toString()};';
    }
  }

  @override
  Future<void> fetchsearchByGstin(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading5.value = true;
      final result = await dropdownSourceImpl.fetchsearchByGstin(context);
      result.fold((failure) {
        isLoading5.value = false;
        errorMessage5.value = 'Error: ${failure.message}';
      },
              (responseData) {
            searchByGstin.value = responseData;
            print('***********Duty data successfully fetched in controller');
            errorMessage5.value = '';
            isLoading5.value = false;
          }
      );
    } catch (e) {
      isLoading5.value = false;
      errorMessage5.value = 'An error occurred: ${e.toString()};';
    }
  }
  @override
  Future<void> fetchcontact(BuildContext context,String customerId) async {
    print('fetching 1 api');
    try {
      isLoading6.value = true;
      final result = await dropdownSourceImpl.fectchcontact(context,customerId);
      result.fold((failure) {
        isLoading6.value = false;
        errorMessage6.value = 'Error: ${failure.message}';
      },
              (responseData) {
            contact.value = responseData;
           // print('***********contact data successfully fetched in controller');
            errorMessage6.value = '';
            isLoading6.value = false;
          }
      );
    } catch (e) {
      isLoading6.value = false;
      errorMessage6.value = 'An error occurred: ${e.toString()};';
    }
  }
  @override
  Future<void> fetchshipping(BuildContext context,String customerId) async {
    print('fetching 1 api');
    try {
      isLoading7.value = true;
      final result = await dropdownSourceImpl.shippingaddress(context,customerId);
      result.fold((failure) {
        isLoading7.value = false;
        errorMessage7.value = 'Error: ${failure.message}';
      },
              (responseData) {
            shipping.value = responseData;
           // print('***********shipping data successfully fetched in controller');
            errorMessage7.value = '';
            isLoading7.value = false;
          }
      );
    } catch (e) {
      isLoading7.value = false;
      errorMessage7.value = 'An error occurred: ${e.toString()};';
    }
  }
  @override
  Future<void> fetchbilling(BuildContext context,String customerId) async {
    print('fetching 1 api');
    try {
      isLoading8.value = true;
      final result = await dropdownSourceImpl.billingaddress(context,customerId);
      result.fold((failure) {
        isLoading8.value = false;
        errorMessage8.value = 'Error: ${failure.message}';
      },
              (responseData) {
            billing.value = responseData;
            print('***********billing data successfully fetched in controller$responseData');
            errorMessage8.value = '';
            isLoading8.value = false;
          }
      );
    } catch (e) {
      isLoading8.value = false;
      errorMessage8.value = 'An error occurred: ${e.toString()};';
    }
  }
  @override
  Future<void> fetchpayterm(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading9.value = true;
      final result = await dropdownSourceImpl.Paymentaddress(context);
      result.fold((failure) {
        isLoading9.value = false;
        errorMessage9.value = 'Error: ${failure.message}';
      },
              (responseData) {
            payterm.value = responseData;
           // print('***********pay data successfully fetched in controller');
            errorMessage9.value = '';
            isLoading9.value = false;
          }
      );
    } catch (e) {
      isLoading9.value = false;
      errorMessage9.value = 'An error occurred: ${e.toString()};';
    }
  }
}