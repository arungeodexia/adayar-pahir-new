import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:pahir/Screen/login_init_view.dart';
import 'package:pahir/data/globals.dart';
import 'package:pahir/data/sp/shared_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiInterceptor implements InterceptorContract {
// Create storage

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers["appcode"] = "300000";
    data.headers["licensekey"] = "0b48fc5c-2af6-47d9-a2d6-aff2b91b152c";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accesstoken= prefs.getString("accessToken");
      String? userFingerprintHash= prefs.getString("userFingerprintHash");
      String? pahirAuthHeader= prefs.getString("pahirAuthHeader");
      var at = accesstoken;
      var uph = userFingerprintHash;
      if (at != null) {
        data.headers["Authorization"] = "Bearer " + at;
        data.headers["userFingerprintHash"] = uph!;
        data.headers["Content-Type"] = "application/json";
        data.headers["Access-Control-Expose-Headers"]= "*";
        if(kIsWeb){
          data.headers["pahiruserauth"]= pahirAuthHeader!;
        }
      }
    } on Exception catch (e) {
      // TODO
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print(data.request!.headers.toString());
    print(data.body.toString());
    if (data.request!.url.toString()=="https://api.pahir.com/api/v1/message/+91/8667236028") {
      Navigator.pushAndRemoveUntil(
          globalcontext!, _dashBoardRoute, (Route<dynamic> r) => false);
    }
   if (kIsWeb) {
     if (data.statusCode==200) {
      try{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var resourceDetailsResponse = json.decode(data.body.toString());
        String pahirAuthHeader = resourceDetailsResponse['pahirAuthHeader'];
        prefs.setString("pahirAuthHeader", pahirAuthHeader);
        log(pahirAuthHeader.toString());
      }catch(e){
        log(e.toString());
      }
     }else if (data.statusCode==401) {
       Fluttertoast.showToast(msg: "401");
       SharedPreferences prefs =
       await SharedPreferences.getInstance();
       prefs.setBool(IS_LOGGED_IN, false);
       await prefs.clear();
       Navigator.pushAndRemoveUntil(
           globalcontext!, _dashBoardRoute, (Route<dynamic> r) => false);

     }
   }
    return data;
  }
  final PageRouteBuilder _dashBoardRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return LoginInitView();
    },
  );
}