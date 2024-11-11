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

abstract class DropdownSourceRepository {
  Future<Either<Failure, dynamic>> fetchbranches(BuildContext context);
  Future<Either<Failure, dynamic>> fetchcategories(BuildContext context);
  Future<Either<Failure, dynamic>> fetchsubCategories(BuildContext context);
  Future<Either<Failure, dynamic>> fetchsalesEmpName(BuildContext context);
  Future<Either<Failure, dynamic>> fetchcountries(BuildContext context);
  Future<Either<Failure, dynamic>> fetchsearchByGstin(BuildContext context);
  Future<Either<Failure, dynamic>> fectchcontact(BuildContext context,String custId);

  Future<Either<Failure, dynamic>> billingaddress(BuildContext context,String custId);

}

class DropdownSourceImpl implements DropdownSourceRepository {

  @override
  Future<Either<Failure, dynamic>> fetchbranches(BuildContext context) async {
    try {
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.branch),
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

  @override
  Future<Either<Failure, dynamic>> fetchcategories(BuildContext context) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.categories),
        headers: headers,
      );
      print("ID fetched: ${response.body}");

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
        print("ID fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
  Future<Either<Failure, dynamic>> fetchsubCategories(BuildContext context) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.subCategories),
        headers: headers,
      );
      print("ID fetched: ${response.body}");

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
        print("ID fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
  Future<Either<Failure, dynamic>> fetchsalesEmpName(BuildContext context) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.salesEmpName),
        headers: headers,
      );
      print("ID fetched: ${response.body}");

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
        print("ID fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
  Future<Either<Failure, dynamic>> fetchcountries(BuildContext context) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.countries),
        headers: headers,
      );
     // print("ID fetched: ${response.body}");

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
        print("ID fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
  Future<Either<Failure, dynamic>> fetchsearchByGstin(BuildContext context) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.searchByGstin),
        headers: headers,
      );
     // print("ID fetched: ${response.body}");

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
       // print("ID fetched: ${response.body}");
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
  Future<Either<Failure, dynamic>> fectchcontact(BuildContext context,customerId) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.contact+customerId),
        headers: headers,
      );
     // print("ID fetched: ${response.body}");

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
       // print("ID fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
  Future<Either<Failure, dynamic>> shippingaddress(BuildContext context,customerId) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.shipping+customerId),
        headers: headers,
      );
     // print("ID fetched: ${response.body}");

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
       // print("ID fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
  Future<Either<Failure, dynamic>> billingaddress(BuildContext context,customerId) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.billing+customerId),
        headers: headers,
      );
      print("ID fetched: ${response.body}");

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
        print("billing addres in source fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
  Future<Either<Failure, dynamic>> Paymentaddress(BuildContext context) async {
    try {
      print(id);
      final headers = await ApiHelper.getHeaders();
      final response = await http.get(
        Uri.parse(URLConst.baseURL+URLConst.payterm),
        headers: headers,
      );
     // print("ID fetched: ${response.body}");

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
       // print("ID fetched: ${response.body}");
        final List<dynamic> jsonResponse = json.decode(response.body);
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
}