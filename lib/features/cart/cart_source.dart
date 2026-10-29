import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vconquer/core/API/URLConst.dart';
import 'dart:io';
import '../../../core/headerfiles.dart';
import '../../../core/error/failure.dart';
import '../../../core/error/unauth_dilogbox.dart';

abstract class CartRepository {
  ///quatation
  Future<Either<Failure, dynamic>> AddToCart(BuildContext context,String productId, int productQty, String customerId,String cardcode);
  Future<Either<Failure, dynamic>> fetchcartliost(BuildContext context,String customerId);
  Future<Either<Failure, dynamic>> UpdatetoCart (BuildContext context, Map<String, dynamic> body, String cartId);
///opportunity
  Future<Either<Failure, dynamic>> Opp_AddToCart(BuildContext context,String productId, int productQty, String customerId,String cardcode,String page);
  Future<Either<Failure, dynamic>> Opp_fetchcartliost(BuildContext context,String customerId);
  Future<Either<Failure, dynamic>> Opp_UpdatetoCart (BuildContext context, Map<String, dynamic> body, int cartId);
///order
  Future<Either<Failure, dynamic>> order_AddToCart(BuildContext context,String productId, int productQty, String customerId,String cardcode);
  Future<Either<Failure, dynamic>> order_fetchcartliost(BuildContext context,String customerId);
  Future<Either<Failure, dynamic>> order_UpdatetoCart (BuildContext context, Map<String, dynamic> body, int cartId);

  Future<Either<Failure, dynamic>> fetchConvertcart(BuildContext context,String customerId,String page);
  Future<Either<Failure, dynamic>> ConvertOQ_QO(BuildContext context,String oppId, String customerId,String page);

 // Future<Either<Failure, dynamic>> fetchConvertOrdercart(BuildContext context,String customerId);
 // Future<Either<Failure, dynamic>> ConvertQuta_To_Order(BuildContext context,String oppId, String customerId);

}

class CartDataSourceImpl implements CartRepository {

  @override
  Future<Either<Failure, dynamic>> AddToCart(BuildContext context, productId,
      productQty, customerId, cardcode) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse(URLConst.baseURL + URLConst.addTocart);
      print(url);
      final body = {
        'productId': "$productId",
        'customer_code': cardcode,
        'customerId': customerId,
        'quantities': productQty,
      };

      print("$body");
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      print(response.body);
      print("Item add to cart : ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox(); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Item added to cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to add item data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> fetchcartliost(BuildContext context,
      customerId) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL + URLConst.getuser_cart + customerId),
        headers: headers,
      );
      print("Cart fetched: ${response.body}");
      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
///api is same for add to cart and cart update
  @override
  Future<Either<Failure, dynamic>> UpdatetoCart(BuildContext context, body,page) async {
    try {
      print(body);
      final headers = await ApiHelper.getHeaders();
      // final url = Uri.parse('https://c360.zone/demo/shaurya_api/api/v1/cart-update/$cartId');
      var url;
      if(page == 'quotation')
       url = Uri.parse(URLConst.baseURL + URLConst.addTocart);
      if(page == 'opportunity')
        url = Uri.parse(URLConst.baseURL + URLConst.opportunity_addTocart);
      if(page == 'order')
        url = Uri.parse(URLConst.baseURL + URLConst.order_addTocart);
      if(page == 'co-quotation')
        url = Uri.parse(URLConst.baseURL + URLConst.getorderconvertaddTocart);
      if(page == 'co-opportunity')
        url = Uri.parse(URLConst.baseURL + URLConst.getconvertaddTocart);
print(url);
print(body);
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      print("Cart update fetched: ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 201) {
        print("Cart update: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to update Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }


  ///opportunity
  @override
  Future<Either<Failure, dynamic>> Opp_AddToCart(BuildContext context,
      productId, productQty, customerId, cardcode, page) async {
    try {
      final headers = await ApiHelper.getHeaders();
      // var url;
      // (page == "opportunity")
      //     ? url = Uri.parse(URLConst.baseURL + URLConst.opportunity_addTocart)
      //     : url =Uri.parse(URLConst.baseURL + URLConst.getconvertaddTocart);
      final url = Uri.parse(URLConst.baseURL + URLConst.opportunity_addTocart);
      print(url);
      final body = {
        'productId': productId,
        'customer_code': cardcode,
        'customerId': customerId,
        'quantities': productQty,
      };

      print("$body");
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      print(response.body);
      print("Item add to cart : ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox(); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Item added to cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to add item data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> Opp_fetchcartliost(BuildContext context,
      customerId) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL + URLConst.getopp_cart + customerId),
        headers: headers,
      );
      print(URLConst.baseURL + URLConst.getopp_cart + customerId);
      print("Cart fetched Opp cart: ${response.body}");
      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> Opp_UpdatetoCart(BuildContext context, body,
      cartId) async {
    try {
      print(body);
      final headers = await ApiHelper.getHeaders();
      //  final url = Uri.parse('https://c360.zone/demo/shaurya_api/api/v1/cart-update/$cartId');

      final url = Uri.parse(URLConst.baseURL + URLConst.opp_cartUpdate + "$cartId");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print("Cart update fetched: ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 200) {
        print("Cart update: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to update Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  ///order
  @override
  Future<Either<Failure, dynamic>> order_AddToCart(BuildContext context,
      productId, productQty, customerId, cardcode) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse(URLConst.baseURL + URLConst.order_addTocart);
      print(url);
      final body = {
        'productId': "$productId",
        'customer_code': cardcode,
        'customerId': customerId,
        'quantities': productQty,
      };

      print("$body");
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      print(response.body);
      print("Item add to cart : ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox(); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Item added to cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to add item data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> order_fetchcartliost(BuildContext context,
      customerId) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL + URLConst.getorder_cart + customerId),
        headers: headers,
      );
      print("Cart fetched: ${response.body}");
      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> order_UpdatetoCart(BuildContext context,
      body, cartId) async {
    try {
      print(body);
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse(
          'https://c360.zone/demo/shaurya_api/api/v1/cart-update/$cartId');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print("Cart update fetched: ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 200) {
        print("Cart update: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to update Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }


  ///convert opp to quat
  @override
  Future<Either<Failure, dynamic>> ConvertOQ_QO(BuildContext context, oppId,customerId,page) async {
    try {
      print(oppId);
      print(customerId);

      final headers = await ApiHelper.getHeaders();
      var url;
      if(page == 'coq')
        url = Uri.parse(URLConst.baseURL + URLConst.convertOpp_Quatation+oppId+"/"+customerId);
      if(page == 'cqo')
        url = Uri.parse(URLConst.baseURL + URLConst.convertQuatation_Order+oppId+"/"+customerId);

    final response = await http.get(
        url,
        headers: headers,
      );
     print(url);
      print("Cart fetched Opp to convert: ${response.body}");
      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> fetchConvertcart(BuildContext context,customerId,page) async {
    try {
      final headers = await ApiHelper.getHeaders();

      var url;
print(page);
      if(page == 'coq') {
        url =
            Uri.parse(URLConst.baseURL + URLConst.getconvertcart + customerId);
      }
      if(page == 'cqo') {
        url =
            Uri.parse(URLConst.baseURL + URLConst.getorderconvertcart + customerId);
      }
      final response = await http.get(
        url,
        headers: headers,
      );

      print(url);
      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Opp convert Cart fetched in source: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);

      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Cart data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> Con_AddToCart(BuildContext context,
      productId, productQty, customerId, cardcode, page) async {
    try {
      final headers = await ApiHelper.getHeaders();
      var url;
      (page == "coq")
          ? url = Uri.parse(URLConst.baseURL + URLConst.getconvertaddTocart):'';
        (page == "cqo")?
        url =Uri.parse(URLConst.baseURL + URLConst.getorderconvertaddTocart):'';
      print(url);
      final body = {
        'productId': "$productId",
        'customer_code': cardcode,
        'customerId': customerId,
        'quantities': productQty,
      };

      print("$body");
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      print(response.body);
      print("Item add to cart : ${response.body}");

      if (response.statusCode == 401) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unauthorized access'),
        //     duration: Duration(seconds: 3),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        // UnauthDilogbox(); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Item added to cart fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to add item data',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }











///copy quat to order

  // @override
  // Future<Either<Failure, dynamic>> ConvertQuta_To_Order(BuildContext context, oppId,customerId) async {
  //   try {
  //     print(oppId);
  //     print(customerId);
  //     final headers = await ApiHelper.getHeaders();
  //     final response = await http.get(
  //       Uri.parse(URLConst.baseURL + URLConst.convertOpp_Quatation+oppId+"/"+customerId),
  //       headers: headers,
  //     );
  //     //  print(URLConst.baseURL + URLConst.convertOpp_Quatation + customerId);
  //     print("Cart fetched Opp to convert: ${response.body}");
  //     if (response.statusCode == 401) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Unauthorized access'),
  //           duration: Duration(seconds: 3),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       UnauthDilogbox();
  //       return Left(Failure(
  //         statusCode: 401,
  //         message: 'Unauthorized access',
  //       ));
  //     }
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       print("Cart fetched: ${response.body}");
  //       final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       return Right(jsonResponse);
  //     } else {
  //       return Left(Failure(
  //         statusCode: response.statusCode,
  //         message: 'Failed to fetch Cart data',
  //       ));
  //     }
  //   } catch (e) {
  //     return Left(Failure(
  //       statusCode: 500,
  //       message: 'Error occurred: $e',
  //     ));
  //   }
  // }

  // @override
  // Future<Either<Failure, dynamic>> fetchConvertOrdercart(BuildContext context,customerId) async {
  //   try {
  //     final headers = await ApiHelper.getHeaders();
  //     final response = await http.get(
  //       Uri.parse(URLConst.baseURL+URLConst.getconvertcart+customerId),
  //       headers: headers,
  //     );
  //     print(URLConst.baseURL+URLConst.getconvertcart+customerId);
  //     print("Cart fetched convert Opp: ${response.body}");
  //     if (response.statusCode == 401) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Unauthorized access'),
  //           duration: Duration(seconds: 3),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       UnauthDilogbox();
  //       return Left(Failure(
  //         statusCode: 401,
  //         message: 'Unauthorized access',
  //       ));
  //     }
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       print("Opp convert Cart fetched in source: ${response.body}");
  //       final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       return Right(jsonResponse);
  //
  //     } else {
  //       return Left(Failure(
  //         statusCode: response.statusCode,
  //         message: 'Failed to fetch Cart data',
  //       ));
  //     }
  //   } catch (e) {
  //     return Left(Failure(
  //       statusCode: 500,
  //       message: 'Error occurred: $e',
  //     ));
  //   }
  // }


}