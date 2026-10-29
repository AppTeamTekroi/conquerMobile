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
  Future<Either<Failure, dynamic>> Quatationlist(int page,String searchQuery);
  Future<Either<Failure, dynamic>> Quatationdetails(BuildContext context,String qd_int,String page);
  Future<Either<Failure, dynamic>> QuatationStore ( Map<String, dynamic> body,String page,File file);

}

class QuatationImpl implements QuatationRepository {
  @override
  Future<Either<Failure, dynamic>> Quatationlist(page,searchQuery) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse('${URLConst.baseURL}${URLConst.quatations_list}?page=$page&search_quotation=$searchQuery');
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
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
  Future<Either<Failure, dynamic>> Quatationdetails(BuildContext context,qd_int,String page) async {
    try {
      final headers = await ApiHelper.getHeaders();
      var url;
      if(page == 'opportunity')
       url = Uri.parse(URLConst.baseURL+URLConst.Opportunity_details+qd_int);
      if(page == 'quotation')
         url = Uri.parse(URLConst.baseURL+URLConst.quatations_details+qd_int);
      if(page == 'order')
        url = Uri.parse(URLConst.baseURL+URLConst.order_details+qd_int);

      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
     // print("List fetched: ${response.body}");

      if (response.statusCode == 401) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Unauthorized access'),
      //       duration: Duration(seconds: 3),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   UnauthDilogbox(); // Call your custom dialog here if needed.
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }

      if (response.statusCode == 200) {
       // print("Quatation details fetched: ${response.body}");
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
  Future<Either<Failure, dynamic>> QuatationStore(body,String page,file) async {
    try {
      final headers = await ApiHelper.getHeaders();
      // final url;
      // (page == 'opportunity')
      //     ?url = Uri.parse(URLConst.baseURL + URLConst.create_convertQuotation)
      final url = Uri.parse(URLConst.baseURL + URLConst.create_quatation);
      print(url);
      //   create-convert-quotation
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

      // late File selectedFile = File(''); // Default empty file

      request.headers.addAll(headers);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Order update fetched: ${response.body}");

      // if (response.statusCode == 401) {
      //   // ScaffoldMessenger.of(context).showSnackBar(
      //   //   SnackBar(
      //   //     content: Text('Unauthorized access'),
      //   //     duration: Duration(seconds: 3),
      //   //     backgroundColor: Colors.red,
      //   //   ),
      //   // );
      //   UnauthDilogbox();
      //   return Left(Failure(
      //     statusCode: 401,
      //     message: 'Unauthorized access',
      //   ));
      // }
      if (response.statusCode == 200) {
        print("Quatation update: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else if  (response.statusCode == 401) {
        return Left(Failure(
          statusCode: 401,
          message: 'Unauthorized access',
        ));
      }
      else {
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