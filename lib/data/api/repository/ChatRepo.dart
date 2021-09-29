import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:pahir/Model/AddUpdateReviewModel.dart';
import 'package:pahir/Model/AddUpdtReviewRespModel.dart';
import 'package:pahir/Model/AddchatnewModel.dart';
import 'package:pahir/Model/ChatGroupModelResponse.dart';
import 'package:pahir/Model/GroupchatMembersModel.dart';
import 'package:pahir/Model/GroupsModelChat.dart';
import 'package:pahir/Model/ResourceSearchNew.dart';
import 'package:pahir/Model/create_edit_profile_model.dart';
import 'package:pahir/Model/resources.dart';
import 'package:pahir/Model/skill_item.dart';
import 'package:pahir/data/globals.dart';
import 'package:pahir/data/sp/shared_keys.dart';
import 'package:pahir/utils/values/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepo {

  Future<http.Response?> gethomedata() async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/${globalCountryCode}/${globalPhoneNo}/resources'),
          headers: requestHeaders);
      log(response.body);
      return response;
    } on SocketException {
      return null;
    } catch (_) {
      return null;
    }
  }



  Future<GroupchatMembersModel?> getchatpersonsgrpsfordisplay( String grpid) async {
    GroupchatMembersModel? searchResultResModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CreateEditProfileModel createEditProfileModel;
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    try {
      final response = await http.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/chat/members/org/1/group/$grpid/user/${createEditProfileModel.id}'),
        headers: requestHeaders,
      );

      print("getSearchData1 request.url body:==>" +
          response.request!.url.toString());

      // print("getSearchData1 body:==>" + response.body.toString());
      log(response.body.toString());

      searchResultResModel = GroupchatMembersModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } on Exception catch (e) {
      print("Exception :==>" + e.toString());
      // TODO
    }
    return searchResultResModel;
  }
  Future<GroupchatMembersModel?> getorgid( String grpid) async {
    GroupchatMembersModel? searchResultResModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CreateEditProfileModel createEditProfileModel;
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    try {
      final response = await http.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/organization/user/${globalCountryCode}/${globalPhoneNo}'),
        headers: requestHeaders,
      );

      print("getSearchData1 request.url body:==>" +
          response.request!.url.toString());

      // print("getSearchData1 body:==>" + response.body.toString());
      log(response.body.toString());

      searchResultResModel = GroupchatMembersModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } on Exception catch (e) {
      print("Exception :==>" + e.toString());
      // TODO
    }
    return searchResultResModel;
  }


  Future<ChatGroupModelResponse?> sentgroupsnotificationinchat(GroupsModelChat grpname,
      CreateEditProfileModel createEditProfileModel,grpid,userid) async {
    String courseModel;
    ChatGroupModelResponse? createGroupSuccessModel;

    try {


      final response = await http.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/chat/group/notification/org/1/group/$grpid/user/$userid'),
          headers: requestHeaders,
          body: jsonEncode(grpname));
      print(response.body.toString());

      if (response.statusCode == 200) {
        createGroupSuccessModel = ChatGroupModelResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        courseModel = "0";
      } else {
        courseModel = "1";
      }

      print("getHomeData request :==>" +
          response.request!.url.toString() +
          grpname.toJson().toString());
      print("getHomeData response :==>" + response.body.toString());
    } on Exception catch (e) {
      throw e;
    }
    return createGroupSuccessModel;
  }
  Future<AddchatnewModel?> searchchatpersons(String search) async {
    AddchatnewModel? searchResultResModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CreateEditProfileModel createEditProfileModel;
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    try {
      final response = await http.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/chat/users/university/1/orgMember/1/search/$search'),
        headers: requestHeaders,
      );

      print("getSearchData1 request.url body:==>" +
          response.request!.url.toString());

      // print("getSearchData1 body:==>" + response.body.toString());
      log(response.body.toString());
      if (response.statusCode==200) {
        searchResultResModel = AddchatnewModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
      }


    } on Exception catch (e) {
      print("Exception :==>" + e.toString());
      // TODO
    }
    return searchResultResModel;
  }
  Future<AddchatnewModel?> getchatpersons(String page, String limit) async {
    AddchatnewModel? searchResultResModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CreateEditProfileModel createEditProfileModel;
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    try {
      final response = await http.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/chat/users/university/1/orgMember/1?start=$page&limit=$limit'),
        headers: requestHeaders,
      );

      print("getSearchData1 request.url body:==>" +
          response.request!.url.toString());

      // print("getSearchData1 body:==>" + response.body.toString());
      log(response.body.toString());

      searchResultResModel = AddchatnewModel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } on Exception catch (e) {
      print("Exception :==>" + e.toString());
      // TODO
    }
    return searchResultResModel;
  }
  Future<AddchatnewModel?> getchatpersonsgrps(String page, String limit, String grpid) async {
    AddchatnewModel? searchResultResModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CreateEditProfileModel createEditProfileModel;
    final resourceDetailsResponse = await json
        .decode(prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString());
    createEditProfileModel =
        CreateEditProfileModel.fromJson(resourceDetailsResponse);
    try {
      final response = await http.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/chat/users/university/1/orgMember/1/chatgroup/$grpid?start=$page&limit=$limit'),
        headers: requestHeaders,

      );

      print("getSearchData1 request.url body:==>" +
          response.request!.url.toString());

      // print("getSearchData1 body:==>" + response.body.toString());
      log("body"+response.body.toString());
      if (response.statusCode==200) {
        searchResultResModel = AddchatnewModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
      }

    } on Exception catch (e) {
      print("Exception :==>" + e.toString());
      // TODO
    }
    return searchResultResModel;
  }
  Future<ChatGroupModelResponse?> addgroupsinchat(GroupsModelChat grpname,
      CreateEditProfileModel createEditProfileModel,grpid,userid) async {
    String courseModel;
    ChatGroupModelResponse? createGroupSuccessModel;

    try {


      final response = await http.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/chat/member/org/1/group/$grpid/user/$userid'),
          headers: requestHeaders,
          body: jsonEncode(grpname));
      print("body"+response.body.toString());

      if (response.statusCode == 200) {
        createGroupSuccessModel = ChatGroupModelResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        courseModel = "0";
      } else {
        courseModel = "1";
      }

      print("getHomeData request :==>" +
          response.request!.url.toString() +
          grpname.toJson().toString());
      print("getHomeData response :==>" + response.body.toString());
    } on Exception catch (e) {
      throw e;
    }
    return createGroupSuccessModel;
  }
  Future<ChatGroupModelResponse?> deletegroupsinchat(
      CreateEditProfileModel createEditProfileModel,grpid,userid) async {
    String courseModel;
    ChatGroupModelResponse? createGroupSuccessModel;

    try {


      final response = await http.delete(
        Uri.parse('${AppStrings.BASE_URL}api/v1/chat/group/org/1/group/$grpid/user/$userid'),
        headers: requestHeaders,
      );
      print(response.body.toString());

      if (response.statusCode == 200) {
        createGroupSuccessModel = ChatGroupModelResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        courseModel = "0";
      } else {
        courseModel = "1";
      }

      print("getHomeData request :==>" +
          response.request!.url.toString());
      print("getHomeData response :==>" + response.body.toString());
    } on Exception catch (e) {
      throw e;
    }
    return createGroupSuccessModel;
  }
  Future<ChatGroupModelResponse?> creategroupsinchat(GroupsModelChat grpname,
      CreateEditProfileModel createEditProfileModel,grpid,userid) async {
    String courseModel;
    ChatGroupModelResponse? createGroupSuccessModel;

    try {


      final response = await http.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/chat/group/org/1/group/$grpid/user/$userid'),
          headers: requestHeaders,
          body: jsonEncode(grpname));
      print(response.body.toString());

      if (response.statusCode == 200) {
        createGroupSuccessModel = ChatGroupModelResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        courseModel = "0";
      } else {
        courseModel = "1";
      }

      print("getHomeData request :==>" +
          response.request!.url.toString() +
          grpname.toJson().toString());
      print("getHomeData response :==>" + response.body.toString());
    } on Exception catch (e) {
      throw e;
    }
    return createGroupSuccessModel;
  }

}
