import 'dart:convert';

import 'package:ACI/Model/SurveyModel.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SurveymenuDetails extends StatefulWidget {
  final SurveyModel surveyModel;
  final int index;

  SurveymenuDetails({Key? key, required this.surveyModel, required this.index})
      : super(key: key);

  @override
  _SurveymenuDetailsState createState() => _SurveymenuDetailsState();
}

class _SurveymenuDetailsState extends State<SurveymenuDetails> {
  static final SurveyRepo resourceRepository = new SurveyRepo();

  bool isload = false;

  String username = "";

  String userImage = "";

  @override
  void initState() {
    super.initState();
    getuserName();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Survey'),
          centerTitle: true,
          backgroundColor: AppColors.APP_BLUE,
          automaticallyImplyLeading: true,
        ),
        body: survey());
  }

  getuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    var encoded = utf8.encode(res);
    final resourceDetailsResponse = json.decode(utf8.decode(encoded));
    //debugPrint("resourceDetailsResponse:==>" + resourceDetailsResponse.toString());
    setState(() {
      username = resourceDetailsResponse['firstName'];
      globalCurrentUserMobileNo = resourceDetailsResponse['mobile'];
      globalCurrentUserId = resourceDetailsResponse['id'];
      userImage = resourceDetailsResponse['profilePicture'];
      print(userImage);
    });
  }

  Widget survey() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 150,
        padding: const EdgeInsets.only(
          left: 25,
          top: 7,
          right: 15,
          bottom: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                top: 20,
                right: 0,
                bottom: 10,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new CircleAvatar(
                        radius: 25.0,
                        backgroundColor: const Color(0xFF778899),
                        backgroundImage: userImage != 'null'
                            ? NetworkImage(userImage.toString())
                            : AssetImage("images/photo_avatar.png")
                                as ImageProvider),
                    SizedBox(width: 10),
                    new Expanded(
                        child: Text(
                            username == null ? "" : "Hi " + username.trim(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)))
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only( left: 10,
                top: 7,
                right: 15,
                bottom: 15,),
              child: Text(
                widget.surveyModel.topText!,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
                style: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Divider(
              height: 5,
              thickness:1,
            ),
            Padding(
              padding: const EdgeInsets.only( left: 10,
                top: 7,
                right: 15,
                bottom: 15,),
              child: Text(
               "1."+ widget.surveyModel.questions![widget.index].question!,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
                style: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),

            Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      widget.surveyModel.questions![widget.index].url!),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            )
          ],
        ));
  }

  Widget buildLoading() {
    return Container(
      height:
          MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}
