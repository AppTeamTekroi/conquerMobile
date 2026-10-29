import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vconquer/features/products/Products.dart';
import 'package:vconquer/features/products/product_controller.dart';
import 'package:vconquer/features/userController.dart';

import '../ui/color/appColor.dart';
import 'HomeScreen/home_controller.dart';
import 'customers/customer_controller.dart';
import 'customers/customer_screen.dart';
import 'HomeScreen/homescreen.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late UserController uc;
  late HomescreenController hc;
  late ProductController productController;
  late CustomerController customerController;

  @override
  void initState() {
    super.initState();

    uc = Get.find<UserController>();
    hc = Get.find<HomescreenController>();
    productController = Get.find<ProductController>();
    customerController = Get.find<CustomerController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      hc.YtdDetails();
      productController.fetchproducts();
      customerController.fetchUser();
    });
  }

  int _selectedIndex = 0;

  List<Widget> pages = [
    HomeScreen(),
    Products(),
    CustomerScreen(fromQuotation: false,),
    // PartyScreen(),
    // MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      uc.pageNumber.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // height: MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (uc.pageNumber.value == 0) {
          return true;
        } else {
          uc.pageNumber.value = 0;
          // _selectedIndex = 0;
          _onItemTapped(0);
          uc.update();
          return false;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          // body: pages.elementAt(_selectedIndex),
          bottomNavigationBar: ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: AppColors.blues,
              unselectedItemColor: Colors.grey.shade800,
             // const Color.fromARGB(255, 225, 225, 225)
              selectedFontSize: 13,
              unselectedFontSize: 10,
              unselectedLabelStyle: TextStyle(
                fontFamily: "Poppins",
              ),
              selectedLabelStyle: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
              elevation: 0,
              backgroundColor: AppColors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel_outlined),
                  activeIcon: Icon(Icons.save_as),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel_outlined),
                  activeIcon: Icon(Icons.people),
                  label: 'Customers',
                ),
              ],
              currentIndex: _selectedIndex,
              // selectedItemColor: Colors.amber[800],
              onTap: (index) {
                //disabling Profile Page
                // if (index == 4) return;
                _onItemTapped(index);
              },
            ),
          ),
          body: GetBuilder<UserController>(builder: (controller) {
            return Builder(
              builder: (context) {
                switch (uc.pageNumber.value) {
                  case 0:
                    return  HomeScreen();
                  case 1:
                    return Products();
                  case 2:
                    return CustomerScreen(fromQuotation: false,);
                // case 3:
                //   return const PartyScreen();
                // case 4:
                //   return const MoreScreen();
                // case 5:
                //   return const InvoiceScreen();
                  default:
                    return const Center(child: Text("Work in Progress"));
                }
              },
            );
          })),
    );
  }
}
