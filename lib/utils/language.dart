import 'package:ACI/Screen/login_init_view.dart';
import 'package:ACI/Screen/mydashboard.dart';
import 'package:ACI/utils/background.dart';
import 'package:ACI/utils/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Language extends StatefulWidget {
  final String from;
  Language({Key? key, required this.from}) : super(key: key);

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  bool language=true;


  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 0), () {

      String lang = context.locale.languageCode;
      if(lang=="en"){
        language=true;
      }else{
        language=false;
      }
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Mydashboard()),
              (Route<dynamic> route) => false,
        );
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: widget.from=="0"?AppBar(
            centerTitle: true,
            title: Text(tr("language")),
          ):null,
          body: Background(
            child: Stack(
              children: [
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   child: Image.asset(
                //     "assets/images/wear_mask.png",
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(bottom: 10),
                //   child: Align(
                //     alignment: Alignment.bottomLeft,
                //     child: Image.asset(
                //       "images/logo.png",
                //     ),
                //   ),
                // ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CupertinoButton(
                      onPressed: () => {},
                      borderRadius: new BorderRadius.circular(30.0),
                      child: new Text(
                        tr("lang"),
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: AppColors.APP_BLUE),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(height: 5,thickness: 1,),

                        CheckboxListTile(value: language, onChanged: (val)async {
                          language=true;
                          setState(() {
                          });
                          await context.setLocale(Locale('en'));
                        },
                          title:  Text('English',style: TextStyle(color: AppColors.APP_BLUE),),),
                        Divider(height: 5,thickness: 1,),
                        CheckboxListTile(value: !language, onChanged: (val)async {
                          language=false;
                          setState(() {

                          });

                          await context.setLocale(Locale('ta'));
                        },
                          title:  Text('தமிழ்',style: TextStyle(color: AppColors.APP_BLUE),),),
                        Divider(height: 5,thickness: 1,),

                      ],
                    ),
                  ),
                ),

                // Center(
                //   child: Column(
                //     children: [
                //       CupertinoButton(
                //         onPressed: () async{
                //               await context.setLocale(Locale('en'));
                //         },
                //         child:  Center(
                //           child: Text('English',style: TextStyle(color: AppColors.APP_BLUE),),
                //         ),
                //       ),
                //       CupertinoButton(
                //         onPressed: () async{
                //               await context.setLocale(Locale('ta'));
                //         },
                //         child:  Center(
                //           child: Text('Arabic',style: TextStyle(color: AppColors.APP_BLUE),),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                widget.from=="0"?Container():Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 30),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: new CupertinoButton(

                      onPressed: ()  {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginInitView()),
                        );

                      },
                      color: AppColors.APP_BLUE,
                      borderRadius: new BorderRadius.circular(10.0),
                      child: new Text(
                        tr("getstarted"),
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
