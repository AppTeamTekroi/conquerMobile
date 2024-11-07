import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vconquer/features/products/product_source.dart';



class ProductController extends GetxController {
  final ProductDataSourceImpl productDataSourceImpl = ProductDataSourceImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var productList = [].obs;
  var distributor = [].obs;
  var subdistributor = [].obs;
  var errorMessage1 = ''.obs;
  var isLoading1 = false.obs;
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;

  @override
  Future<void> fetchproducts(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading.value = true;
      final result = await productDataSourceImpl.fetchproducts(
          context);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },
              (responseData) {
            productList.value = responseData;
           // print('***********Product data successfully fetched in controller');
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

