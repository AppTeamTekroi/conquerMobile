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

abstract class OrdersRepository {
  Future<Either<Failure, dynamic>> fetchorderlist(int page,String searchQuery);
  Future<Either<Failure, dynamic>> StoreOrder(body,String customerId,File file);

}

class OrdersSourceImpl implements OrdersRepository {

  @override
  Future<Either<Failure, dynamic>> fetchorderlist(page,searchQuery) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse('${URLConst.baseURL}${URLConst.order_list}?page=$page&search_quotation=$searchQuery');
    //?draw=1&length=10&start=0&branch_count=&status=&search_quotation
    final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

      // if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
      //   return Left(Failure(
      //     statusCode: 401,
      //     message: 'Unauthorized access',
      //   ));
      // }

      if (response.statusCode == 200) {
        print("Order List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch order list data',
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
  Future<Either<Failure, dynamic>> StoreOrder (body,customerId,File file) async {
    try{
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.create_order);

      // final response = await http.post(
      //   url,
      //   headers: headers,
      //   body: json.encode(body),
      // );
      var request = await http.MultipartRequest('POST',url);
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (file != null && file.path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'attachements',

            file.path,
          ),
        );
      }

      request.headers.addAll(headers);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Order update fetched: ${response.body}");

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