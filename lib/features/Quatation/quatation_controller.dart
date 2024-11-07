import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vconquer/features/Quatation/quatation_source.dart';
class QuatationController extends GetxController {
  final QuatationImpl qc = QuatationImpl();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var quatationlist = {}.obs;


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
}