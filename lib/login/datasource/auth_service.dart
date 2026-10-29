import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:vconquer/core/error/failure.dart';
import '';
import '../../core/API/URLConst.dart';

class AuthService {
  Future<Either<Failure, Map<String, dynamic>>> login(String UserName, String Password) async {
    try {
      print('$UserName,$Password');

      final Map<String, dynamic> requestBody = {
        "email": UserName,
        "password": Password,
      };

      final response = await http.post(
        Uri.parse(URLConst.baseURL+URLConst.loginURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      print("response in auth");
      print('post response ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        return Right(
            responseData); // Return successful response wrapped in Right
      } else {
        // Handle failure case
        return Left(Failure(
            statusCode: response.statusCode, message: 'Failed to login user'));
      }
    } catch (e) {
      // Catch any exceptions and rethrow
      print('Exception: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to logineeee: $e'));
    }
  }
}
