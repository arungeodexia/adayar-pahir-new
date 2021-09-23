library ishare.globals;

import 'package:pahir/Bloc/message/message_model_class.dart';
import 'package:pahir/Model/GetReviewResponse.dart';
import 'package:pahir/Model/ResourceSearchNew.dart';
import 'package:pahir/Model/add_resource_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool isResource = false;
String globalCountryCode = "";
String globalPhoneNo = "";
int globalUserId = 0;
String globalResourceId = "";
String globalSearchData = "";
String timezone = 'Unknown';
List finalSelectedList = [];

bool globalIsLaunch = false;
bool globalAndroidIsOnMsgExecuted = false;
bool globalAndroidIsOnResumeExecuted = false;
String globalCurrentUserMobileNo = "";
int globalCurrentUserId = 0;
String globalResourceType = "";
bool globalISPNPageOpened = false;
bool globalqr = false;

String listKey = "Tamil Nadu";
String listid = "";
String unreads = "0";
AddResourceModel? globalAddResourceModel;
//SearchResultDetailsModel globalSearchResourceModel;
ResourceResults? globalSearchResourceModel;
GetReviewResponse? globalReviewResponse;
MessagesModel? globalMessagesResponse;
/// 加法事件
const actionIncrement = 'actionIncrement';

/// 减法事件
const actionDecrease = 'actionDecrease';

/// 直接修改事件
const actionChange = 'actionChange';
Map<String, String> requestHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
  'appcode': '100000',
  'licensekey': '90839e11-bdce-4bc1-90af-464986217b9a',
};

