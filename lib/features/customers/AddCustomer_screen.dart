import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:vconquer/core/enum/post_enum_response.dart';
import 'package:vconquer/features/filters_dropdown/dropdown_controller.dart';
import 'package:vconquer/ui/Buttons/CustomButton.dart';

import '../../../../ui/color/appColor.dart';
import '../../ui/CommonWidget.dart';
import '../../ui/add_address_widget.dart';
import '../../ui/loading.dart';
import '../../ui/richtext.dart';
import 'customer_controller.dart';

class AddCustomers extends StatefulWidget {
  VoidCallback onUpdate;
  AddCustomers({super.key, required this.onUpdate});

  @override
  State<AddCustomers> createState() => _AddCustomersState();
}

class _AddCustomersState extends State<AddCustomers> {
  CustomerController cc = Get.find();
  DropdownController dc = Get.find();
  var filled = false.obs;
  @override
  void initState() {
    super.initState();
    dc.fetchsalesEmpName(context);
    dc.fetchcategories(context);
    dc.fetchsubCategories(context);
    dc.fetchSolutionArchitect(context);
    lead.first;
  }

  // void dispose() {
  //   // ignore: avoid_print
  //   print('Dispose used');
  //   // cc.initializeVariables(billing: true, shipping: true);
  //   super.dispose();
  // }

  List<String> lead = <String>['Lead', 'Customer'];
  String dropdownValuel = 'Lead';
  // String dropdownValueT = 'Lead Type';
  // String dropdownValueS = 'Lead Source';
  List<String> lead_type = <String>['Warm', 'Cold', 'Hot'];
  List<String> lead_source = <String>[
    'Face Book',
    'WhatsUp',
    'Twitter',
    'Events',
    'Other Events'
  ];
  List<String> oem = <String>[
    'Palo Alto',
    'JAMF',
    'Hexnode',
    'Cisco',
    'Eventus',
    'Microsoft',
    'Veeam',
    'Omnissa',
    'Fortinet',
    'Security',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Customer",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Basic Details ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0),
                        child: Container(
                          height: height * 0.03,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                            ), // Border color and width
                            borderRadius:
                                BorderRadius.circular(5), // Rounded border
                          ),
                          child: DropdownButton<String>(
                            value: dropdownValuel,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 18,
                            ),
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              color: Colors.red,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                if (value != null) {
                                  dropdownValuel = value;
                                  cc.lead.value = value;
                                }
                              });
                            },
                            items: lead
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 13),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: "Name",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: TextField(
                            onChanged: (val) {
                          //    cc.searchProductByName(val);
                              filled.value = val.isNotEmpty;
                              cc.cust_name.value = val;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              hintText: "Customer's Name",
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => (filled.value && cc.filteredcust.isNotEmpty)
                              ? Container(
                                  height: height * 0.05,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: cc.filteredcust.length,
                                      itemBuilder: (context, index) {
                                        final item = cc.filteredcust[index];
                                        final int itemId = item['id'];
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonRichText(
                                                label: '',
                                                value: item["card_name"] ?? '',
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : SizedBox.shrink(),
                        ),
                        const Text(
                          "Mobile Number",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: IntlPhoneField(
                            onCountryChanged: (val) {
                               // cc.dial_code.value = val.dialCode;
                            },
                            flagsButtonPadding: const EdgeInsets.all(8),
                            dropdownIconPosition: IconPosition.trailing,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              hintText: 'Enter Mobile Number',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'IN',
                             keyboardType: TextInputType.phone,
                            onChanged: (phone) {
                              cc.mobileNumber1.value = phone.number;
                            },
                          ),
                        ),
                        const Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                cc.email.value = val;
                              });

                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              hintText: "Enter Customer's Email",
                              // errorText: 'Enter Valid Email',
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: TextField(
                            onChanged: (val) {
                              cc.notes.value = val;
                              },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              hintText: "Notes",
                              // errorText: 'Enter Valid Email',
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Customer Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sales Employee",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            child: Container(
                              height: height * 0.05,
                              child: Obx(() {
                                if (dc.isLoading3.value) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (dc.errorMessage3.value.isNotEmpty) {
                                  return Center(
                                      child: Text(dc.errorMessage3.value));
                                } else {

                                  final contactlist = dc.salesEmpName.value;
                                  final dropdownItems = contactlist.entries
                                      .map((e) => {'id': e.key, 'name': e.value})
                                      .toList();

                                  return DropdownSearch<dynamic>(
                                    items: dropdownItems,
                                    itemAsString: (item) => item['name'] ?? '',

                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          CommonWidget.dropdecoration(
                                        'Select Sales Employee',
                                        EdgeInsets.only(top: 13, left: 8),
                                      ),
                                    ),
                                    onChanged: (dynamic? conText) async {
                                      if (conText != null) {

                                        cc.salesEmp.value = conText['id'];



                                      }
                                    },
                                    dropdownBuilder: (context, selectedItem) {
                                      return Text(
                                        selectedItem?['name']  ?? 'Select Sales Employee',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: selectedItem != null
                                                ? FontWeight.w400
                                                : FontWeight.normal,
                                            color: Colors.grey.shade400),
                                      );
                                    },
                                  );
                                }
                              }),
                            ),
                          ),
                          const Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            child: Obx(() {
                              if (dc.isLoading3.value) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (dc.errorMessage3.value.isNotEmpty) {
                                return Center(
                                    child: Text(dc.errorMessage3.value));
                              } else {
                                final contactlist = dc.categories.value;

                                final dropdownItems = contactlist.entries
                                    .map((e) => {'id': e.key, 'name': e.value})
                                    .toList();
                                //
                                // final Map<String, String> dropdownMap =
                                // {
                                //   for (var item in contactdata)
                                //     '${item["name"]}-${item["cellolar"]}':
                                //     (item["id"]).toString()
                                // };


                                return Container(
                                  width: width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9)),
                                  child: DropdownSearch<dynamic>(
                                    items: dropdownItems,
                                    itemAsString: (item) => item['name'] ?? '',

                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          CommonWidget.dropdecoration(
                                        'Select Category ',
                                        EdgeInsets.only(top: 13, left: 8),
                                      ),
                                    ),
                                    onChanged: (dynamic? conText) async {
                                      if (conText != null) {


                                            cc.category.value = conText['id'];

                                      }
                                    },
                                    dropdownBuilder: (context, selectedItem) {
                                      return Text(
                                        selectedItem?['name']  ?? 'Select Category ',
                                        style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 16,
                                            fontWeight: selectedItem != null
                                                ? FontWeight.w600
                                                : FontWeight.normal),
                                      );
                                    },
                                  ),
                                );
                              }
                            }),
                          ),
                          const Text(
                            "Sub Category",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            child: Obx(() {
                              if (dc.isLoading3.value) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (dc.errorMessage3.value.isNotEmpty) {
                                return Center(
                                    child: Text(dc.errorMessage3.value));
                              } else {
                                final contactlist = dc.subCategories.value;
                                final dropdownItems = contactlist.entries
                                    .map((e) => {'id': e.key, 'name': e.value})
                                    .toList();

                                // final Map<String, String> dropdownMap =
                                // {
                                //   for (var item in contactdata)
                                //     '${item["name"]}-${item["cellolar"]}':
                                //     (item["id"]).toString()
                                // };


                                return Container(
                                  width: width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9)),
                                  child: DropdownSearch<dynamic>(
                                    items: dropdownItems,
                                    itemAsString: (item) => item['name'] ?? '',

                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                          CommonWidget.dropdecoration(
                                        'Select Sub Category',
                                        EdgeInsets.only(top: 13, left: 8),
                                      ),
                                    ),
                                    onChanged: (dynamic? conText) async {
                                      if (conText != null) {

                                            cc.Subcategory.value = conText['id'];

                                      }
                                    },
                                    dropdownBuilder: (context, selectedItem) {
                                      return Text(
                                        selectedItem?['name']  ?? 'Select Sub Category',
                                        style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 16,
                                            fontWeight: selectedItem != null
                                                ? FontWeight.w600
                                                : FontWeight.normal),
                                      );
                                    },
                                  ),
                                );
                              }
                            }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lead Type",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 4),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ), // Border color and width
                                        borderRadius: BorderRadius.circular(
                                            5), // Rounded border
                                      ),
                                      child: Obx(() => DropdownButton<String>(
                                            value: lead_type.contains(cc.leadtype.value)
                                                ? cc.leadtype.value
                                                : null,
                                            hint: Text('Select Lead Type'),
                                            icon: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              size: 18,
                                            ),
                                            onChanged: (String? value) {
                                              if (value != null) {
                                                cc.leadtype.value =
                                                    value; // Directly update using GetX
                                              }
                                            },
                                            items: lead_type
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              );
                                            }).toList(),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lead Source",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 4),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ), // Border color and width
                                        borderRadius: BorderRadius.circular(
                                            5), // Rounded border
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        // Hides default underline
                                        child: DropdownButton<String>(
                                          value: lead_source
                                                  .contains(cc.leadsource.value)
                                              ? cc.leadsource.value
                                              : null,
                                          hint: Text('Select Lead Source'),
                                          icon: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              size: 18),
                                          // borderRadius: BorderRadius.circular(16),
                                          style: const TextStyle(
                                              color: Colors.black),
                                          onChanged: (String? value) {
                                            setState(() {
                                              cc.leadsource.value = value!;
                                            });
                                          },
                                          items: lead_source
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Text(
                            "Expected Conversation Date",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: TextField(
                              controller: TextEditingController(
                                  text: cc.expectedDate.value),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade200),
                                ),
                                hintText: 'YYYY-MM-DD',
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.8),
                                  fontSize: Get.height * 0.018,
                                  fontWeight: FontWeight.w500,
                                ),
                                //  padding: EdgeInsets.all(12),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.now(), // Default 8 days forward
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  setState(() {
                                    cc.expectedDate.value = formattedDate;
                                  });
                                }
                              },
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    "OEM",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 4),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ), // Border color and width
                                        borderRadius: BorderRadius.circular(
                                            5), // Rounded border
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        // Hides default underline
                                        child: DropdownButton<String>(
                                          value: oem
                                              .contains(cc.oem.value)
                                              ? cc.oem.value
                                              : null,
                                          hint: Text('Select Lead Source'),
                                          icon: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              size: 18),
                                          // borderRadius: BorderRadius.circular(16),
                                          style: const TextStyle(
                                              color: Colors.black),
                                          onChanged: (String? value) {
                                            setState(() {
                                              cc.oem.value = value!;
                                            });
                                          },
                                          items: oem
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value,
                                                      style:
                                                      TextStyle(fontSize: 16)),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),


                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Opportunity Size",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  child: TextField(
                                    onChanged: (val) {
                                      cc.size.value = val;
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(6),
                                      hintText: "opportunity size",
                                      // errorText: 'Enter Valid Email',
                                      alignLabelWithHint: true,
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 16,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                            ],
                          ),
                          const Text(
                            "Solution Architect Name",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 4),
                            child: Container(
                              height: height * 0.05,
                              child: Obx(() {
                                if (dc.isLoading3.value) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (dc.errorMessage3.value.isNotEmpty) {
                                  return Center(
                                      child: Text(dc.errorMessage3.value));
                                } else {
                                  final contactlist = dc.architech.value;
                                  final dropdownItems = contactlist.entries
                                      .map((e) => {'id': e.key, 'name': e.value})
                                      .toList();
                                  // final Map<String, String> dropdownMap =
                                  // {
                                  //   for (var item in contactdata)
                                  //     '${item["name"]}-${item["cellolar"]}':
                                  //     (item["id"]).toString()
                                  // };


                                  return DropdownSearch<dynamic>(
                                    items: dropdownItems,
                                    itemAsString: (item) => item['name'] ?? '',

                                    dropdownDecoratorProps:
                                    DropDownDecoratorProps(
                                      dropdownSearchDecoration:
                                      CommonWidget.dropdecoration(
                                        'Select Solution Architect',
                                        EdgeInsets.only(top: 13, left: 8),
                                      ),
                                    ),
                                    onChanged: (dynamic? conText) async {
                                      if (conText != null) {

                                            cc.solutionarchitech.value = conText['id'];

                                      }
                                    },
                                    dropdownBuilder: (context, selectedItem) {
                                      return Text(
                                        selectedItem?['name'] ?? 'Select Solution Architect',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: selectedItem != null
                                                ? FontWeight.w400
                                                : FontWeight.normal,
                                            color: Colors.grey.shade400),
                                      );
                                    },
                                  );
                                }
                              }),
                            ),
                          ),
                        ]),
                  ),
                  // const Text(
                  //   "Company Details (Optional)",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.all(6),
                  //   padding: const EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text(
                  //         "GST Number",
                  //         style: TextStyle(
                  //           fontSize: 13,
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 5, vertical: 3),
                  //         child: TextField(
                  //           onChanged: (val) {},
                  //           decoration: InputDecoration(
                  //             contentPadding: const EdgeInsets.all(6),
                  //             hintText: "22AAAAA00000A1Z5",
                  //             alignLabelWithHint: true,
                  //             hintStyle: TextStyle(
                  //               color: Colors.grey.shade400,
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 14,
                  //             ),
                  //             //15
                  //             suffixIcon: GestureDetector(
                  //               onTap: () => dc.fetchsearchByGstin(context),
                  //               child: Container(
                  //                 width: 100,
                  //                 alignment: Alignment.center,
                  //                 decoration: const BoxDecoration(
                  //                   borderRadius: BorderRadius.only(
                  //                     topRight: Radius.circular(5),
                  //                     bottomRight: Radius.circular(5),
                  //                   ),
                  //                   color: AppColors.mainblue,
                  //                 ),
                  //                 child: const Text(
                  //                   "Fetch Details",
                  //                   style: TextStyle(
                  //                     fontSize: 13,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             border: OutlineInputBorder(
                  //               borderSide:
                  //                   BorderSide(color: Colors.grey.shade200),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       const Text(
                  //         "omer GSTIN & click fetch to auto-fill company details",
                  //         style: TextStyle(
                  //           fontSize: 11,
                  //           color: Colors.grey,
                  //         ),
                  //       ),
                  //       const Text(
                  //         "Company Name",
                  //         style: TextStyle(
                  //           fontSize: 13,
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 5, vertical: 3),
                  //         child: TextField(
                  //           onChanged: (val) {},
                  //           decoration: InputDecoration(
                  //             contentPadding: const EdgeInsets.all(10),
                  //             hintText: "eg. Tata Motors Private Limited",
                  //             alignLabelWithHint: true,
                  //             hintStyle: TextStyle(
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.grey.shade400,
                  //               fontSize: 15,
                  //             ),
                  //             border: OutlineInputBorder(
                  //               borderSide:
                  //                   BorderSide(color: Colors.grey.shade200),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),


                  const Text(
                    "Address (Optional)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => cc.address_1_billing.value != '' ||
                                  cc.country_billing.value != '' ||
                                  cc.pincode_billing.value != '' ||
                                  cc.city_billing.value != '' ||
                                  cc.state_billing.value != ''
                              ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Billing Address",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        cc.address_1_billing.value != ''
                                            ? Text(
                                                cc.address_1_billing.value,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : SizedBox(),
                                        cc.country_billing.value != ''
                                            ? Text(
                                                cc.country_billing.value,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : SizedBox(),
                                        Row(
                                          children: [
                                            cc.city_billing.value != ''
                                                ? Text(
                                                    '${cc.city_billing.value} ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            cc.state_billing.value != ''
                                                ? Text(
                                                    '${cc.state_billing.value} ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            cc.pincode_billing.value != ''
                                                ? Text(
                                                    '${cc.pincode_billing.value} ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  // constraints:
                                                  //     BoxConstraints.loose(Size(width, height * 0.75)),
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      SingleChildScrollView(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom,
                                                      ),
                                                      child: AddAddressWidget(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 6, 138, 246),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                 cc.initializeVariables(billing: true);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 239, 29, 14),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      // constraints:
                                      //     BoxConstraints.loose(Size(width, height * 0.75)),
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: AddAddressWidget(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.grey.shade600,
                                          size: 17,
                                        ),
                                        Text(
                                          " Billing Address",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                        ),
                        Obx(() => cc.address_1_shipping.value != '' ||
                                  cc.country_shipping.value != '' ||
                                  cc.pincode_shipping.value != '' ||
                                  cc.city_shipping.value != '' ||
                                  cc.state_shipping.value != ''
                              ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Shipping Address",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        cc.address_1_shipping.value != ''
                                            ? Text(
                                                cc.address_1_shipping.value,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : SizedBox(),
                                        cc.country_shipping.value != ''
                                            ? Text(
                                                cc.country_shipping.value,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            : SizedBox(),
                                        Row(
                                          children: [
                                            cc.city_shipping.value != ''
                                                ? Text(
                                                    '${cc.city_shipping.value} ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            cc.state_shipping.value != ''
                                                ? Text(
                                                    '${cc.state_shipping.value} ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            cc.pincode_shipping.value != ''
                                                ? Text(
                                                    '${cc.pincode_shipping.value} ',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  // constraints:
                                                  //     BoxConstraints.loose(Size(width, height * 0.75)),
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      SingleChildScrollView(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom,
                                                      ),
                                                      child: AddAddressWidget(
                                                        isShipping: true,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 6, 138, 246),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                cc.initializeVariables(
                                                    shipping: true);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 239, 29, 14),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      // constraints:
                                      //     BoxConstraints.loose(Size(width, height * 0.75)),
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: AddAddressWidget(
                                            isShipping: true,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.grey.shade600,
                                          size: 17,
                                        ),
                                        Text(
                                          "Shipping Address",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .lightBlueAccent.shade100
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  cc.address_1_shipping.value =
                                                      cc.address_1_billing
                                                          .value;
                                                  cc.country_shipping.value =
                                                      cc.country_billing.value;
                                                  cc.city_shipping.value =
                                                      cc.city_billing.value;
                                                  cc.state_shipping.value =
                                                      cc.state_billing.value;
                                                  cc.pincode_shipping.value =
                                                      cc.pincode_billing.value;
                                                },
                                                child: Text(
                                                  "Same as Billing? ",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.copy,
                                                size: 13,
                                                color: Colors.grey.shade600,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  const Text(
                    "Add Contact",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Obx(() {
                    if (cc.contact_name.isNotEmpty) {
                      return Column(
                        children: [
                          Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cc.contact_name
                                  .length, // ✅ No need for `.value`
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: ${cc.contact_name[index]}",
                                          // ✅ Access index directly
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Designation: ${cc
                                              .contact_desig[index]}",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Text(
                                          "Email: ${cc.contact_email[index]}",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Text(
                                          "Phone: ${cc.phoneNumber[index]}",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Text(
                                          "Alt Phone: ${cc
                                              .altPhoneNumber[index]}",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Implement edit functionality
                                              },
                                              child: Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                cc.removeContact(index);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) =>
                                    SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery
                                              .of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: AddContactWidget(),
                                      ),
                                    ),
                              );
                            },
                            child: SizedBox(
                              width: width * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.black,
                                          size: 12,
                                        ),
                                        Text(
                                          'Add More Contacts',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) =>
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery
                                          .of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: AddContactWidget(),
                                  ),
                                ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child:


                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade600,
                                  size: 17,
                                ),
                                Text(
                                  " Add Contact",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                 ),










                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Other Details (Optional)",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     CircleAvatar(
                  //       radius: 12,
                  //       backgroundColor: AppColors.mainblue,
                  //       child: Icon(
                  //         Icons.expand_more,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 6.0),
                  //   child: Text(
                  //     "Add Opening balance, Notes, CC Emails, Tags",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 10,
                  //       color: Colors.grey.shade700,
                  //     ),
                  //   ),
                  // ),
                  // Row(
                  //   children: [
                  //     const Text(
                  //       "TDS applicable? ",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     Obx(
                  //           () => FlutterSwitch(
                  //         showOnOff: true,
                  //         value: cc.tds_aplicable.value,
                  //         activeText: "Yes",
                  //         height: 22,
                  //         width: 50,
                  //         toggleSize: 18,
                  //         padding: 1,
                  //         inactiveText: "No",
                  //         valueFontSize: 13,
                  //         activeTextColor: Colors.white,
                  //         inactiveTextColor: AppColors.mainblue,
                  //         activeColor: AppColors.mainblue,
                  //         inactiveColor: Colors.white,
                  //         inactiveToggleColor: AppColors.mainblue,
                  //         switchBorder:
                  //         Border.all(color: AppColors.mainblue),
                  //         activeTextFontWeight: FontWeight.normal,
                  //         inactiveTextFontWeight: FontWeight.normal,
                  //         onToggle: (val) {
                  //           cc.tds_aplicable.value =
                  //           !cc.tds_aplicable.value;
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          Obx(
            () => Container(
              height: 90,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomButton(
                    height: 53,
                    title: 'Add Customer',
                    buttonText: cc.postData.value == true
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.grey,
                          )
                        : const Text(
                            'Add Customer',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                    backgroundColor: AppColors.blues,
                    borderRadius: 15,
                    onPressed: () async {
                      // LoadingOverlay.show("Please wait while posting");
                      var response =  await cc.postCustomerData(context);
                      var decodedValue = response;
                      print(decodedValue);
                      if (decodedValue['success'] == true) {
                        // LoadingOverlay.hide();
                        // Get.back();
                        CommonWidget.showSnackbar(status: true, message: "Your Customer was Stored successfully");
                        // await op.Opportunitylist(context, isPagination: false);

                      } else {
                        // LoadingOverlay.hide();

                        CommonWidget.showSnackbar(status:false,message: response['message'] ??
                            "Something went wrong. Please try again.");


                      }



                      // if (res.postResponseEnum == PostResponseEnum.success) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Data posted successfully')));
                      //   Navigator.of(context)..pop();
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('An error has occurred')));
                      // }
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
