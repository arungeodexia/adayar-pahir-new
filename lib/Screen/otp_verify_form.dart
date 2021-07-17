import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:pahir/Bloc/login/login_bloc.dart';
import 'package:pahir/Screen/edit_profile_view.dart';
import 'package:pahir/Screen/mydashboard.dart';
import 'package:pahir/utils/values/app_colors.dart';
import 'package:pahir/utils/values/app_strings.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerifyForm extends StatefulWidget {
  final mobileNo;
  final countryCode;

  const OTPVerifyForm({
    required this.mobileNo,
    required this.countryCode,
  }) : super();

  @override
  State<OTPVerifyForm> createState() =>
      _OTPVerifyFormState(this.mobileNo, this.countryCode);
}

class _OTPVerifyFormState extends State<OTPVerifyForm> {
  String fcm_key = "";

  final _otpTokenController = TextEditingController();
  bool isOtpChangeBtnState = false;

  int pinLength = 6;
  bool hasError = false;
  bool isOtpFilled = false;
  String errorText = "";
  bool isResendOtpAllowed = false;

  FocusNode? otpFocusNode;

  int _timeRemaining = 30;
  String _timeRemainingText = "0:30";
  Timer? _timer;
  bool _currentBtnState = false;

  final countryCode = "";
  final mobileNo = "";

  _OTPVerifyFormState(mobileNo, countryCode);

  void _getTime() {
    setState(() {
      _timeRemaining == 0 ? _timeRemaining = 0 : _timeRemaining--;
      _timeRemaining == 0
          ? isResendOtpAllowed = true
          : isResendOtpAllowed = false;
      int seconds = _timeRemaining % 60;
      int minutes = (_timeRemaining / 60).floor();
      _timeRemainingText = minutes.toString() +
          ":" +
          (seconds < 10 ? "0" + seconds.toString() : seconds.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    otpFocusNode!.dispose();
    _timer!.cancel();
  }

  @override
  initState() {
    otpFocusNode = FocusNode();
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    _otpTokenController.addListener(() {
      //print("_otpTokenController value: ${_otpTokenController.text}");
      setState(() {
        if (_otpTokenController.text.length == 6 ) {
          BlocProvider.of<LoginBloc>(context).add(OTPVerify(widget.mobileNo,
              widget.countryCode, _otpTokenController.text.toString()));
          isOtpChangeBtnState = true;
          FocusScope.of(context).unfocus();

        } else {
          isOtpChangeBtnState = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_otpTokenController.text.length!=6) {
      FocusScope.of(context).requestFocus(otpFocusNode);
    }

    _onVerifyButtonPressed() {
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OTPVerifySuccess) {
          Fluttertoast.showToast(msg: "OTP Verified");
          if (state.response==1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Mydashboard()),
                  (Route<dynamic> route) => false,
            );
          }  else{
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EditProfileView()),
                  (Route<dynamic> route) => false,
            );

          }

        } else if (state is OTPVerifyFailure) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Access Token Error",
              title: "Verification Failed",
              loopAnimation: true,
              onConfirmBtnTap: (){
                Navigator.of(context).pop();
                _otpTokenController.clear();
                isOtpFilled = false;
              }
          );


        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: Text(AppStrings.APP_NAME),
                backgroundColor: Theme.of(context).primaryColorDark,
                centerTitle: true,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            backgroundColor: Theme.of(context).primaryColorDark,
            body: Container(
                child: Column(
              children: <Widget>[
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: MediaQuery.of(context).size.width),
                              decoration: BoxDecoration(
                                  color: AppColors.APP_WHITE,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            child: Icon(
                                              Icons.check,
                                            ),
                                            backgroundColor:
                                                AppColors.APP_LIGHT_BLUE_20,
                                            foregroundColor:
                                                AppColors.APP_WHITE,
                                            radius: 25,
                                          )),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            8.0, 15.0, 8.0, 8.0),
                                        child: Text(
                                          widget.countryCode +
                                              "  " +
                                              widget.mobileNo,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.APP_BLACK_10),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 8.0, 25.0, 8.0),
                                        child: Text(
                                          AppStrings.SIGNUP_OTP_ENTER_OTP_DESC +
                                              widget.countryCode +
                                              "  " +
                                              widget.mobileNo,
                                          style: TextStyle(
                                              color: AppColors.APP_BLACK_10,
                                              height: 1.5),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      PinCodeTextField(
                                        focusNode: otpFocusNode,
                                        autofocus: true,
                                        controller: _otpTokenController,
                                        hideCharacter: false,
                                        highlight: true,
                                        highlightColor: Colors.blue,
                                        defaultBorderColor: Colors.black,
                                        hasTextBorderColor: Colors.green,
                                        maxLength: pinLength,
                                        hasError: hasError,
                                        onTextChanged: (text) {
                                          setState(() {
                                            hasError = false;
                                            if (_otpTokenController
                                                    .text.length <
                                                6) {
                                              isOtpFilled = false;
                                              //errorText = "Please enter otp.";
                                              errorText =
                                                  "Please enter Access Code.";
                                            } else {
                                              isOtpFilled = true;
                                            }
                                          });
                                        },
                                        onDone: (text) {
                                          setState(() {
                                            hasError = false;
                                            isOtpFilled = true;
                                          });
                                        },
                                        pinBoxWidth: 40,
                                        pinBoxHeight: 55,
                                        wrapAlignment: WrapAlignment.center,
                                        pinBoxDecoration:
                                            ProvidedPinBoxDecoration
                                                .underlinedPinBoxDecoration,
                                        pinTextStyle: TextStyle(fontSize: 30.0),
                                        pinTextAnimatedSwitcherTransition:
                                            ProvidedPinBoxTextAnimation
                                                .scalingTransition,
                                        pinTextAnimatedSwitcherDuration:
                                            Duration(milliseconds: 300),
                                      ),
                                      Visibility(
                                        child: Text(
                                          errorText,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        visible: hasError,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          AppStrings
                                              .SIGNUP_OTP_ENTER_OTP_CHARACTERS,
                                          style: TextStyle(
                                              color:
                                                  AppColors.APP_LIGHT_GREY_20,
                                              fontWeight: FontWeight.bold),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                30.0, 15.0, 30.0, 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Tab(
                                                      icon: Icon(
                                                          Icons.messenger,
                                                          color: isResendOtpAllowed
                                                              ? AppColors
                                                                  .APP_LIGHT_BLUE
                                                              : AppColors
                                                                  .APP_LIGHT_GREY_10),
                                                    ),
                                                    SizedBox(width: 15),
                                                    Text(
                                                      AppStrings
                                                          .SIGNUP_OTP_ENTER_RESEND,
                                                      style: TextStyle(
                                                          color: isResendOtpAllowed
                                                              ? AppColors
                                                                  .APP_LIGHT_BLUE
                                                              : AppColors
                                                                  .APP_LIGHT_GREY_10,
                                                          fontSize: 16),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  '$_timeRemainingText',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            )),
                                        onTap: () {
                                          if (isResendOtpAllowed) {
                                            BlocProvider.of<LoginBloc>(context).add(
                                                Login(
                                                    widget.mobileNo,
                                                    widget.countryCode));
                                          }
                                        },
                                      ),
                                      /*GestureDetector(
                                    child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            30.0, 10.0, 30.0, 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.call,
                                                    color: isResendOtpAllowed
                                                        ? AppColors.APP_LIGHT_BLUE
                                                        : AppColors
                                                            .APP_LIGHT_GREY_10),
                                                SizedBox(width: 15),
                                                Text(
                                                  AppStrings
                                                      .SIGNUP_OTP_ENTER_CALLME,
                                                  style: TextStyle(
                                                      color: isResendOtpAllowed
                                                          ? AppColors
                                                              .APP_LIGHT_BLUE
                                                          : AppColors
                                                              .APP_LIGHT_GREY_10),
                                                )
                                              ],
                                            ),
                                            Text('$_timeRemainingText'),
                                          ],
                                        )),
                                    onTap: () {
                                      if (isResendOtpAllowed) {
                                        _resendOtp(true);
                                      }
                                    },
                                  ),*/
                                      GestureDetector(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              AppStrings
                                                  .SIGNUP_OTP_ENTER_WRONG_NUMBER,
                                              style: TextStyle(
                                                  color: AppColors.APP_BLUE,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          })
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )),
                  flex: 8,
                ),
                Flexible(
                  child: Container(
                    color: AppColors.APP_WHITE,
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: AppColors.APP_GREEN)),
//                              highlightElevation: 8.0,
//                              onHighlightChanged: (valueChanged) {
//                                setState(() => _currentBtnState = !_currentBtnState);
//
//                              },
                                    color: (isOtpChangeBtnState)
                                        ? AppColors.APP_BLUE
                                        : AppColors.APP_LIGHT_GREY_20,
                                    // color: AppColors.APP_GREEN,
                                    textColor: AppColors.APP_WHITE,
                                    padding: EdgeInsets.all(8.0),
                                    /*onPressed: state is! LoginLoading
                                            ? _onVerifyButtonPressed
                                            : null,*/
                                    onPressed: (){
                                      if (isOtpFilled) {
                                        if (state is OTPVerifyLoading) {

                                        }  else{
                                          print("clicked");
                                          BlocProvider.of<LoginBloc>(context).add(OTPVerify(widget.mobileNo,
                                              widget.countryCode, _otpTokenController.text.toString()));
                                        }

                                      } else {
                                        setState(() {
                                          hasError = true;
                                          errorText = "Pls Enter Otp";
                                        });
                                      }
                                    },
                                    child: state is OTPVerifyLoading?Container(
                                      margin: EdgeInsets.all(5),
                                      child: CircularProgressIndicator(
                                        
                                      ),
                                    ):Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                          tr('verify'),
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
                  flex: 2,
                )
              ],
            )),
          );
        },
      ),
    );
  }
}

Future<String> getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return "version:${packageInfo.version}";
}
