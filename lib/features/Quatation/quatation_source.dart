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

abstract class QuatationRepository {
  Future<Either<Failure, dynamic>> Quatationlist(BuildContext context);
  Future<Either<Failure, dynamic>> Quatationdetails(BuildContext context,String qd_int);
}

class QuatationImpl implements QuatationRepository {
  @override
  Future<Either<Failure, dynamic>> Quatationlist(BuildContext context) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.quatations_list);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

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
        print("Quatation List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Quatation list data',
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
  Future<Either<Failure, dynamic>> Quatationdetails(BuildContext context,qd_int) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.quatations_details+qd_int+'/mobile');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

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
        print("Quatation details fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Quatation list data',
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