
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoadingOverlay {
  static void show(String text) {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('lib/ui/assets/client.png',
                      height: 90,
                      width: 70,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }


  static void hide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
