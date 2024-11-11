import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vconquer/login/datasource/auth_service.dart';
import 'package:vconquer/login/presentation/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vconquer/features/homescreen.dart';


class LoginController extends GetxController {
  final AuthService authService = AuthService();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  var otpVisibility = false.obs;
  var isPasswordVisible = true.obs;
  var Password = "".obs;
  var isLoading = false.obs;
  var isLogin = false.obs;
  var UserName = "".obs;
  var token = '';
  var branch = '';
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    loadLoginState();
  }

  Future<dynamic> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('isLogin') ?? false;
    token = prefs.getString("access_token") ?? '';
    branch = prefs.getString("branch_name") ?? '';

    print("token in pref $token");

  }

  Future<dynamic> loginUser() async {
    final String UserName = usernameController.text;
    final String Password = passwordController.text;
    try {
      isLoading.value = true;
      var response = await authService.login(
        UserName,
        Password,

      );
      var responseData;
      print(response);
      response.fold(
            (failure) {
          responseData .clear();
          print('Failure in login  : ${failure.message}');
          responseData = 'Failure in login: ${failure.message}';
        },
            (res) => responseData = res,
      );

      if (responseData != null ) {
        isLogin.value = true;
        saveLoginState();
      } else {
        isLogin.value = false;
        saveLoginState();
      }

      return responseData;
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to login: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> logOutUser() async {
    isLogin.value = false;
    token = '';
    branch = '';
    await saveLoginState();
    Get.off(() => const LoginScreen());
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', isLogin.value);
    if (isLogin.value) {
      prefs.setString('token', token);
      prefs.setString('branch', branch);

    } else {
      prefs.remove('token');
      prefs.remove('branch');

    }
  }

}