import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:pahir/Model/create_edit_profile_model.dart';
import 'package:pahir/Model/drawer_item.dart';
import 'package:pahir/Screen/Webview.dart';
import 'package:pahir/Screen/edit_profile_view.dart';
import 'package:pahir/Screen/help_view.dart';
import 'package:pahir/Screen/privacy_control.dart';
import 'package:pahir/data/sp/shared_keys.dart';
import 'package:pahir/utils/values/app_colors.dart';
import 'package:pahir/utils/values/app_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class IShareAppDrawer extends StatelessWidget {
  int _selectedIndex = 0;

  final userDrawerItems = [
    new DrawerItem("Home", Icons.home,
        "/mydashboard"),
    new DrawerItem("My Profile",
        Icons.account_circle, "/updateprofile"),
    /*new DrawerItem("Change Number",
        IconData(59504, fontFamily: 'MaterialIcons'), "/updatemobile"),*/
    new DrawerItem(
        "Set Privacy", Icons.settings, "/privacy"),
    new DrawerItem("Privacy & Security",
        Icons.insert_drive_file, "/mydashboard"),
    new DrawerItem(
        "Help", Icons.help, "/help"),
  ];

  final socialDrawerItems = [
    new DrawerItem("Invite a friend",
        Icons.assignment_ind, "/myresources"),

    // new DrawerItem("Share QR Code",
    //     Icons.scanner, "/qrresourcedetails"),


    // new DrawerItem(AppStrings.CONTACT_SYNC_TITLE,
    //     Icons.sync, "/contactsyncview"),
  ];

  Widget _createUserProfile() {
    return FutureBuilder(
        future: getUserDetail(),
        // The async function we wrote earlier that will be providing the data i.e vers. no
        builder: (BuildContext context, AsyncSnapshot<CreateEditProfileModel>? snapshot) {
          if (snapshot!.hasData) {
            return new UserAccountsDrawerHeader(
              accountName: new Text(
                snapshot.data!.firstName.toString(),
                style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "OpenSans"),
              ),
              accountEmail: new Text(
                snapshot.data!.email.toString(),
                style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: "OpenSans"),
              ),
              currentAccountPicture: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: const Color(0xFF778899),
                  backgroundImage: snapshot.data!.profilePicture==null?AssetImage("images/photo_avatar.png") as ImageProvider:NetworkImage(snapshot.data!.profilePicture!))

            );
          }  else{
            return Container();
          }

        });
  }

  _createDrawerItems(BuildContext context, var drawerItems) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      DrawerItem d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: d.title == "Be a Volunteer"?Image(image:AssetImage("images/volunteergrey.jpeg"),width: 20,height: 20,):new Icon(d.icon),
        // leading:  Image(image:AssetImage("images/photo_avatar.png"),width: 20,height: 20,),
        title: new Text(
          d.title!,
          style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans"),
        ),
        // selected: i == _selectedIndex,
        onTap: () {
          if (d.title == "Invite a friend")
            shareData();
          else if (d.title == "Privacy & Security"){
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebViewExample()));
          } else if (d.title == "My Profile") {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileView(edit: "edit",)));
          }   else if (d.title == "Help") {
            Navigator.pop(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HelpView()));
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => ContactsPage()));


          } else if (d.title == "Set Privacy"){
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Privacy_Control(name: "pricay",)),
            );
          }

            else
            Navigator.pop(context);

          /* if (d.title != "Invite a friend")
                Navigator.pushReplacementNamed(context, d.route);
              else if(d.title != "Privacy & Security")
                -_launchTermsURL();
              else
                shareData();*/
        },
      ));
    }
    return drawerOptions;
  }




  void handleToastMsgDialog(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.APP_BLUE,
        textColor: AppColors.APP_GREEN,
        fontSize: 16.0);
  }

  _launchTermsURL() async {
    const url =
        "https://d2c56lckh61bcl.cloudfront.net/live/CovidTermsandConditions.html";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Column(
        children: <Widget>[
          //TODO This has to come from the server
          _createUserProfile(),
          new Column(children: _createDrawerItems(context, userDrawerItems)),
          Divider(),
          new Column(children: _createDrawerItems(context, socialDrawerItems))
        ],
      ),
    );
  }

  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "version:${packageInfo.version}";
  }

  Future<CreateEditProfileModel> getUserDetail() async {
    CreateEditProfileModel createEditProfileModel;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data=prefs.getString(MOBILE_NO_VERIFIED_JSON_DATA).toString();
    createEditProfileModel=CreateEditProfileModel.fromJson(json.decode(data));
    return createEditProfileModel;
  }

  Future<String> getUserImage64() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_PROFILE_IMAGE_64) ?? "";
  }

  static Future<String?> shareData() async {
    Share.share(
        'Inviting you join the fight against Corona. Install QCare, find vacant beds, oxygen cylinders, plasma, ambulance services, and more. Stay safe, and save lives. Visit https://www.geodexia.com/QCare/ for details.',
        subject: 'QCare!');

  }

  static _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
