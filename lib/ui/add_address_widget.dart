import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../ui/color/appColor.dart';
import '../features/customers/customer_controller.dart';
import '../features/filters_dropdown/dropdown_controller.dart';
import 'Buttons/CustomButton.dart';

class AddAddressWidget extends StatefulWidget {
  final bool isShipping;
  const AddAddressWidget({Key? key, this.isShipping = false}) : super(key: key);

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  final CustomerController cc = Get.find<CustomerController>();
         DropdownController dc = Get.put(DropdownController());

  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gstController.text = widget.isShipping ? cc.gstNumber_shipping.value : cc.gstNumber_billing.value;
    _address1Controller.text = widget.isShipping ? cc.address_1_shipping.value : cc.address_1_billing.value;
    _countryController.text = widget.isShipping ? cc.country_shipping.value : cc.country_billing.value;
    _pincodeController.text = widget.isShipping ? cc.pincode_shipping.value : cc.pincode_billing.value;
    _cityController.text = widget.isShipping ? cc.city_shipping.value : cc.city_billing.value;
    _stateController.text = widget.isShipping ? cc.state_shipping.value : cc.state_billing.value;


  }
  void _updateFromGstData(Map<dynamic, dynamic> data) {
    final gstData = data['gstInData'];
    final postalData = data['postalData'];

    if (gstData == null || postalData == null) return;

    _gstController.text = gstData['Gstin'] ?? '';
    _address1Controller.text = "${gstData['AddrLoc'] ?? ''},${gstData['AddrSt'] ?? ''},${gstData['AddrBno'] ?? ''}";
    _pincodeController.text = gstData['AddrPncd']?.toString() ?? '';
    _cityController.text = postalData['district'] ?? '';
    _countryController.text = postalData['country'] ?? '';
    _stateController.text = postalData['state'] ?? '';

    // Set in GetX controller
    if (widget.isShipping) {
      cc.gstNumber_shipping.value = _gstController.text;
      cc.address_1_shipping.value =  _address1Controller.text;
      cc.pincode_shipping.value =  _pincodeController.text;
      cc.city_shipping.value = _cityController.text;
      cc.country_shipping.value = _countryController.text ;
      cc.state_shipping.value = _stateController.text;
    } else {
      cc.gstNumber_billing.value = _gstController.text;
      cc.address_1_billing.value =  _address1Controller.text;
      cc.pincode_billing.value =  _pincodeController.text;
      cc.city_billing.value = _cityController.text;
      cc.country_billing.value = _countryController.text ;
      cc.state_billing.value = _stateController.text;
    }

  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

          return Container(
            width: width,
            height: height * 0.52,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child:

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 3,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "GST Number",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 5, vertical: 3),
                    //   child: TextField(
                    //     controller: _address1Controller,
                    //
                    //     onChanged: (val) {
                    //       cc.gstNumber_billing.value = val;
                    //     },
                    //     decoration: InputDecoration(
                    //       contentPadding: const EdgeInsets.all(6),
                    //       hintText: "22AAAAA00000A1Z5",
                    //       alignLabelWithHint: true,
                    //       hintStyle: TextStyle(
                    //         color: Colors.grey.shade400,
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 14,
                    //       ),
                    //       //15
                    //       suffixIcon: GestureDetector(
                    //         onTap: () => dc.fetchsearchByGstin(context,cc.gstNumber_billing.value),
                    //         child: Container(
                    //           width: 100,
                    //           alignment: Alignment.center,
                    //           decoration: const BoxDecoration(
                    //             borderRadius: BorderRadius.only(
                    //               topRight: Radius.circular(5),
                    //               bottomRight: Radius.circular(5),
                    //             ),
                    //             color: AppColors.mainblue,
                    //           ),
                    //           child: const Text(
                    //             "Fetch Details",
                    //             style: TextStyle(
                    //               fontSize: 13,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       border: OutlineInputBorder(
                    //         borderSide:
                    //         BorderSide(color: Colors.grey.shade200),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    _buildTextField(
                      controller: _gstController,
                      label: '22AAAAA00000A1Z5',
                      suffixIcon: GestureDetector(
                        onTap: () async{
                          await dc.fetchsearchByGstin(
                              context, cc.gstNumber_billing.value);
                          final data = dc.searchByGstin;
                       if (data['gstInStatus'] == true) {
                          _updateFromGstData(data);
                         }
                        },
                        child: Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color: AppColors.mainblue,
                          ),
                          child: const Text(
                            "Fetch Details",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Enter Address',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _address1Controller,
                      label: 'Street Line Address',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _pincodeController,
                      label: 'Pincode',
                      suffixIcon: Container(
                        width: 100,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          color: AppColors.mainblue,
                        ),
                        child: const Text(
                          "Fetch Details",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const Text(
                      "omer PINCODE & click fetch to auto-fill country,state,city details",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _countryController,
                      label: 'Country',
                    ),

                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: _cityController,
                      label: 'City',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _stateController,
                      label: 'State *',
                    ),
                    Container(
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: CustomButton(
                            height: 53,
                            title: 'Save',
                            buttonText: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            backgroundColor: AppColors.mainblue,
                            borderRadius: 15,
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
          );



  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      child: TextField(
        controller: controller,
        onChanged: (val) {
          if (widget.isShipping) {
            if (controller == _address1Controller) {
              cc.address_1_shipping.value = val;
            } else if (controller == _countryController) {
              cc.country_shipping.value = val;
            } else if (controller == _pincodeController) {
              cc.pincode_shipping.value = val;
            } else if (controller == _cityController) {
              cc.city_shipping.value = val;
            } else if (controller == _stateController) {
              cc.state_shipping.value = val;
            } else if (controller == _gstController) {
              cc.gstNumber_shipping.value = val;
            }
          } else {
            if (controller == _address1Controller) {
              cc.address_1_billing.value = val;
            } else if (controller == _countryController) {
              cc.country_billing.value = val;
            } else if (controller == _pincodeController) {
              cc.pincode_billing.value = val;
            } else if (controller == _cityController) {
              cc.city_billing.value = val;
            } else if (controller == _stateController) {
              cc.state_billing.value = val;
            } else if (controller == _gstController) {
              cc.gstNumber_billing.value = val;
            }
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          label: Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}


class AddContactWidget extends StatefulWidget {
  const AddContactWidget({super.key});

  @override
  State<AddContactWidget> createState() => _AddContactWidgetState();
}

class _AddContactWidgetState extends State<AddContactWidget> {
  final CustomerController cc = Get.find<CustomerController>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _desigController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
               controller: _nameController,


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

              const Text(
                "Phone Number",
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
                  controller: _phone1Controller,
                  flagsButtonPadding: const EdgeInsets.all(8),
                  dropdownIconPosition: IconPosition.trailing,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    hintText: 'Enter Phone Number',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                ),
              ),
              const Text(
                "Alt Phone Number",
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
                  flagsButtonPadding: const EdgeInsets.all(8),
                  dropdownIconPosition: IconPosition.trailing,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    hintText: 'Enter Alt Phone Number',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  controller: _phone2Controller,

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
                  controller: _emailController,

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
                "Designation",
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
                  controller: _desigController,

                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Enter Designation",
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
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: CustomButton(
                      height: 53,
                      title: 'Save',
                      buttonText: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      backgroundColor: AppColors.mainblue,
                      borderRadius: 15,
                      onPressed: () async {
                        cc.addContact(_nameController.text, _desigController.text, _phone1Controller.text, _phone2Controller.text, _emailController.text);
                        Navigator.pop(context);

                      },
                    ),
                  ),
                ),
              ),
            ]
        ),

    );
  }
}
