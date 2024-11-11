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


  @override
  Future<void> Quatationlist(BuildContext context) async {
    print('fetching 1 api');
    try {
      isLoading.value = true;
      final result = await qc.Quatationlist(context);
      result.fold((failure) {
        isLoading.value = false;
        errorMessage.value = 'Error: ${failure.message}';
      },
              (responseData) {
                quatationlist.value = responseData;
            print(
                '***********Quatation data successfully fetched in controller');
            errorMessage.value = '';
            isLoading.value = false;
          }
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'An error occurred: ${e.toString()};';
    }
  }
  Future<void> Quatationdetails(BuildContext context, String qd_id) async {
    print('fetching qd_id api');
    try {
      isLoading2.value = true;
      final result = await qc.Quatationdetails(context,qd_id);
      result.fold((failure) {
        isLoading2.value = false;
        errorMessage2.value = 'Error: ${failure.message}';
      },
              (responseData) {
                quatationdetails.value = responseData;
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