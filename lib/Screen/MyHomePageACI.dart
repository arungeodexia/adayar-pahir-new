import 'dart:convert';

import 'package:ACI/Model/SurveyModel.dart';
import 'package:ACI/Model/survey_details_model.dart';
import 'package:ACI/Screen/ScreenCheck.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/calls_messages_services.dart';
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
                left: 35,
                top: 15,
                right: 15,
                bottom: 10,
              ),
              child: Text(
                  username == null
                      ? ""
                      : "Hi " + username.trim()+" ,",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,fontFamily: "OpenSans",color: AppColors.APP_BLACK)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      "Clinic Visit",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.APP_TEXT_NAME),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      "Today",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                      color: AppColors.APP_BLACK),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      "10.26 AM",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                      color: AppColors.APP_TIME),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      "20 minutes appointment",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.APP_BLACK),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15,left: 40,right: 40),
              child: Divider(
                height: 5,
                thickness: 1,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 7, bottom: 7,left: 25,right: 20),
                    margin: EdgeInsets.all(8),
                    child: CircleAvatar(
                        radius: 38.0,
                        backgroundColor: AppColors.APP_LIGHT_BLUE,
                        backgroundImage:  userImage.toString()!="null"&&userImage != ""
                            ? NetworkImage(userImage.toString())
                            : AssetImage("images/photo_avatar.png") as ImageProvider),
                  ),

                  onTap: () {

                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        "Dr. Melinda Rose,MD (O&G)",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 3,
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.APP_TEXT_NAME),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        "Cancer Institute",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 3,
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.APP_BLACK),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        "Adayar, Chennai - 20",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 3,
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.APP_BLACK),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        CallsAndMessagesService.call("98435 21693".replaceAll(' ', ''));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.phone_rounded,color: AppColors.APP_LIGHT_BLUE,size: 18,),
                          Padding(
                            padding: const EdgeInsets.only(top: 3,bottom: 5,left: 5),
                            child: Text(
                              "98435 21693",
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 3,
                              style: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.APP_BLACK),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 7, bottom: 7,left: 40,right: 40),
              child: Divider(
                height: 5,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 7, bottom: 7),
              child: Container(
                  padding: const EdgeInsets.only(
                    left: 40,
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
                    "My Tasks",
                    style:
                    TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.APP_TASK_COLOR),
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
                      color: AppColors.APP_BG_COLOR,
                      child: ListTile(

                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
                            title: index==0?'Screening Check':'Medication Instruction',
                            id: "0",

                          )),)
                              .then((val)=>getsurvey());

                        },
                        title: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(index==0?'Screening Check':'Medication Instruction', style:
                          TextStyle(fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: AppColors.APP_BLACK)
                          ),
                        ),
                        trailing:
                        Text(index==0?'65%':'10%', style:
                        TextStyle(fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: AppColors.APP_BLACK)
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
