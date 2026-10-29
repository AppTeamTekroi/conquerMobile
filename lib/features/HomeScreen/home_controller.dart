import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../core/error/unauth_dilogbox.dart';
import 'home_source.dart';



class HomescreenController extends GetxController {

  final YtdImpl qc = YtdImpl();
  var isLoading2 = false.obs;
  var errorMessage2 = ''.obs;
  var ytdDetails = {}.obs;

  @override
  Future<void> YtdDetails() async {
    print('fetching qd_id api');
    try {
      isLoading2.value = true;
      final result = await qc.Ytd();
      result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
        if (failure.statusCode == 401) {
          UnauthDilogbox();
        }
      },
              (responseData) {
            ytdDetails.value = responseData;
            print(
                '***********Quatation data successfully fetched in controller');
            errorMessage2.value = '';
            isLoading2.value = false;
          }
      );
    } catch (e) {
      isLoading2.value = false;
      errorMessage2.value = 'An error occurred: ${e.toString()};';
    }
  }

}