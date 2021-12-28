import 'dart:convert';

import 'package:ACI/Model/SurveyModel.dart';
import 'package:ACI/Model/survey_details_model.dart';
import 'package:ACI/Screen/ScreenCheck.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MyHomePageACI extends StatefulWidget {

  MyHomePageACI() : super();

  @override
  _MyHomePageACIState createState() => _MyHomePageACIState();
}

class _MyHomePageACIState extends State<MyHomePageACI> {
  static final SurveyRepo resourceRepository = new SurveyRepo();

  bool isload = false;

  String username = "";

  String userImage = "";

  @override
  void initState() {
    super.initState();
    getuserName();
    // getsurvey();
  }

  void getsurvey() async {
    isload = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Task'),
      //   centerTitle: true,
      //   backgroundColor: AppColors.APP_BLUE,
      //   automaticallyImplyLeading: true,
      // ),
        body: isload ? buildLoading() :
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                top: 15,
                right: 15,
                bottom: 0,
              ),
              child: Text(
                  username == null
                      ? ""
                      : "Hi " + username.trim()+" ,",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                top: 7,
                right: 15,
                bottom: 15,
              ),
              child: Text(
                "You have a scheduled appointment on January 8,2022 at 3:20 PM at the Adayar Cancer Institute",
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 3,
                style: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Divider(
              height: 5,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: 7, bottom: 7),
              child: Container(
                  padding: const EdgeInsets.only(
                    left: 25,
                    top: 7,
                    right: 15,
                    bottom: 7,
                  ),
                  // decoration: BoxDecoration(
                  //     color: AppColors.APP_LIGHT_BLUE,
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(16.0),
                  //         topRight: Radius.circular(16.0))),
                  child: Text(
                    "My To Do List",
                    style:
                    TextStyle(fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.APP_LIGHT_BLUE),
                  )),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,

                  scrollDirection: Axis.vertical,
                  // physics: NeverScrollableScrollPhysics(),
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemCount: 3,
                  itemBuilder: (BuildContext context,
                      int index) {
                    return Card(
                      color: AppColors.APP_LIGHT_BLUE,
                      child: ListTile(

                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(

                          )),)
                              .then((val)=>getsurvey());

                        },
                        title: Text(index==0?'Screening Check':'Medication Instruction', style:
                        TextStyle(fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.APP_WHITE)
                        ),
                        trailing:
                        Text(index==0?'65%':'10%', style:
                        TextStyle(fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColors.APP_WHITE)
                        ),
                      ),
                    );
                  }),
            )

          ],
        ));
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

  @override
  void dispose() {
    super.dispose();
  }


  Widget buildLoading() {
    return Container(
      height:
      MediaQuery
          .of(context)
          .size
          .height - (AppBar().preferredSize.height),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
