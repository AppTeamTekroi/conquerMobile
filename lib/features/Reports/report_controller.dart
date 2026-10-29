import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vconquer/features/Reports/report_source.dart';
class ReportController extends GetxController {
  final ReportImpl qc = ReportImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;
  var reportlist = {}.obs;
  var quatationdetails = {}.obs;
  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;

  var currentPage = 1.obs;
  var isLastPage = false.obs; // Track if it's the last page
  var isLoadingMore = false.obs; // Track pagination loading state
  var searchQuery = ''.obs;
  var filteredcust = [].obs;


  @override
  Future<void> Reportlist(BuildContext context,String report,
      {bool isPagination = false}) async {
    print('fetching 1 api');
    try {
      if (!isPagination) {
        isLoading.value = true;
        reportlist.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await qc.Reportlist(
          context, currentPage.value, searchQuery.value,report);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },

              (responseData) {
            if (responseData.isNotEmpty) {
              reportlist.value = (responseData);
              filteredcust.value = (responseData['data']);
              filteredcust.refresh();
              isLoading.value = false;
              // Append new data
              currentPage.value++; // Increment page number
            } else {
              isLastPage.value = true; // No more data
              isLoading.value = false;
            }
            print(
                '***********reportlist data successfully fetched in controller');
            errorMessage.value = '';
          });


      //     (responseData) {
      //   quatationlist.value = responseData;
      //   print(
      //       '***********Quatation data successfully fetched in controller');
      //   errorMessage.value = '';
      //   isLoading.value = false;
      // }


    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
    }
  }
}