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

abstract class OpportunityRepository {
  Future<Either<Failure, dynamic>> Opportunitylist(BuildContext context,int page,String searchQuery);
  Future<Either<Failure, dynamic>> Opportunitydetails(BuildContext context,String qd_int);
  Future<Either<Failure, dynamic>> OpportunityStore(BuildContext context,body,String customerId,File file);

}

class OpportunityImpl implements OpportunityRepository {
  @override
  Future<Either<Failure, dynamic>> Opportunitylist(BuildContext context,page,searchQuery) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse('${URLConst.baseURL}${URLConst.Opportunity_list}?page=$page&search_quotation=$searchQuery');
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

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
        print("Opportunity List fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Opportunity list data',
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
  Future<Either<Failure, dynamic>> Opportunitydetails(BuildContext context,qd_int) async {
    try {
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.Opportunity_details+qd_int);
      print(url);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("List fetched: ${response.body}");

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
        print("Opportunity details fetched: ${response.body}");
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Right(jsonResponse);
      } else {
        return Left(Failure(
          statusCode: response.statusCode,
          message: 'Failed to fetch Opportunity list data',
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
  Future<Either<Failure, dynamic>> OpportunityStore (BuildContext context,body,customerId,file) async {
    try{
      final headers = await ApiHelper.getHeaders();

      final url = Uri.parse(URLConst.baseURL+URLConst.create_Opportunity);

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
        // return Left(Failure(
        //   statusCode: 401,
        //   message: 'Unauthorized access',
        // ));
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