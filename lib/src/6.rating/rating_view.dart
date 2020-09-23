
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connect_api/connection/model/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:teacher_antoree/const/color.dart';
import 'package:teacher_antoree/const/defaultValue.dart';
import 'package:teacher_antoree/src/0.connection/api_connection.dart';
import 'package:teacher_antoree/src/customViews/route_names.dart';

class RatingView extends StatelessWidget {
  final String idSchedule;
  const RatingView(this.idSchedule);
  static Route route(String idSchedule) {
    return MaterialPageRoute<void>(builder: (_) => RatingView(idSchedule));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: BlocProvider(
            create: (context){
              return APIConnect();
            },
            child: RatingUI(this.idSchedule),
          )
      ),
    );
  }
}

class RatingUI extends StatefulWidget {
  final String idSchedule;
  const RatingUI(this.idSchedule);

  @override
  RatingUIState createState() => RatingUIState(this.idSchedule);
}

class RatingUIState extends State<RatingUI>{

  double ratingNumber = 1;
  String idSchedule;
  RatingUIState(this.idSchedule);


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<APIConnect, ApiState>(
        listener: (context, state){
          if (state.result is StateInit) {

          }else if (state.result is LoadingState) {

          }else if (state.result is ParseJsonToObject) {

            Navigator.popUntil(context, ModalRoute.withName(HomeViewRoute));
          }else {

            ErrorState error = state.result;
            showAlertDialog(context: context,title: STRINGS.ERROR_TITLE,message: error.msg, actions: [AlertDialogAction(isDefaultAction: true,label: 'OK')],actionsOverflowDirection: VerticalDirection.up);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(padding: EdgeInsets.all(40)),
              _topImage(),
              SizedBox(height: 20),
              _textSection(),
              SizedBox(height: 40),
              _textSecondSection(),
              SizedBox(height: 20,),
              _rating(),
              SizedBox(height: 10),
              _okButton(),
            ],
          ),
        )
    );
  }

  _topImage() {
    return Center(
      child: Container(
          alignment: Alignment.center,
          child: Image.asset(IMAGES.RATING_TOPIMAGE, width: 255, height: 241,)
      ),
    );
  }

  _textSection() {
    return Center(
      child: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    style: const TextStyle(
                        color:  const Color(0xff00c081),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 18.0
                    ),
                    text: "Congratulation."),
                TextSpan(
                    style: const TextStyle(
                        color:  const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontStyle:  FontStyle.normal,
                        fontSize: 18.0
                    ),
                    text: "....")
              ]
          )
      ),
    );
  }

  _textSecondSection() {
    return Center(
      child: Text(
          "How do you feel about this test?",
          style: const TextStyle(
              color:  const Color(0xff2b3832),
              fontWeight: FontWeight.w400,
              fontFamily: "Montserrat",
              fontStyle:  FontStyle.normal,
              fontSize: 18.0
          )
      ),
    );
  }

  _rating(){
    return Center(
      child: RatingBar(
        initialRating: 1,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 45.0,
        itemPadding: EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: COLOR.COLOR_00C081,
        ),
        onRatingUpdate: (rating) {
          print(rating);
          setState(() {
            ratingNumber = rating;
          });
        },
      ),
    );
  }

  _okButton(){
    return new GestureDetector(
      onTap: ()=>
      {
        context.bloc<APIConnect>().add(Rating(this.idSchedule, ratingNumber.toInt(), "" )),

      },
      child: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
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
        child: Text("Gặp nhau sau nhé ^-^",
          style: TextStyle(
              color: const Color(0xffffffff),
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }

}