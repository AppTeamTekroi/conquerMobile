import 'package:vconquer/features/Opportunities/opportunity_controller.dart';
import 'package:vconquer/features/Quatation/quatation_controller.dart';
import 'package:vconquer/features/Reports/report_controller.dart';

import '../features/HomeScreen/home_controller.dart';
import '../features/cart/cart_controller.dart';
import '../features/customers/customer_controller.dart';
import '../features/filters_dropdown/dropdown_controller.dart';
import '../features/userController.dart';
import '../login/controller/login_controller.dart';
import '../features/orderlist/order_controller.dart';
import '../features/products/product_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {

    /// 🔐 Auth / User (keep permanent)
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<UserController>(() => UserController(), fenix: true);

    /// 🏠 Home
    Get.lazyPut<HomescreenController>(() => HomescreenController(), fenix: true);

    /// 👥 Customers
    Get.lazyPut<CustomerController>(() => CustomerController(), fenix: true);

    /// 📦 Products
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);

    /// 🛒 Cart
    Get.lazyPut<CartController>(() => CartController(), fenix: true);

    /// 📄 Quotation
    Get.lazyPut<QuatationController>(() => QuatationController(), fenix: true);

    /// 🧾 Orders
    Get.lazyPut<OrderController>(() => OrderController(), fenix: true);

    /// 🎯 Opportunities
    Get.lazyPut<OpportunityController>(() => OpportunityController(), fenix: true);

    /// 🔽 Dropdown
    Get.lazyPut<DropdownController>(() => DropdownController(), fenix: true);

    /// 📊 Reports
    Get.lazyPut<ReportController>(() => ReportController(), fenix: true);
  }
}