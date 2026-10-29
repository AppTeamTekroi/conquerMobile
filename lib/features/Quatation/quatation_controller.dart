import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vconquer/features/Quatation/quatation_source.dart';
class QuatationController extends GetxController {
  final QuatationImpl qc = QuatationImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;
  var quatationlist = {}.obs;
  var quatationdetails = {}.obs;
  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;

  var currentPage = 1.obs;
  var isLastPage = false.obs; // Track if it's the last page
  var isLoadingMore = false.obs; // Track pagination loading state
  var searchQuery = ''.obs;
  var filteredcust = [].obs;


  @override
  Future<void> Quatationlist({bool isPagination = false}) async {
    print('fetching 1 api');
    try {

      if (!isPagination) {
        isLoading.value = true;
        quatationlist.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await qc.Quatationlist(currentPage.value,searchQuery.value);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },

                (responseData) {
          if (responseData.isNotEmpty) {
          quatationlist.addAll(responseData);
          filteredcust.addAll(responseData['data']);
          isLoading.value = false;
          // Append new data
          currentPage.value++; // Increment page number
          } else {
          isLastPage.value = true; // No more data
          isLoading.value = false;
          }
          print('***********Quatation data successfully fetched in controller');
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
  Future<void> Quatationdetails(BuildContext context, String qd_id,String page) async {
    print('fetching qd_id api');
    try {
      isLoading2.value = true;
      final result = await qc.Quatationdetails(context,qd_id,page);
      result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
      },
              (responseData) {
                quatationdetails.value = responseData;
            // print(
            //     '***********Quatation data successfully fetched in controller');
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
  Future<Map<String, dynamic>> PostQuatation(
      Map<String, dynamic> body,String page,File file) async {
    try {
      isLoading3.value = true;
      final result =
      await qc.QuatationStore( body,page,file);
      return result.fold((failure) {
        isLoading3.value = false;
        errorMessage3.value = 'Error: ${failure.message}';
        return {
          'success': false,
          'message': failure.message
        }; // Return a failure response
      }, (responseData) {
        errorMessage3.value = '';
        isLoading3.value = false;
       // postorder.value = responseData;

        if(responseData['success'] == true) {
          return {'success': true, 'data': responseData};
        }else{
          return {'success': false, 'data': responseData};
        }
      });
    } catch (e) {
      isLoading3.value = false;
      errorMessage2.value = 'An error occurred: ${e.toString()}';
      return {
        'success': false,
        'message': e.toString()
      }; // Return an error response
    }
  }

}