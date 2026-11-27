import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vconquer/login/datasource/auth_service.dart';
import 'package:vconquer/login/presentation/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var lastError = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    loadLoginState();
  }

  Future<void> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('isLogin') ?? false;
    token = prefs.getString('token') ??
        prefs.getString('access_token') ??
        '';
    branch = prefs.getString('branch') ??
        prefs.getString('branch_name') ??
        '';

    print("token in pref $token");
  }

  /// Returns the success map on login, or `null` on failure.
  /// On failure, [lastError] contains the server/app message.
  Future<Map<String, dynamic>?> loginUser() async {
    final String userName = usernameController.text.trim();
    final String password = passwordController.text;

    try {
      isLoading.value = true;
      lastError.value = '';

      final response = await authService.login(userName, password);
      print(response);

      Map<String, dynamic>? result;
      response.fold(
        (failure) {
          print('Failure in login: ${failure.message}');
          lastError.value = failure.message;
          isLogin.value = false;
          result = null;
        },
        (res) {
          token = res['access_token']?.toString() ?? '';
          branch = res['branch_name']?.toString() ?? '';
          isLogin.value = token.isNotEmpty;
          result = res;
        },
      );
      await saveLoginState();
      return result;
    } catch (e) {
      print('Exception: $e');
      lastError.value = e.toString();
      isLogin.value = false;
      await saveLoginState();
      return null;
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
    await prefs.setBool('isLogin', isLogin.value);
    if (isLogin.value) {
      await prefs.setString('token', token);
      await prefs.setString('branch', branch);
    } else {
      await prefs.remove('token');
      await prefs.remove('branch');
    }
  }
}
