import 'dart:convert';

import 'package:ACI/Model/SurveyModel.dart';
import 'package:ACI/Model/survey_details_model.dart';
import 'package:ACI/Screen/ScreenCheckSuccess.dart';
import 'package:ACI/data/api/repository/SurveyRepo.dart';
import 'package:ACI/data/globals.dart';
import 'package:ACI/data/sp/shared_keys.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:ACI/utils/values/app_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chewie/chewie.dart';
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
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  int _groupValue = -1;
  int _selectedidValue = -1;
  int _selectedOptionid = -1;

  var isFullNameChangeBtnState = false;

  late Duration videoLength;
  late Duration videoPosition;
  double volume = 0.5;

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
      videoPlayerController = VideoPlayerController.network(
          surveyDetailsModel.question!.url.toString())
        ..addListener(() => setState(() {
              videoPosition = videoPlayerController.value.position;
            }))
        ..initialize().then((_) => setState(() {
              videoPlayerController.pause();
              videoPlayerController.setLooping(false);
              videoLength = videoPlayerController.value.duration;
            }));
      // await videoPlayerController.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
      );
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
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  String convertToMinutesSeconds(Duration duration) {
    final parsedMinutes = duration.inMinutes < 10
        ? '0${duration.inMinutes}'
        : duration.inMinutes.toString();

    final seconds = duration.inSeconds % 60;

    final parsedSeconds =
        seconds < 10 ? '0${seconds % 60}' : (seconds % 60).toString();
    return '$parsedMinutes:$parsedSeconds';
  }

  IconData animatedVolumeIcon(double volume) {
    if (volume == 0)
      return Icons.volume_mute;
    else if (volume < 0.5)
      return Icons.volume_down;
    else
      return Icons.volume_up;
  }

  Widget survey() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 80,
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
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     left: 0,
                  //     top: 20,
                  //     right: 0,
                  //     bottom: 10,
                  //   ),
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: <Widget>[
                  //         new CircleAvatar(
                  //             radius: 25.0,
                  //             backgroundColor: const Color(0xFF778899),
                  //             backgroundImage: userImage.toString() != "null" &&
                  //                     userImage != ""
                  //                 ? NetworkImage(userImage.toString())
                  //                 : AssetImage("images/photo_avatar.png")
                  //                     as ImageProvider),
                  //         SizedBox(width: 10),
                  //         new Expanded(
                  //             child: Text(
                  //                 username == null
                  //                     ? ""
                  //                     : "Hi " + username.trim(),
                  //                 style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 17)))
                  //       ]),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     left: 10,
                  //     top: 7,
                  //     right: 15,
                  //     bottom: 15,
                  //   ),
                  //   child: Text(
                  //     surveyDetailsModel.topText.toString(),
                  //     overflow: TextOverflow.ellipsis,
                  //     softWrap: false,
                  //     maxLines: 3,
                  //     style: TextStyle(
                  //         fontFamily: "OpenSans",
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          right: 10,
                          bottom: 5,
                        ),
                        child: Text(
                          "CANCEL",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          maxLines: 3,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.APP_LIGHT_BLUE),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width / 1.3,
                      animation: true,
                      animationDuration: 1000,
                      lineHeight: 20.0,
                      leading: new Text(""),
                      trailing: new Text(""),
                      percent: 0.45,
                      center: Text(""),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: AppColors.APP_LIGHT_BLUE,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        top: 0,
                        right: 30,
                        bottom: 10,
                      ),
                      child: Text(
                        "Screen Check Result will expires in 12 days",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 3,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
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
                              color: AppColors.APP_WHITE,
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
                              padding: EdgeInsets.all(4),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: Stack(
                                children: <Widget>[
                                  videoPlayerController.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Chewie(
                                            controller: chewieController,
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ],
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
                                      // height: 200.0,
                                      // width: 150,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                          itemCount: surveyDetailsModel
                                              .question!.options!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                isFullNameChangeBtnState = true;
                                                for (int j = 0;
                                                    j <
                                                        surveyDetailsModel
                                                            .question!
                                                            .options!
                                                            .length;
                                                    j++) {
                                                  surveyDetailsModel.question!
                                                      .options![j].selct = -1;
                                                }
                                                surveyDetailsModel.question!
                                                    .options![index].selct = 0;
                                                setState(() {});
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                      imageUrl:
                                                          surveyDetailsModel
                                                              .question!
                                                              .options![index]
                                                              .url
                                                              .toString(),
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                new CircularProgressIndicator()),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(
                                                        Icons.error,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 50,
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.8,
                                                      child: Text(
                                                        surveyDetailsModel
                                                            .question!
                                                            .options![index]
                                                            .option!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "OpenSans",
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Image.asset(
                                                      surveyDetailsModel
                                                                  .question!
                                                                  .options![
                                                                      index]
                                                                  .select ==
                                                              0
                                                          ? 'images/radioonbutton.png'
                                                          : 'images/radiobutton.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
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
                                                          surveyDetailsModel
                                                              .question!
                                                              .options![index]
                                                              .url
                                                              .toString(),
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                new CircularProgressIndicator()),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(
                                                        Icons.error,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      surveyDetailsModel
                                                          .question!
                                                          .options![index]
                                                          .option!,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "OpenSans",
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
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
                  surveyDetailsModel.question!.choices == null
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            surveyDetailsModel.question!.answerType == "choices"
                                ? Center(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            for (var i in surveyDetailsModel
                                                .question!.choices![0].options!)
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 30, top: 20),
                                                child: Text(
                                                  i.option!,
                                                  style: TextStyle(
                                                    fontFamily: "OpenSans",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 0),
                                          height: 200.0,
                                          // width: 150,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                              itemCount: surveyDetailsModel
                                                  .question!.choices!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListTile(
                                                  title: Text(
                                                      surveyDetailsModel
                                                          .question!
                                                          .choices![index]
                                                          .question
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "OpenSans",
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  trailing: Container(
                                                    width: 100,
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            surveyDetailsModel
                                                                .question!
                                                                .choices![index]
                                                                .options!
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int i) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                isFullNameChangeBtnState =
                                                                    true;
                                                                for (int j = 0;
                                                                    j <
                                                                        surveyDetailsModel
                                                                            .question!
                                                                            .choices![index]
                                                                            .options!
                                                                            .length;
                                                                    j++) {
                                                                  surveyDetailsModel
                                                                      .question!
                                                                      .choices![
                                                                          index]
                                                                      .options![
                                                                          j]
                                                                      .selct = -1;
                                                                }
                                                                surveyDetailsModel
                                                                    .question!
                                                                    .choices![
                                                                        index]
                                                                    .options![i]
                                                                    .selct = 0;
                                                              });
                                                            },
                                                            child: Column(
                                                              children: [
                                                                // Text(surveyDetailsModel.question!.choices![index].options![i].option.toString()),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                  child: Image
                                                                      .asset(
                                                                    surveyDetailsModel.question!.choices![index].options![i].select ==
                                                                            0
                                                                        ? 'images/radioonbutton.png'
                                                                        : 'images/radiobutton.png',
                                                                    width: 25,
                                                                    height: 25,
                                                                  ),
                                                                ),
                                                                // Radio(
                                                                //     value: 0,
                                                                //     groupValue: surveyDetailsModel
                                                                //         .question!
                                                                //         .choices![
                                                                //             index]
                                                                //         .options![
                                                                //             i]
                                                                //         .select,
                                                                //     onChanged:
                                                                //         (onChanged) {
                                                                //       print(surveyDetailsModel
                                                                //           .question!
                                                                //           .choices![
                                                                //               index]
                                                                //           .options!
                                                                //           .length);
                                                                //       print(i
                                                                //           .toString());
                                                                //       setState(
                                                                //           () {
                                                                //         isFullNameChangeBtnState =
                                                                //             true;
                                                                //         for (int j =
                                                                //                 0;
                                                                //             j < surveyDetailsModel.question!.choices![index].options!.length;
                                                                //             j++) {
                                                                //           surveyDetailsModel
                                                                //               .question!
                                                                //               .choices![index]
                                                                //               .options![j]
                                                                //               .selct = -1;
                                                                //         }
                                                                //         surveyDetailsModel
                                                                //             .question!
                                                                //             .choices![
                                                                //                 index]
                                                                //             .options![
                                                                //                 i]
                                                                //             .selct = 0;
                                                                //       });
                                                                //     }),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
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
                                side: BorderSide(
                                    color: AppColors.APP_LIGHT_BLUE)),
                            color: ((isFullNameChangeBtnState))
                                ? AppColors.APP_LIGHT_BLUE
                                : AppColors.APP_LIGHT_GREY_20,
                            textColor: AppColors.APP_WHITE,
                            padding: EdgeInsets.all(8.0),
                            onPressed: () async {
                              if (isFullNameChangeBtnState) {
                                Navigator.of(context)
                                    .pushReplacement(
                                      new MaterialPageRoute(
                                          builder: (_) =>
                                              new ScreenCheckSuccess()),
                                    )
                                    .then((val) => getsurvey());

                                // CoolAlert.show(
                                //     context: context,
                                //     type: CoolAlertType.success,
                                //     text: "Submitted successfully",
                                //     title: "Success",
                                //     loopAnimation: true,
                                //     onConfirmBtnTap: () {
                                //       Navigator.of(context).pop();
                                //       Navigator.of(context).pop();
                                //     });
                              }
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  (widget != null) ? "Submit" : "Submit",
                                  style: TextStyle(
                                      fontSize: 15,
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
