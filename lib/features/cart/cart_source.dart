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
  Future<Either<Failure, dynamic>> AddToCart(BuildContext context,String productId, int productQty, String customerId,String cardcode);
  Future<Either<Failure, dynamic>> fetchcartliost(BuildContext context,String customerId);
  Future<Either<Failure, dynamic>> UpdatetoCart (BuildContext context, Map<String, dynamic> body, int cartId);
  Future<Either<Failure, dynamic>> OrderStore (BuildContext context, Map<String, dynamic> body, String customerId);

}

class CartDataSourceImpl implements CartRepository {

  @override
  Future<Either<Failure, dynamic>> AddToCart(BuildContext context, productId,  productQty,  customerId,cardcode) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse(URLConst.baseURL+URLConst.addTocart);
      print(url);
      final body = {
        'productId': "$productId",
        'cardCode': cardcode,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized access'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        UnauthDilogbox(); // Call your custom dialog here if needed.
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
  Future<Either<Failure, dynamic>> fetchcartliost(BuildContext context,customerId) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.getuser_cart+customerId),
        headers: headers,
      );
      print("Cart fetched: ${response.body}");
      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized access'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        UnauthDilogbox();
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
  Future<Either<Failure, dynamic>> UpdatetoCart (BuildContext context,body,cartId) async {
    try {
      print(body);
      final headers = await ApiHelper.getHeaders();
      final url = Uri.parse('https://c360.zone/demo/shaurya_api/api/v1/cart-update/$cartId');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print("Cart update fetched: ${response.body}");

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized access'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        UnauthDilogbox();
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
  @override
  Future<Either<Failure, dynamic>> OrderStore (BuildContext context,body,customerId) async {
try{
  final headers = await ApiHelper.getHeaders();

  final url = Uri.parse(URLConst.baseURL+URLConst.create_quatation);

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

      print("Order update fetched: ${response.body}");

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unauthorized access'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
        UnauthDilogbox();
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      if (response.statusCode == 200) {
        print("Order update: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);

      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to post order',
        ));
      }
    } catch (e) {
      return Left(Failure(
        statusCode: 500,
        message: 'Error occurred: $e',
      ));
    }
  }
}
