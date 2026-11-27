import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:vconquer/core/error/failure.dart';
import '../../core/API/URLConst.dart';

class AuthService {
  Future<Either<Failure, Map<String, dynamic>>> login(
      String userName, String password) async {
    try {
      print('$userName,$password');

      final Map<String, dynamic> requestBody = {
        "email": userName,
        "password": password,
      };

      final response = await http.post(
        Uri.parse(URLConst.baseURL + URLConst.loginURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print("response in auth");
      print('post response ${response.body}');

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Invalid server response',
        ));
      }

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic> &&
          responseData['access_token'] != null) {
        return Right(responseData);
      }

      var message = responseData is Map<String, dynamic>
          ? (responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              'Failed to login user')
          : 'Failed to login user';

      // Backend bug when user is missing/inactive: $user->password on null.
      if (message.contains("password") && message.contains("non-object")) {
        message =
            'Invalid email/password, or this account is inactive (status must be 1).';
      }

      return Left(Failure(
        statusCode: response.statusCode,
        message: message,
      ));
    } catch (e) {
      print('Exception: $e');
      return Left(Failure(statusCode: 500, message: 'Failed to login: $e'));
    }
  }
}
