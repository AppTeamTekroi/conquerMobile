import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vconquer/features/products/product_source.dart';


// class ProductController extends GetxController {
//   final ProductDataSourceImpl productDataSourceImpl = ProductDataSourceImpl();
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   var productList = [].obs;
//   var filteredList = [].obs;
//   var distributor = [].obs;
//   var subdistributor = [].obs;
//   var errorMessage1 = ''.obs;
//   var isLoading1 = false.obs;
//   var isLoading2 = false.obs;
//   var errorMessage2 = ''.obs;
//
//   void searchProductByName(String query) {
//     if (query.isEmpty) {
//       filteredList.value = productList;
//     } else {
//       filteredList.value = productList
//           .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//   }
//   @override
//   void onInit() {
//     super.onInit();
//     filteredList.value = productList; // Initialize with the full list
//   }
//
//   @override
//   Future<void> fetchproducts(BuildContext context) async {
//     print('fetching 1 api');
//     try {
//       isLoading.value = true;
//       final result = await productDataSourceImpl.fetchproducts(
//           context);
//       result.fold((failure) {
//         isLoading.value = false;
//         errorMessage.value = 'Error: ${failure.message}';
//       },
//               (responseData) {
//             productList.value = responseData;
//            // print('***********Product data successfully fetched in controller');
//             errorMessage.value = '';
//             isLoading.value = false;
//           }
//       );
//     } catch (e) {
//       isLoading.value = false;
//       errorMessage.value = 'An error occurred: ${e.toString()};';
//     }
//   }
//   @override
//   Future<void> fetchQuatationproducts(BuildContext context,String customerId) async {
//     print('fetching 1 api');
//     try {
//       isLoading.value = true;
//       final result = await productDataSourceImpl.fetchQuatationproducts(
//           context,customerId);
//       result.fold((failure) {
//         isLoading.value = false;
//         errorMessage.value = 'Error: ${failure.message}';
//       },
//               (responseData) {
//             productList.value = responseData;
//             // print('***********Product data successfully fetched in controller');
//             errorMessage.value = '';
//             isLoading.value = false;
//           }
//       );
//     } catch (e) {
//       isLoading.value = false;
//       errorMessage.value = 'An error occurred: ${e.toString()};';
//     }
//   }
// }
//



class ProductController extends GetxController {
  final ProductDataSourceImpl productDataSourceImpl = ProductDataSourceImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var productList = [].obs;
  var filteredList = [].obs;
  var distributor = [].obs;
  var subdistributor = [].obs;
  var errorMessage1 = ''.obs;
  var isLoading1 = false.obs;
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;

  var searchQuery = ''.obs;
  var currentPage = 1.obs; // Start from page 1
  var isLastPage = false.obs; // Track if it's the last page
  var isLoadingMore = false.obs;

  void searchProductByName(String query) {
    print(';hitting in controller: $query');
    if (query.isEmpty) {
      filteredList.value = productList;
    } else {
      filteredList.value = productList.where((product) {
        final itemNo = product['item_no']?.toString().toLowerCase() ?? '';
        return itemNo.contains(query.toLowerCase());
      }).toList();
    }

    filteredList.refresh();
    update();
    print('Filtered List Length: ${filteredList.length}');
    for (var product in filteredList) {
      print('Product Item No: ${product['item_no']}');
    }
  }


  @override
  void onInit() {
    super.onInit();
    filteredList.value = productList;
    ever(filteredList, (_) {
      print('Updated filtered list: ${filteredList.length}');
    });// Initialize with the full list
  }

  Future<void> fetchproducts() async {
    try {
      isLoading.value = true;
      final result = await productDataSourceImpl.fetchproducts();
      result.fold(
            (failure) {
          isLoading.value = false;
          errorMessage.value = 'Error: ${failure.message}';
        },
            (responseData) {
          productList.value = responseData;
          filteredList.value = responseData;
          print('Initial Product List Length: ${productList.length}');
          errorMessage.value = '';
          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()}';
    }
  }

  Future<void> fetchQuatationproducts(String customerId, {bool isPagination = false}) async {
    try {
      if (!isPagination) {
        isLoading.value = true;
        productList.clear();
        currentPage.value = 1;
        isLastPage.value = false;
      } else {
        isLoadingMore.value = true;
      }
      final result =
      await productDataSourceImpl.fetchQuatationproducts( customerId, currentPage.value,searchQuery.value);
      result.fold(
            (failure) {
         // isLoading.value = false;
          errorMessage.value = 'Error: ${failure.message}';
        },
            (responseData) {
              if (responseData['data'].isNotEmpty) {
                productList.value = responseData['data'];
                filteredList.value = responseData['data'];

              //  filteredList.assignAll(productList); // Update displayed list
                currentPage.value++;
                // filteredList.value = responseData['data'];
                // currentPage.value++; // Increment page number
              } else {
                isLastPage.value = true; // No more data
              }
              errorMessage.value = '';
            });


    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
  isLoading.value = false;
  isLoadingMore.value = false; // Reset loading state
  }
  }
}
