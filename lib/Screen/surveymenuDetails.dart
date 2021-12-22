import 'dart:convert';

import 'package:ACI/Model/SurveyModel.dart';
import 'package:ACI/Model/survey_details_model.dart';
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
import 'package:video_player/video_player.dart';

class SurveymenuDetails extends StatefulWidget {
  final String questionId;

  SurveymenuDetails({Key? key, required this.questionId}) : super(key: key);

  @override
  _SurveymenuDetailsState createState() => _SurveymenuDetailsState();
}

class _SurveymenuDetailsState extends State<SurveymenuDetails> {
  static final SurveyRepo resourceRepository = new SurveyRepo();
  SurveyDetailsModel surveyDetailsModel = new SurveyDetailsModel();

  bool isload = false;

  String username = "";

  String userImage = "";
  late VideoPlayerController _controller;
  int _groupValue = -1;
  int _selectedidValue = -1;
  int _selectedOptionid = -1;

  var isFullNameChangeBtnState = false;

  @override
  void initState() {
    super.initState();
    getuserName();
    getsurvey();
  }

  void getsurvey() async {
    isload = true;
    http.Response? response =
        await resourceRepository.getSurveyDetails(widget.questionId.toString());
    surveyDetailsModel = SurveyDetailsModel.fromJson(
        json.decode(utf8.decode(response!.bodyBytes)));

    if (surveyDetailsModel.question!.questionType.toString() == "video") {
      _controller = VideoPlayerController.network(
        //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
        surveyDetailsModel.question!.url.toString(),
      )..initialize().then((_) {
          _controller.play();
          _controller.setLooping(true);
          setState(() {});
        });
    }
    setState(() {
      isload = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task'),
          centerTitle: true,
          backgroundColor: AppColors.APP_BLUE,
          automaticallyImplyLeading: true,
        ),
        body: isload ? buildLoading() : survey());
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
    _controller.dispose();
  }

  Widget survey() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                                  username == null
                                      ? ""
                                      : "Hi " + username.trim(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)))
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 7,
                      right: 15,
                      bottom: 15,
                    ),
                    child: Text(
                      surveyDetailsModel.topText.toString(),
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
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 7,
                      right: 15,
                      bottom: 15,
                    ),
                    child: Text(
                      "1." + surveyDetailsModel.question!.question.toString(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  surveyDetailsModel.question!.questionType.toString() ==
                          "image"
                      ? Container(
                          decoration: BoxDecoration(
                              color: AppColors.APP_BLUE,
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: EdgeInsets.all(2),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                                surveyDetailsModel.question!.url.toString(),
                            placeholder: (context, url) => Center(
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  child: new CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                        )
                      : surveyDetailsModel.question!.questionType.toString() ==
                              "video"
                          ? Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: _controller.value.isInitialized
                                  ? SizedBox.expand(
                                      child: FittedBox(
                                        //fit: BoxFit.cover,
                                        //fit: BoxFit.fitWidth,
                                        fit: BoxFit.contain,
                                        child: SizedBox(
                                          // width: (_controller.value.size?.width - 20.0) ?? 0,
                                          //height: size.height -10.0 ?? 0,
                                          // width: (size.width - 10.0) ?? 0,

                                          height: 600,
                                          width: (_controller.value.size.width -
                                              200),
                                          child: VideoPlayer(_controller),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            )
                          : Container(),
                  surveyDetailsModel.question!.options == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            surveyDetailsModel.question!.answerType == "radio"
                                ? Center(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      height: 350.0,
                                      // width: 150,
                                      child: ListView.builder(

                                          physics: BouncingScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          itemCount: surveyDetailsModel
                                              .question!.options!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Center(
                                              child: RadioListTile(
                                                value: index,
                                                groupValue: _groupValue,
                                                title: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      width: 30,
                                                      height: 30,
                                                      fit: BoxFit.fill,
                                                      imageUrl:
                                                      surveyDetailsModel.question!.options![index].url.toString(),
                                                      placeholder: (context, url) => Center(
                                                        child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            child: new CircularProgressIndicator()),
                                                      ),
                                                      errorWidget: (context, url, error) =>
                                                      new Icon(Icons.error,size: 30,),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(
                                                      surveyDetailsModel.question!
                                                      .options![index].option!,
                                                      style: TextStyle(
                                                      fontFamily: "OpenSans",
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                // title: Center(
                                                //   child: Container(
                                                //     width: 80,
                                                //     decoration: BoxDecoration(
                                                //         color: AppColors.APP_WHITE,
                                                //         borderRadius:
                                                //             BorderRadius.circular(
                                                //                 5.0)),
                                                //     padding: EdgeInsets.all(2),
                                                //     child: CachedNetworkImage(
                                                //       height: 80,
                                                //       fit: BoxFit.fill,
                                                //       imageUrl: surveyDetailsModel
                                                //           .question!
                                                //           .options![index]
                                                //           .url
                                                //           .toString(),
                                                //       placeholder:
                                                //           (context, url) =>
                                                //               Center(
                                                //         child: Container(
                                                //             width: 100,
                                                //             height: 100,
                                                //             child:
                                                //                 new CircularProgressIndicator()),
                                                //       ),
                                                //       errorWidget: (context, url,
                                                //               error) =>
                                                //           new Icon(Icons.error),
                                                //     ),
                                                //   ),
                                                // ),
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    _groupValue = value!;
                                                    isFullNameChangeBtnState =
                                                        true;
                                                  });
                                                },
                                              ),
                                            );

                                            return Text('new');
                                          }),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                ],
              )),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: AppColors.APP_WHITE,
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                side: BorderSide(color: AppColors.APP_GREEN)),
                            color: ((isFullNameChangeBtnState))
                                ? AppColors.APP_BLUE
                                : AppColors.APP_LIGHT_GREY_20,
                            textColor: AppColors.APP_WHITE,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () async {
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "Submitted successfully",
                                  title: "Success",
                                  loopAnimation: true,
                                  onConfirmBtnTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  (widget != null) ? "SAVE" : "SAVE",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                          ))),
                  flex: 1,
                ),
              ],
            )),
          ),
        )
      ],
    );
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
