import 'package:vconquer/features/navBar.dart';
import 'package:vconquer/login/presentation/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vconquer/login/controller/login_controller.dart';
import 'package:vconquer/features/HomeScreen/homescreen.dart';
import 'package:vconquer/ui/app_binding.dart';

import 'login/controller/login_controller.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final LoginController loginController = Get.put(LoginController());
    await loginController.loadLoginState();
    return loginController.isLogin.value;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      title: 'vconquer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              return  BottomNav();
            } else {
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }
}
