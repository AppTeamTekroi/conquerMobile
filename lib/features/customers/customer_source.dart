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

abstract class CustomerSourceRepository {
  Future<Either<Failure, dynamic>> fetchcustomer(int page,String searchQuery);
  Future<Either<Failure, dynamic>> fetchid(BuildContext context, int id);
  Future<Either<Failure, dynamic>> storeCustomer(BuildContext context, dynamic data);

}

class CustomerSourceImpl implements CustomerSourceRepository {

  @override
  Future<Either<Failure, dynamic>> fetchcustomer(page,searchQuery) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
       // Uri.parse('http://127.0.0.1:8000/api/getAllCustomers?draw=1&length=$page&start=0'),
        Uri.parse('${URLConst.baseURL}${URLConst.customers}?page=$page&search=$searchQuery'),

      // Uri.parse(URLConst.baseURL+URLConst.customers),
        headers: headers,
      );
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

      if (response.statusCode == 200) {
        print("List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch customers data',
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
  Future<Either<Failure, dynamic>> fetchid(BuildContext context, int id) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.customersInfo+"$id"+"/mobile"),
        headers: headers,
      );
      print("ID fetched: ${response.body}");

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

      if (response.statusCode == 200) {
        print("ID fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch id details',
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
  Future<Either<Failure, dynamic>> storeCustomer (BuildContext context,data) async {
    try{
      print('kjhgfd$data');
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.storeCustomer);
        print(url);

      var response = await http.post(url,headers: headers,body: data);

      print("Opportunity update fetched: ${response.body}");

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
        print("Opportunity update: ${response.body}");
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
  @override
  Future<Either<Failure, dynamic>> StoreCustomer (BuildContext context,body) async {
    try{
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.storeCustomer);

      var response = await http.post(url,body: body,headers: headers);

      print("Opportunity update fetched: ${response.body}");

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
        print("Opportunity update: ${response.body}");
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
