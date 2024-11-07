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

abstract class ProductRepository {
  Future<Either<Failure, dynamic>> fetchproducts(BuildContext context);

}

class ProductDataSourceImpl implements ProductRepository {
  @override
  Future<Either<Failure, dynamic>> fetchproducts(BuildContext context) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL + URLConst.products),
        headers: headers,
      );
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

      if (response.statusCode == 200) {
        print("List fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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

}
