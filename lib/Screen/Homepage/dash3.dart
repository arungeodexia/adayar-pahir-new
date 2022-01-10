/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'dart:convert';

import 'package:ACI/Model/appointment_details.dart';
import 'package:ACI/Model/taksmodel.dart';
import 'package:ACI/Screen/ScreenCheck.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/constants.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class DashboardThreePage extends StatefulWidget {
  static final String path = "lib/src/pages/dashboard/dash3.dart";

  @override
  State<DashboardThreePage> createState() => _DashboardThreePageState();
}

class _DashboardThreePageState extends State<DashboardThreePage> {
  final String avatar = "https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media";

  final TextStyle whiteText = TextStyle(color: Colors.white);
  String username = "";

  String userImage = "";
  bool isload = false;
  static final SurveyRepo resourceRepository = new SurveyRepo();
  Taksmodel taskmodel=Taksmodel();
  AppointmentDetails appointmentDetails=AppointmentDetails();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserName();
    getsurvey();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.APP_WHITE,
      body: isload?buildLoading():_buildBody(context),
    );
  }
  void getsurvey() async {
    isload = true;
    http.Response? response =
    await resourceRepository.getTasks();
    taskmodel = Taksmodel.fromJson(
        json.decode(utf8.decode(response!.bodyBytes)));
    http.Response? response1 = await resourceRepository.getAppointments();
    appointmentDetails = AppointmentDetails.fromJson(
        json.decode(utf8.decode(response1!.bodyBytes)));

    setState(() {
      isload = false;
    });
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


  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 20.0),

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
                      appointmentDetails.name.toString()+"  "+appointmentDetails.designation.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1,
                          color: AppColors.APP_BLUE
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      appointmentDetails.institute.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style:kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1,
                          color: AppColors.APP_BLUE
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      appointmentDetails.address.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1,
                          color: AppColors.APP_BLUE
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      CallsAndMessagesService.call(appointmentDetails.phone1.toString().replaceAll(' ', ''));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: AppColors.APP_WHITE,radius: 15,child: Icon(FontAwesomeIcons.phoneAlt,color: AppColors.APP_BLUE,size: 18,)),
                        Padding(
                          padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5),
                          child: Text(
                            appointmentDetails.phone1.toString(),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 3,
                            style: kSubtitleTextSyule1.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1,
                                color: AppColors.APP_BLUE
                            ),
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
                  "Programs",
                  style:
                  TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.APP_BLUE1),
                )),
          ),
          taskmodel.tasks!=null?ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // physics: NeverScrollableScrollPhysics(),
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: taskmodel.tasks!.length,
              itemBuilder: (BuildContext context,
                  int index) {
                return Card(
                  color: AppColors.APP_BLUE1,
                  child: ListTile(

                    onTap: (){
                      Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
                        title: taskmodel.tasks![index].taskTitle.toString(),
                        id: taskmodel.tasks![index].taskId.toString(),
                        page: "0",
                      )),)
                          .then((val)=>getsurvey());
                      globalTaskID=taskmodel.tasks![index].taskId!;
                    },
                    title: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(taskmodel.tasks![index].taskTitle.toString(), style:
                      kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white
                      ),
                      ),
                    ),
                    trailing:
                    Text(taskmodel.tasks![index].completionPercentage.toString(), style:
                    kSubtitleTextSyule1.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: Colors.white
                    ),
                    ),
                  ),
                );
              }):Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
            child: Text("You have No Programs",style: kSubtitleTextSyule1.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: AppColors.APP_GREY
            ),),

          ),
              )
        ],
      ),
    );
  }

  Container _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: AppColors.APP_BLUE1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title:  Column(
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
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white
                      ),
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
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      "10.26 am",
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white
                      ),
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
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // trailing: CircleAvatar(
            //   radius: 25.0,
            //   backgroundImage: NetworkImage(avatar),
            // ),
          ),


        ],
      ),
    );
  }

}
