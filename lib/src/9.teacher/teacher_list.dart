import 'dart:async';

import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_antoree/const/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class Item {
  const Item(this.name,this.cost);
  final String name;
  final String cost;
}

class TeacherListView extends StatelessWidget {

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => TeacherListView());
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
            title:_customeHeaderBar(),
            leading: addLeadingIcon(context),
            centerTitle: true,
            backgroundColor: const Color(0xffffffff)
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: TeacherListUI(),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  addLeadingIcon(BuildContext context){
    return new Container(
      height: 30.0,
      width: 26.0,
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Image.asset(
            IMAGES.HOME_LOGOUT,
            width: 30.0,
            height: 26.0,
          ),
          new FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              }
          )
        ],
      ),
    );
  }
  _customeHeaderBar() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Image.asset(IMAGES.HOME_LOGO, width: 100, height: 18,),
            ),
          ),
          GestureDetector(
              child: Image.asset(IMAGES.HOME_NOTI_OFF, width: 41, height: 35,)
          ),
        ],
      ),
    );
  }
}

class TeacherListUI extends StatefulWidget {
  @override
  TeacherListUIState createState() => TeacherListUIState();
}

class TeacherListUIState extends State<TeacherListUI>{

  bool _isLoading = false;
  APIConnect _apiConnect = APIConnect();
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  int totalItems = 10;
  bool _isShowingDropList = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _apiConnect.init();
    listenConnectionResponse();

  }

  void listenConnectionResponse(){
    _apiConnect.hasConnectionResponse().listen((Result result) {
      if (result is LoadingState) {
        showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: result.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);

      } else if (result is SuccessState) {

        //Navigator.push(context, ProfilePage.route());
      } else {

        ErrorState error = result;
        showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: error.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _filterView(),
        Stack(
          children: [
             _teacherList(context),
            _isShowingDropList ? _filterList() : _space()
          ],
        )
      ],
    );
  }

  List<Item> users = <Item>[
    const Item('Tất cả', ''),
    const Item('Giáo viên Việt Nam','250.000vnđ/giờ'),
    const Item('Giáo viên Philipines','250.000vnđ/giờ'),
    const Item('Giáo viên Premium','450.000vnđ/giờ'),
    const Item('Giáo viên Native','600.000vnđ/giờ'),
  ];

  _filterView(){
    return Center(
      child: GestureDetector(onTap: ()=>
      {
        setState(() {
            _isShowingDropList = !_isShowingDropList;
        }),
      },
          child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15,),
              child: Column(
                children: [
                  Container(
                    height: 48,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Expanded(child: Text(
                            users[selectedIndex].name,
                            style: const TextStyle(
                                color:  const Color(0xff4B5B53),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            )
                        )),
                        selectedIndex == 0 ?
                        (_isShowingDropList ? Image.asset(IMAGES.ARROW_UP, width: 12.0, height: 6.0,) : Image.asset(IMAGES.ARROW_DOWN, width: 12.0, height: 6.0,))
                            :
                        Text(
                            users[selectedIndex].cost,
                            style: const TextStyle(
                                color:  const Color(0xff4B5B53),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Montserrat",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      height: 2,
                      decoration: BoxDecoration(
                          color: const Color(0xffd8d8d8)
                      )
                  ),
                ],
              )
          )
      ),
    );
  }

  _filterList(){
    return GestureDetector(
      onTap: ()=>
        {
          setState(() {
            _isShowingDropList = !_isShowingDropList;
          }),
        },
          child: Container(
            color: const Color(0xffd8d8d8).withOpacity(0.9),
            height:  MediaQuery.of(context).size.height - kToolbarHeight - 25 - kBottomNavigationBarHeight,
            child: ListView.builder(
              itemBuilder: (context, int index) {
                //page = page + 1;
                return _filterItem(index);
              },
              itemCount: users.length,
//      controller: _scrollController,
            ),
          )
    );
  }

  Color itemColor = Colors.white;
  int selectedIndex = 0;

  _filterItem(int index){
    return Center(
      child: GestureDetector(onTap: ()=>
      {
        setState(() {
          itemColor = COLOR.COLOR_00C081;
          selectedIndex = index;
        }),
        Timer(Duration(seconds: 1), () {
          setState(() {
            itemColor = Colors.white;
            _isShowingDropList = false;
          });
        }),
      },
          child: (index == users.length - 1) ?
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),),
                color: selectedIndex != index ? Colors.white : itemColor,
              ),
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15,),
              child: _filterRow(index,)
          ) :
          Container(
            color: selectedIndex != index ? Colors.white : itemColor,
              height: 50,
              padding: EdgeInsets.only(left: 15, right: 15,),
              child: _filterRow(index,)
          )
      ),
    );
  }

  _filterRow(int index){
    return Column(
      children: [
        Container(
          height: 48,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(child: Text(
                  users[index].name,
                  style: const TextStyle(
                      color:  const Color(0xff4B5B53),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  )
              )),
              Text(
                  users[index].cost,
                  style: const TextStyle(
                      color:  const Color(0xff4B5B53),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  )
              )
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            height: 1,
            decoration: BoxDecoration(
                color: const Color(0xffe5e5e5)
            )
        ),
      ],
    );
  }

  _teacherList(BuildContext context){
    double maxHeight = MediaQuery.of(context).size.height - kToolbarHeight - 25 - kBottomNavigationBarHeight;

    return Container(
      height: maxHeight,
      child: ListView.builder(
        itemBuilder: (context, int index) {
          //page = page + 1;
          return new TeacherItem();
        },
        itemCount: 30,
      controller: _scrollController,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      //_courseBloc.add(CourseFetched("stared_at",page,1,0,""));
    }
  }

  _space(){
    return Container(
      alignment: Alignment.center,
      child: Center(

      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}


class TeacherItem extends StatelessWidget {

  TeacherItem({Key key}) : super(key: key);
  double heightCell = (25 + 78 + 10 + 180).toDouble();
  double widthCell = 0;
  @override
  Widget build(BuildContext context) {
    widthCell = MediaQuery.of(context).size.width - 20 - 120;
    return Column(
      children: [
        Container(
          height: heightCell,
            color: Colors.white,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25,),
                        _avatarImage(),
                        SizedBox(height: 10,),
                        _rating(),
                      ],
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _teacherInfor(context),
                    ],
                  ),
                ]
            )
        ),
        Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            height: 1,
            decoration: BoxDecoration(
                color: const Color(0xffd8d8d8)
            )
        )
      ],
    );
  }

  _avatarImage() {
    return Center(
        child: Container(
          height: 78,
          width: 86,
          margin: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              border: Border.all(width: 3.0, color: COLOR.COLOR_00C081),
              color: COLOR.COLOR_D8D8D8,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      "https://www.woolha.com/media/2020/03/eevee.png")
              )
          ),
        )
    );
  }

  _rating(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                  "Ratting",
                  style: const TextStyle(
                      color:  const Color(0xff4B5B53),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Montserrat",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  )
              ),
            ),
            SizedBox(height: 55,),
            Container(
                margin: EdgeInsets.only(right: 0),

                child: Text(
                    "4.5",
                    style: const TextStyle(
                        color:  const Color(0xff00c081),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 13.0
                    )
                )
            ),
          ],
        ),
        Container(
            margin: EdgeInsets.only(left: 10),
            width: 4, height: 90,
            child: Container(
                width: 4, height: 70,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(21)
                    ),
                    color: COLOR.COLOR_00C081
                )
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(21)
                ),
                color: const Color(0xffd8d8d8)
            )
        ),
      ],
    );
  }

  _teacherInfor(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35,),
          Text(
              "Kathryn Castillo",
              style: const TextStyle(
                  color:  const Color(0xff00c081),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontStyle:  FontStyle.normal,
                  fontSize: 18.0
              )
          ),
          SizedBox(height: 10,),
          _detail(),
          SizedBox(height: 20,),
         Container(width: widthCell, child: _bottomButton(context),)
        ],
      ),
    );
  }

  _detail(){
    return Container(
      width: widthCell,
      child: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    style: const TextStyle(
                        color:  const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    ),
                    text: "Nationality Philippines\n"),
                TextSpan(
                    style: const TextStyle(
                        color:  const Color(0xff4B5B53),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    ),
                    text: "I had classes with students from a beginner to an advanced level. *English Pronunciation and English Grammar*"),
                TextSpan(

                    text: "\n\n"),
                TextSpan(
                    style: const TextStyle(
                        color:  const Color(0xff4B5B53),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    ),
                    text: " *English Pronunciation and English Grammar*"),
              ]
          )
      ),
    );
  }

  _bottomButton(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

      Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        new GestureDetector(
          onTap: () {
            _launchURL;
          },
          child: Container(
            width: 86,
            alignment: Alignment.center,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(5),
              ),
              color: COLOR.COLOR_00C081,
            ),
            child: Image.asset(
              IMAGES.ICON_SQUARE,
              width: 24.0,
              height: 24.0,
            )
          ),
        ),
        SizedBox(width: 10,),
        new GestureDetector(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName(HomeViewRoute));
          },
          child: Container(
            width: 86,
            alignment: Alignment.center,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(5),
              ),
              color: COLOR.COLOR_00C081,
            ),
            child: Text(
                "Chọn",
                style: const TextStyle(
                    color:  const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Montserrat",
                    fontStyle:  FontStyle.normal,
                    fontSize: 18.0
                )
            ),
          ),
        ),
      ],
    ),
      ],
    );
  }

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}