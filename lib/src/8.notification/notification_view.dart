import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/color.dart';
import 'package:teacher_antoree/const/defaultValue.dart';
import 'package:teacher_antoree/const/sharedPreferences.dart';
import 'dart:io' show Platform;

import 'package:teacher_antoree/models/schedule.dart';

class NotificationView extends StatefulWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NotificationView());
  }

  @override
  NotificationUIState createState() =>NotificationUIState();
}


class NotificationUIState extends State<NotificationView>{

  Notification notifications;

  void initState() {
    super.initState();
    loadDataFromLocal();
  }


  loadDataFromLocal(){

  }

  _customeHeaderBar(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Image.asset(IMAGES.HOME_LOGO, width: 100, height: 18,),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
      child: Scaffold(
        backgroundColor: COLOR.BG_COLOR,
        appBar: AppBar(
          title:_customeHeaderBar(context),
          centerTitle: true,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: COLOR.BG_COLOR,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Image.asset(IMAGES.BACK_ICON, width: 26, height: 20,),
            onPressed: () {
              StorageUtil.removeAllCache();
              Navigator.of(context).pop('LoginView');
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 1.0,
                color: COLOR.COLOR_D8D8D8,
              ),
              Expanded(child: _notiList(context),
              )
            ],
          ),
        )
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  _notiList(BuildContext context){
    double maxHeight = MediaQuery.of(context).size.height - kToolbarHeight - 1 - (Platform.isAndroid ? kBottomNavigationBarHeight : 0) - MediaQuery.of(context).padding.bottom;

    return Container(
//      height: maxHeight,
      child: ListView.builder(
        itemBuilder: (context, int index) {
          //page = page + 1;
          return new NotificationItem(index: 0, notifications: notifications,);
        },
        itemCount: 20,
//        controller: _scrollController,
      ),
    );
  }
}


class NotificationItem extends StatelessWidget {

  NotificationItem({Key key, this.index, this.notifications}) : super(key: key);
  double heightCell = 90;
  Notification notifications;
  int index;
//  User student;

  @override
  Widget build(BuildContext context) {
    double marginLeftRight = (MediaQuery.of(context).size.width*4.8)/100;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: marginLeftRight, right: marginLeftRight),
            height: heightCell,
            color: COLOR.COLOR_FDFDFD,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _avatarImage(),
                  Expanded(child: _notificationInfor(context),
                  )
                ]
            )
        ),
        Container(
            height: 1,
            decoration: BoxDecoration(
                color: const Color(0xffd8d8d8)
            )
        )
      ],
    );
  }

  _avatarImage() {
    return Container(
      height: 50,
      width: 54,
      margin: EdgeInsets.only(top: 15),
      child:
//          student.avatar.url != null ? CachedNetworkImage(
//            imageUrl: student.avatar.url,
//            imageBuilder:
//                (context, imageProvider) =>
//                Container(
//                  decoration: _borderAvatar(imageProvider, 1),
//                ),
//            placeholder: (context, url) =>
//                Container(
//                  decoration: _borderAvatar(new AssetImage(IMAGES
//                      .HOME_AVATAR), 4),
//                ),
//            errorWidget: (context, url, error)
//            => Container(
//                decoration: _borderAvatar(new AssetImage(IMAGES
//                    .HOME_AVATAR), 4)
//            ),
//
//          ) :
      Container(
          decoration: _borderAvatar(new AssetImage(IMAGES
              .HOME_AVATAR), 4)
      ),

    );
  }

  _borderAvatar(ImageProvider image, double scale){
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      border: Border.all(width: 3.0, color: COLOR.COLOR_00C081),
      color: Colors.white,
      image: new DecorationImage(
        fit: BoxFit.none,
        image: image,
        scale: scale,
      ),
    );
  }
  _notificationInfor(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(height: 15,),
          RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                  children: [
                    TextSpan(
                        style: const TextStyle(
                          color: COLOR.COLOR_NOTI_TEXT,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                        text: 'Bảo '),
                    TextSpan(
                        style: const TextStyle(
                            color: COLOR.COLOR_NOTI_TEXT,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0
                        ),
                        text: 'đã hủy cuộc hẹn lúc 08:00 ngày 13/10/2020'),
                  ]
              )
          ),
          SizedBox(height: 15,),
          Text(
              '2 giây',
              style: const TextStyle(
                  color: const Color(0xff9caaa2),
                  fontWeight: FontWeight.w400,
                  fontFamily: "Montserrat",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0
              )
          )
        ],
      ),
    );
  }

}

