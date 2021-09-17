import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pahir/Model/AddUpdateReviewModel.dart';
import 'package:pahir/Model/AddUpdtReviewRespModel.dart';
import 'package:pahir/Model/PrivacyModel.dart';
import 'package:pahir/Model/ResourceSearchNew.dart';
import 'package:pahir/Model/ResourceSearchNew.dart';
import 'package:pahir/Model/create_edit_profile_model.dart';
import 'package:pahir/Model/resources.dart';
import 'package:pahir/Model/skill_item.dart';
import 'package:pahir/data/globals.dart';
import 'package:pahir/utils/values/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';


class ResourceRepo {
  final storage = new FlutterSecureStorage();

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

  Future<http.Response?> removeResource(Resources resourceModel) async {
    try {
      final response = await http.delete(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resource/${resourceModel.id}'),
          headers: requestHeaders);
      print(response);
      return response;
    } on SocketException {
      return null;
    }
  }

  Future<http.Response?> addreview(Resources resourceModel, String filePath,
      AddUpdateReviewModel addUpdateReviewModel) async {
    try {
      String resource_id = "";
      Resources resourceDetail;
      final response = await http.post(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resources'),
          headers: requestHeaders,
          body: jsonEncode(resourceModel));
      print(response.body);
      if (response.statusCode == 200) {
        // print("Add Resource response :==>"+response.body.toString());

        final resourceCreationResponse =
            json.decode(utf8.decode(response.bodyBytes));

        resource_id = resourceCreationResponse['id'];
        if (filePath.length > 0) {
          String res = await fileuploadresource(
              filePath: filePath, resource_id1: resource_id);
          print(res);
        }

        try {
          resourceDetail =
              Resources.fromJson(json.decode(utf8.decode(response.bodyBytes)));

          if (resourceDetail != null) {
            //print("resourceDetail.id ==>"+resourceDetail.id);
            var res = await addORUpdateReview(
                addUpdateReviewModel, resourceDetail.id);
          }
        } on Exception catch (e) {
          //print("Exception :==>"+e.toString());
          return response;
        }
        return response;
      } else {
        return response;
      }
    } on SocketException {
      return null;
    }
  }
  Future<http.Response?> addreviewresource(ResourceResults resourceModel, String filePath,
      AddUpdateReviewModel addUpdateReviewModel) async {
    try {
      String resource_id = "";
      Resources resourceDetail;
      final response = await http.post(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resources'),
          headers: requestHeaders,
          body: jsonEncode(resourceModel));
      print(response.body);
      print(response.statusCode);
      print(response.request!.url.toString());
      if (response.statusCode == 200) {
        // print("Add Resource response :==>"+response.body.toString());

        final resourceCreationResponse =
            json.decode(utf8.decode(response.bodyBytes));

        resource_id = resourceCreationResponse['id'];
        if (filePath.length > 0) {
          String res = await fileuploadresource(
              filePath: filePath, resource_id1: resource_id);
          print(res);
        }

        try {
          resourceDetail =
              Resources.fromJson(json.decode(utf8.decode(response.bodyBytes)));

          if (resourceDetail != null) {
            //print("resourceDetail.id ==>"+resourceDetail.id);
            var res = await addORUpdateReview(
                addUpdateReviewModel, resourceDetail.id);
          }
        } on Exception catch (e) {
          //print("Exception :==>"+e.toString());
          return response;
        }
        return response;
      } else {
        return response;
      }
    } on SocketException {
      return null;
    }
  }

  Future<AddUpdtReviewRespModel?> addORUpdateReview(
      AddUpdateReviewModel addUpdateReviewModel, String? resourceId) async {
    AddUpdtReviewRespModel? addUpdtReviewRespModel;
    ////api/v1/review/{resourceId}/{userId}
    final response = await http.put(
        Uri.parse(
            '${AppStrings.BASE_URL}api/v1/review/$resourceId/$globalUserId'),
        headers: requestHeaders,
        body: jsonEncode(addUpdateReviewModel));
    // print("AddUpdateReviewModel request :==>"+response.request.url.toString());
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      try {
        addUpdtReviewRespModel = AddUpdtReviewRespModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        if (addUpdtReviewRespModel != null) {}
      } on Exception catch (e) {
        return null;
      }
      return addUpdtReviewRespModel;
    } else
      return null;
  }

  Future<String> fileuploadresource({
    String? filePath,
    String? resource_id1,
  }) async {
    try{
      final storage = new FlutterSecureStorage();
      String resource_id = '';
      if (filePath!.length > 0) {
        var postUri = Uri.parse(
            '${AppStrings.BASE_URL}api/v1/user/${globalCountryCode}/${globalPhoneNo}/picture/$resource_id1');

        File imageFile = File(filePath);
        var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        // get file length
        var length = await imageFile.length();
        // create multipart request
        var request = new http.MultipartRequest("PUT", postUri);

        // multipart that takes file
        var multipartFile = new http.MultipartFile('picture', stream, length,
            filename: basename(imageFile.path));

        // add file to multipart
        request.files.add(multipartFile);

        // send

        var at = await storage.read(key: "accessToken");
        var uph = await storage.read(key: "userFingerprintHash");
        if (at != null) {
          request.headers["Authorization"] = "Bearer " + at;
          request.headers["userFingerprintHash"] = uph!;
          request.headers["appcode"] = "100000";
          request.headers["licensekey"] = "90839e11-bdce-4bc1-90af-464986217b9a";
        }
        var response = await request.send();

        print(response.statusCode);

        if (response.statusCode == 200) {
          //Get the response from the server
          var responseData = await response.stream.toBytes();
          var responseString = await String.fromCharCodes(responseData);
          print(responseString);

          print(responseString);
          final responseJson = await json.decode(responseString);
          resource_id = responseJson['message'];
        } else {
          print(response.statusCode);
        }
      }

      return resource_id;
    }catch(_){
      return "";

    }

  }

  Future<List<SkillItemModel>> getSkillList() async {
    late List<SkillItemModel> skillList;
    try {
      final response = await http.get(
          Uri.parse('${AppStrings.BASE_URL}api/v1/skills'),
          headers: requestHeaders);

      skillList = (json.decode(utf8.decode(response.bodyBytes)) as List)
          .map((i) => SkillItemModel.fromJson(i))
          .toList();
      print(">>>${skillList.length}");
    } on Exception catch (e) {
      print(">>>${skillList.length}");
    }
    return skillList;
  }

  Future<http.Response?> fetchResourceData1(
      String resourceId, String resourceType) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v2.2/user/${globalCountryCode}/${globalPhoneNo}/resource/${resourceId}?resourceType=${resourceType}'),
          headers: requestHeaders);
      print(" fetchResourceData Request Url :==>" +
          response.request!.url.toString());
      print(" fetchResourceData Response data :==>" + response.body.toString());
      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } on SocketException {
      return null;
    } on Exception catch (e) {
      return null;
    }
  }

  Future<http.Response?> updateResourceData1(
      {required ResourceResults addResourceModel}) async {
    try {
      final response = await http.put(
          Uri.parse(
              '${AppStrings.BASE_URL}api/v1/user/$globalCountryCode/$globalPhoneNo/resource/${addResourceModel.id}'),
          headers: requestHeaders,
          body: jsonEncode(addResourceModel));
      log(response.statusCode.toString());
      log(response.request!.url.toString());
      return response;
    } on SocketException {
      return null;
    } catch (_) {
      return null;
    }
  }
  Future<PrivacyModel> getprivacy(
      CreateEditProfileModel createEditProfileModel) async {
    PrivacyModel resourceList=PrivacyModel();
    try {
      final response = await http.get(
        Uri.parse('${AppStrings.BASE_URL}api/v1/privacy/user/${createEditProfileModel.id.toString()}'),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      print("getHomeData request :==>" + response.request!.url.toString());
      print("getHomeData response :==>" + response.body.toString());

      if (response.statusCode == 200) {
        resourceList =
            PrivacyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
    } on Exception catch (e) {
      throw e;
    }
    return resourceList;
  }

  Future<PrivacyModel> setprivacy(CreateEditProfileModel createEditProfileModel,
      PrivacyModel privacyModel) async {
    PrivacyModel resourceList=PrivacyModel();
    try {
      final response = await http.post(
          Uri.parse('${AppStrings.BASE_URL}api/v1/privacy/user/${createEditProfileModel.id.toString()}'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode(privacyModel));

      print("getHomeData request :==>" + response.request!.url.toString());
      print("getHomeData response :==>" + response.body.toString());

      if (response.statusCode == 200) {
        resourceList =
            PrivacyModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
    } on Exception catch (e) {
      throw e;
    }
    return resourceList;
  }

  Future<ResourceSearchNew> getSearchData2(
      String searchString, int start, int limit) async {
    List<SearchResults> searchResultList;
    late ResourceSearchNew searchResultResModel;



    try {
      final response = await http.get(
        //'${AppStrings.BASE_URL}api/v2/user/${globalCountryCode}/${globalPhoneNo}/resources/search?limit=$limit&searchString=$searchString&start=$start',
        //Old Url
        // '${AppStrings.BASE_URL}api/v2.2/user/${globalCountryCode}/${globalPhoneNo}/resources/search?limit=$limit&searchString=$searchString&start=$start',

        //New Url
        Uri.parse('${AppStrings.BASE_URL}api/v2.4/user/${globalCountryCode}/${globalPhoneNo}/resources/search?limit=$limit&searchString=$searchString&start=$start'),
        //'https://api.pahir.com/api/v2.3/user/+91/9994081073/resources/search?limit=10&searchString=Electrician&start=0',
        headers: requestHeaders,
      );

      print("getSearchData1 request.url body:==>"+response.request!.url.toString());

      print("getSearchData1 body:==>"+response.body.toString());

      searchResultResModel = ResourceSearchNew.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      if(searchResultResModel != null){

        /////sharedDetails data or Referrer name data start///
        if(searchResultResModel.searchResults != null) {
          for (int arrIndx = 0; arrIndx <searchResultResModel.searchResults!.length; arrIndx++) {
            List<ResourceResults> resourceResults = searchResultResModel.searchResults![arrIndx].resourceResults!;
            if(resourceResults != null){
              // for (int itemIndx = 0; itemIndx <resourceResults.length; itemIndx++) {
              //
              //   List<ResourceSearchNew.SharedDetails> sharedDetails  = resourceResults![itemIndx].sharedDetails!;
              //   String referrerNames = "";
              //   if(sharedDetails != null){
              //     for (int innerItemIndx = 0; innerItemIndx <sharedDetails.length; innerItemIndx++) {
              //       if(referrerNames != ""){
              //         referrerNames =  referrerNames +","+ resourceResults![itemIndx].sharedDetails![innerItemIndx].firstName!;
              //       }else{
              //         referrerNames =  resourceResults[itemIndx].sharedDetails![innerItemIndx].firstName!;
              //       }
              //     }
              //   }
              //   print("Referrer Name in res_repos :==>"+referrerNames);
              //   resourceResults[itemIndx].manualAddedReferrerName = referrerNames;
              //
              // }
            }

          }
        }
        //////////sharedDetails data or Referrer name data start//////

        searchResultList = searchResultResModel.searchResults!;
      }

    } on Exception catch (e) {
      print("Exception :==>"+e.toString());
      // TODO
    }
    return searchResultResModel;
  }

}
