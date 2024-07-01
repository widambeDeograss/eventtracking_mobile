// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:eventtracking/constants/app_constants.dart';

class CallApi {
  var token = '';

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      };

  nidaInfoRequested(data, apiUrl, String type, {context}) async {
    var fullUrl = AppConstants.nidaBaseUrl + apiUrl;
    var response;
    try {
      if (type == "get") {
        response = await http.get(
          Uri.parse(fullUrl),
        );
      }
      return response.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

  authenticatedRequest(data, apiUrl, String type, {context}) async {
    // await getToken(context);
    // "get", "post"
    // ignore: prefer_typing_uninitialized_variables
    var res;
    try {
      if (type == "get") {
        res = await http.get(
          Uri.parse(apiUrl),
          headers: _setHeaders(),
        );
      } else if (type == "post") {
        res = await http.post(
          Uri.parse(
            apiUrl,
          ),
          body: jsonEncode(data),
          headers: _setHeaders(),
        );
        print(res);
      }
      else if (type == "delete") {
        res = await http.delete(
          Uri.parse(
            apiUrl,
          ),
          body: jsonEncode(data),
          headers: _setHeaders(),
        );
        print(res);
      }
      return res.body;
    } catch (e) {
      print(e);
      return null;
    }
  }

  uploadWithFile(data, apiUrl) async {
    var fullUrl = AppConstants.apiBaseUrl + apiUrl;
    //   {
    //   'name': 'dio',
    //   'date': DateTime.now().toIso8601String(),
    //   'file': await MultipartFile.fromFile('./text.txt', filename: 'upload.txt'),
    //   'files': [
    //     await MultipartFile.fromFile('./text1.txt', filename: 'text1.txt'),
    //     await MultipartFile.fromFile('./text2.txt', filename: 'text2.txt'),
    //   ],
    // }
    FormData formData = FormData.fromMap(data);
    try {
      Response response = await Dio().post(fullUrl, data: formData);
      // print('Response status: ${response.statusCode}');
      return response.data;
    } catch (error) {
      return null;
    }
  }
}
