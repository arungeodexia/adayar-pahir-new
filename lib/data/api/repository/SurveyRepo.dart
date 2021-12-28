import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ACI/Model/create_edit_profile_model.dart';
import 'package:ACI/Model/device_info_model.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import '../../device_info.dart';
import 'api_intercepter.dart';

class SurveyRepo {
  Client client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);

  Future<http.Response?> getSurvey() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/survey/user/1/questions'),
           );
      log(response.body);
      print(response.request!.headers);
      log(response.request!.url.toString());;
      return response;
    } on SocketException {
      return null;
    }
  }
  Future<http.Response?> getSurveyDetails(String questionid) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.Response response = await client.get(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/survey/user/1/question/${questionid}'),
           );
      log(response.body);
      print(response.request!.headers);
      log(response.request!.url.toString());;
      return response;
    } on SocketException {
      return null;
    }
  }
}