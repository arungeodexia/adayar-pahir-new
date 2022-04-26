/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'dart:convert';
import 'dart:developer';

import 'package:ACI/Model/appointment_details.dart';
import 'package:ACI/Model/taksmodel.dart';
import 'package:ACI/Screen/ScreenCheck.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/calls_messages_services.dart';
import 'package:ACI/utils/constants.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    getsurvey(true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.APP_WHITE,
      body: isload?buildLoading():_buildBody(context),
    );
  }
  void getsurvey(bool load) async {
    if(load){
      isload = load;
      setState(() {
      });
    }

    // await EasyLoading.show(status: 'Loading...',maskType: EasyLoadingMaskType.black);
    http.Response? response =
    await resourceRepository.getTasks();
    if(response!.statusCode==200){
      taskmodel = Taksmodel.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      // EasyLoading.showSuccess('Successful');
    }else{
      // EasyLoading.showError('API Exception');
    }

    http.Response? response1 = await resourceRepository.getAppointments();
    if(response1!.statusCode==200){
      appointmentDetails = AppointmentDetails.fromJson(
          json.decode(utf8.decode(response1.bodyBytes)));
    }

    log("tasks"+taskmodel.tasks.toString()+"tasks");

    setState(() {
      isload = false;
    });
  }
  Widget buildLoading() {
    return Container(
      height: MediaQuery.of(context).size.height - (AppBar().preferredSize.height),
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
          appointmentDetails.name.toString()!="null"?_buildHeaderNewUi():_buildHeaderNoAppointment(),
          // const SizedBox(height: 20.0),

          // Row(
          //   children: [
          //     GestureDetector(
          //       child: Container(
          //         padding: EdgeInsets.only(top: 7, bottom: 7,left: 25,right: 20),
          //         margin: EdgeInsets.all(8),
          //         child: CircleAvatar(
          //             radius: 38.0,
          //             backgroundColor: AppColors.APP_LIGHT_BLUE,
          //             backgroundImage:  appointmentDetails.picture.toString()!="null"&&appointmentDetails.picture != ""
          //                 ? NetworkImage(appointmentDetails.picture.toString())
          //                 : AssetImage("images/photo_avatar.png") as ImageProvider),
          //       ),
          //
          //       onTap: () {
          //
          //       },
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.name.toString()+"  "+appointmentDetails.designation.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style: kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.institute.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style:kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(3),
          //           child: Text(
          //             appointmentDetails.address.toString(),
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             maxLines: 3,
          //             style: kSubtitleTextSyule1.copyWith(
          //                 fontWeight: FontWeight.w600,
          //                 height: 1,
          //                 color: AppColors.APP_BLUE
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: (){
          //             CallsAndMessagesService.call(appointmentDetails.phone1.toString().replaceAll(' ', ''));
          //           },
          //           child: Row(
          //             children: [
          //               CircleAvatar(backgroundColor: AppColors.APP_WHITE,radius: 15,child: Icon(FontAwesomeIcons.phoneAlt,color: AppColors.APP_BLUE,size: 18,)),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5),
          //                 child: Text(
          //                   appointmentDetails.phone1.toString(),
          //                   overflow: TextOverflow.ellipsis,
          //                   softWrap: false,
          //                   maxLines: 3,
          //                   style: kSubtitleTextSyule1.copyWith(
          //                       fontWeight: FontWeight.w600,
          //                       height: 1,
          //                       color: AppColors.APP_BLUE
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          appointmentDetails.name.toString()=="null"?Container():Padding(
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
                  tr("programs"),
                  style:
                  TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.APP_BLUE1),
                )),
          ),
          taskmodel.tasks != null || taskmodel.tasks.toString()!="null" ?ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: taskmodel.tasks!.length,
              itemBuilder: (BuildContext context,
                  int index) {
                return Hero(
                  tag: taskmodel.tasks![index].taskId.toString(),
                  child: Card(
                    color: AppColors.APP_BLUE1,
                    child: ListTile(

                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new ScreenCheck(
                          title: taskmodel.tasks![index].taskTitle.toString(),
                          id: taskmodel.tasks![index].taskId.toString(),
                          page: "0",
                        )),)
                            .then((val)=>getsurvey(false));
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
                  ),
                );
              }):
          Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
            child: Text(tr("noprograms"),style: kSubtitleTextSyule1.copyWith(
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
                      appointmentDetails.appointmentType.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                        fontSize: 22
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      appointmentDetails.appointmentDateFormatted.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 18

                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      appointmentDetails.appointmentTime.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Text(
                      appointmentDetails.appointmentDuration.toString(),
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
  Container _buildHeaderNewUi() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
      margin: const EdgeInsets.all(10, ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.APP_BLUE1,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading:               GestureDetector(
          child: Container(
      child: CircleAvatar(
          radius: 30.0,
          backgroundColor: AppColors.APP_LIGHT_BLUE,
          backgroundImage:  appointmentDetails.picture.toString()!="null"&&appointmentDetails.picture != ""
              ? NetworkImage(appointmentDetails.picture.toString())
              : AssetImage("images/photo_avatar.png") as ImageProvider),
    ),

    onTap: () {

    },
    ),
            title:Text(
              appointmentDetails.name.toString(),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 3,
              style: kSubtitleTextSyule1.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  color: Colors.white,
                  fontSize: 22
              ),
            ),
            subtitle:Row(
              children: [
                Text(
                  appointmentDetails.address.toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 3,
                  style: kSubtitleTextSyule1.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Colors.white,
                      fontSize: 16
                  ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    CallsAndMessagesService.call(appointmentDetails.phone1.toString().replaceAll(' ', ''));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: CircleAvatar(backgroundColor: AppColors.APP_WHITE,radius: 10,child: Icon(FontAwesomeIcons.phoneAlt,color: AppColors.APP_BLUE,size: 12,)),
                  ),
                ),
              ],
            ),
            // trailing: CircleAvatar(
            //   radius: 25.0,
            //   backgroundImage: NetworkImage(avatar),
            // ),
          ),
          Container(

            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),

              color: AppColors.APP_WHITE.withOpacity(0.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(width: 5,),
                    Icon(Icons.timer_outlined,color: Colors.white,),
                     SizedBox(width: 10,),
                     Text(
                      appointmentDetails.appointmentTime.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 15
                      ),
                    ),
                    SizedBox(width: 20,),



                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.date_range,color: Colors.white),
                    SizedBox(width: 10,),

                    Text(
                      appointmentDetails.appointmentDateFormatted.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                          fontSize: 15
                      ),
                    ),
                    SizedBox(width: 10,),
                  ],
                )
              ],
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(left: 15),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //
          //       Padding(
          //         padding: const EdgeInsets.all(5),
          //         child: Text(
          //           appointmentDetails.institute.toString(),
          //           overflow: TextOverflow.ellipsis,
          //           softWrap: false,
          //           maxLines: 3,
          //           style:kSubtitleTextSyule1.copyWith(
          //               fontWeight: FontWeight.w600,
          //               height: 1,
          //               color: AppColors.APP_WHITE
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.all(5),
          //         child: Text(
          //           appointmentDetails.address.toString(),
          //           overflow: TextOverflow.ellipsis,
          //           softWrap: false,
          //           maxLines: 3,
          //           style: kSubtitleTextSyule1.copyWith(
          //               fontWeight: FontWeight.w600,
          //               height: 1,
          //               color: AppColors.APP_WHITE
          //           ),
          //         ),
          //       ),
          //       SizedBox(height: 5,),
          //       GestureDetector(
          //         onTap: (){
          //           CallsAndMessagesService.call(appointmentDetails.phone1.toString().replaceAll(' ', ''));
          //         },
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             CircleAvatar(backgroundColor: AppColors.APP_WHITE,radius: 15,child: Icon(FontAwesomeIcons.phoneAlt,color: AppColors.APP_BLUE,size: 18,)),
          //             Padding(
          //               padding: const EdgeInsets.only(top: 5,bottom: 5,left: 5),
          //               child: Text(
          //                 appointmentDetails.phone1.toString(),
          //                 overflow: TextOverflow.ellipsis,
          //                 softWrap: false,
          //                 maxLines: 3,
          //                 style: kSubtitleTextSyule1.copyWith(
          //                     fontWeight: FontWeight.w600,
          //                     height: 1,
          //                     color: AppColors.APP_WHITE
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

        ],
      ),
    );
  }
  Container _buildHeaderNoAppointment() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10.0, 10, 10.0),
      margin: const EdgeInsets.all(10, ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
                      tr("noappo"),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: kSubtitleTextSyule1.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          color: Colors.white,
                        fontSize: 20
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
