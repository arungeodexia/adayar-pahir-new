import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pahir/Screen/myhomepage.dart';
import 'package:pahir/data/globals.dart';
import 'package:pahir/unreadchat/chatlist.dart';
import 'package:pahir/utils/Drawer.dart';
import 'package:pahir/utils/values/app_colors.dart';

import 'add_resorce.dart';
import 'favourites_page.dart';

class Mydashboard extends StatefulWidget {
  Mydashboard({Key? key}) : super(key: key);

  @override
  _MydashboardState createState() => _MydashboardState();
}
class AppPropertiesBloc {
  StreamController<String> _title = StreamController<String>();
  StreamController<String> _chats = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  Stream<String> get chatStream => _chats.stream;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  updateChat(String newTitle) {
    _chats.sink.add(newTitle);
  }

  dispose() {
    _title.close();
    _chats.close();
  }
}

class _MydashboardState extends State<Mydashboard> {
  int _currentIndex = 0;

  final appBloc = AppPropertiesBloc();


  var list;
  String unreads = '';
  String _message = '';

  late DateTime currentBackPressTime;
  void onTabTapped(int index) {
    if (index == 0)
      appBloc.updateTitle('Home');
    else if (index == 1)
      appBloc.updateTitle('Favourites');
    else if (index == 2)
      appBloc.updateTitle('Chat');
    else if (index == 3) appBloc.updateTitle('Info');
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Object>(
            stream: appBloc.titleStream,
            initialData: "Home",
            builder: (context, snapshot) {
              return Text(snapshot.data.toString());
            }),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            child: Padding(
                padding: EdgeInsets.only(right: 18),
                child: CircleAvatar(
                  child: Icon(
                    Icons.notifications
                  ),
                  radius: 12,
                  backgroundColor: AppColors.APP_LIGHT_BLUE_30,
                  foregroundColor: AppColors.APP_BLUE,
                )
            ),
            onTap: () {
            },
          ),
          GestureDetector(
            child: Padding(
                padding: EdgeInsets.only(right: 13),
                child: CircleAvatar(
                  child: Icon(
                    Icons.add,
                    size: 18,
                  ),
                  radius: 12,
                  backgroundColor: AppColors.APP_LIGHT_BLUE_30,
                  foregroundColor: AppColors.APP_BLUE,
                )),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AddResorce()),(Route<dynamic> route) => false,);
            },
          )
        ],
      ),

      drawer: IShareAppDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home_outlined, color: AppColors.APP_LIGHT_GREY,),
              activeIcon: new Icon(Icons.home, color: AppColors.APP_BLUE,),
              title: new Text('Home',style: TextStyle(color: AppColors.APP_BLUE),),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.favorite_border,color: AppColors.APP_LIGHT_GREY,),
              activeIcon: new Icon(Icons.favorite,color: AppColors.APP_BLUE,),
              title: new Text('Favourites',style: TextStyle(color: AppColors.APP_BLUE)),
            ),

            BottomNavigationBarItem(
              icon: new Icon(Icons.chat_bubble_outline, color: AppColors.APP_LIGHT_GREY,),
              activeIcon: new Icon(Icons.chat_bubble, color: AppColors.APP_BLUE,),
              title: new Text('Chat',style: TextStyle(color: AppColors.APP_BLUE)),
            )
          ],
        ),
        body: SafeArea(child: _children[_currentIndex]),
    );

  }
  final List<Widget> _children = [
    Myhomepage(),
    FavouritesPage(),
    ChatList(globalPhoneNo, 'name'),

  ];
}