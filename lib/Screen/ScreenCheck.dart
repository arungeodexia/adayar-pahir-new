import 'package:ACI/Screen/surveymenuDetails.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class ScreenCheck extends StatefulWidget {
  final String title;
  ScreenCheck({Key? key, required this.title}) : super(key: key);

  @override
  _ScreenCheckState createState() {
    return _ScreenCheckState();
  }
}

class _ScreenCheckState extends State<ScreenCheck> {
  var isFullNameChangeBtnState = true;
  String formattedDate="";
  String date="";
  String month="";

  Map<String, double> dataMap = {
    "A": 65,
  };
  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];
  final colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    DateTime now = DateTime.now();
    formattedDate = DateFormat(' MMMM d ').format(now);
    month = DateFormat('kk:mm a').format(now);
    // month=DateFormat('MMMM').format(now);
    // date=DateFormat('d').format(now);

  }

  @override
  void dispose() {
    super.dispose();
  }

  getsurvey() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // this is all you need
        title: Text(widget.title),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
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
                child: Center(
                  child:  new CircularPercentIndicator(
                    radius: 150.0,
                    animation: true,
                    animationDuration: 1200,
                    lineWidth: 15.0,
                    percent: 0.65,
                    center: new Text(
                      "65%",
                      style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: AppColors.APP_LIGHT_BLUE,
                    progressColor: AppColors.APP_GREEN,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    top: 25,
                    right: 0,
                    bottom: 0,
                  ),
                  child: Text(formattedDate +" at "+month,
                      style:
                          TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w600, fontSize: 15,color: AppColors.APP_TEXT_DATETIME_COLOR)),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    top: 7,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Text(
                    "Screening Check Results exipres in 12 days",
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 3,
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,color: AppColors.APP_SCREENINGCHECK_PARAGRAPH_COLOR),
                  ),
                ),
              ),
              Divider(
                height: 5,
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.only(top: 7, bottom: 0),
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 25,
                      top: 7,
                      right: 15,
                      bottom: 0,
                    ),
                    // decoration: BoxDecoration(
                    //     color: AppColors.APP_LIGHT_BLUE,
                    //     borderRadius: BorderRadius.only(
                    //         bottomRight: Radius.circular(16.0),
                    //         topRight: Radius.circular(16.0))),
                    child: Text(
                      "About Screen Check",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.APP_BTN_COLOR),
                      textAlign: TextAlign.start,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7, bottom: 0),
                child: Container(
                    padding: const EdgeInsets.only(
                      left: 25,
                      top: 0,
                      right: 15,
                      bottom: 7,
                    ),
                    child: Text(
                      "      All patients are required to complete the screening checks till the surgery day.It is very important that you provide accurate information",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                        fontSize: 13,
                          color: AppColors.APP_TEXT_SCHRS_COLOR
                      ),
                    )),
              ),
              Container(
                // color: AppColors.APP_WHITE,
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        color: AppColors.APP_BTN_COLOR)),
                                color: ((isFullNameChangeBtnState))
                                    ? AppColors.APP_BTN_COLOR
                                    : AppColors.APP_LIGHT_GREY_20,
                                textColor: AppColors.APP_WHITE,
                                padding: EdgeInsets.all(8.0),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pushReplacement(
                                        new MaterialPageRoute(
                                            builder: (_) =>
                                                new SurveymenuDetails(
                                                  questionId: "1",
                                                )),
                                      )
                                      .then((val) => getsurvey());
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      (widget != null)
                                          ? "Continue Screening Check"
                                          : "Continue Screening Check",
                                      style: TextStyle(
                                        fontFamily: 'OpenSans',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ))),
                      flex: 1,
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
