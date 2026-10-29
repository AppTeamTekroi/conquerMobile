import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'opportunity_source.dart';

class OpportunityController extends GetxController {
  final OpportunityImpl qc = OpportunityImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;
  var opplist = {}.obs;
  var oppdetails = {}.obs;

  var postorder = {}.obs;
  var errorMessage3 = ''.obs;
  var isLoading3 = false.obs;


  var currentPage = 1.obs;
  var isLastPage = false.obs; // Track if it's the last page
  var isLoadingMore = false.obs; // Track pagination loading state
  var searchQuery = ''.obs;
  var filteredcust = [].obs;


  @override
  Future<void> Opportunitylist(BuildContext context,{bool isPagination = false}) async {
    print('fetching 1 api');
    try {
      if (!isPagination) {
        isLoading.value = true;
        opplist.clear(); // Clear old data when fetching new list
        currentPage.value = 1; // Reset page on new fetch
        isLastPage.value = false; // Reset last page status
      } else {
        isLoadingMore.value = true;
      }

      final result = await qc.Opportunitylist(context,currentPage.value,searchQuery.value);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },
              (responseData) {
            if (responseData.isNotEmpty) {
              opplist.addAll(responseData);
              filteredcust.addAll(responseData['data']);
              isLoading.value = false;
              // Append new data
              currentPage.value++;
            } else {

              isLastPage.value = true;
              isLoading.value = false;
            }
            print('***********Opportunity data successfully fetched in controller');
            errorMessage.value = '';
            isLoading.value = false;
          });



      //
      // (responseData) {
      //
      //           opplist.value = responseData;
      //       print(
      //           '***********Opportunity data successfully fetched in controller');
      //       errorMessage.value = '';
      //       isLoading.value = false;
      //     }
      // );
      //
      //


    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
    }
  }
  Future<void> Opportunitydetails(BuildContext context, String qd_id) async {
    print('fetching qd_id api');
    try {
      isLoading2.value = true;
      final result = await qc.Opportunitydetails(context,qd_id);
      result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
      },
              (responseData) {
                oppdetails.value = responseData;
            print(
                '***********Opportunity data successfully fetched in controller');
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
  Future<dynamic> PostOpportunity(BuildContext context,
      Map<String, dynamic> body, String customerId, File file) async {
    try {
      isLoading3.value = true;
      final result = await qc.OpportunityStore(context, body, customerId,file);
      var responseData;

       result.fold((failure) {
        isLoading3.value = false;
        errorMessage3.value = 'Error: ${failure.message}';
        responseData.clear();
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

