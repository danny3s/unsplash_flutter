

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:unsplash_app/token.dart';
import 'package:unsplash_app/var.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:html/parser.dart';

String tokenchange = "GET TOKEN";



class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>

    with TickerProviderStateMixin {




  int _state_signup = 0;
  Animation _animation_signup;
  AnimationController _controller_signup;
  GlobalKey _globalKey_signup = new GlobalKey();
  double _width_signup = double.maxFinite;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();


  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();



  TextEditingController email_reg = new TextEditingController();
  TextEditingController pass1_reg = new TextEditingController();





  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;



  Map data2;
  List userData2;


  Map data;
  List userData;

  Future makeRequest() async {


    var url = 'https://unsplash.com/oauth/authorize?client_id=${client_id}&redirect_uri=${redirect_uri}&response_type=code&scope=${scope}&username=${email_reg.text}&password=${pass1_reg.text}';
    if (await canLaunch(url)) {
      await launch(url);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage2()),
      );
    } else {
      throw 'Could not launch $url';
    }





  }




  @override
  Widget build(BuildContext context) {


    MediaQueryData deviceInfo = MediaQuery.of(context);

    print('size: ${deviceInfo.size}');

    var espacio = 0.0;

    if(MediaQuery.of(context).size.height >= 775.0){
      espacio = MediaQuery.of(context).size.height/9;
    }
    else{
      espacio = MediaQuery.of(context).size.height/15;
    }

    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.png"), fit: BoxFit.fill)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FlareActor(
                    "assets/stars.flr",
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    animation: "success",
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.only(top: espacio),

                      ),

                      Container(
                        height: 200.0,
                        width: 200.0,

                        child: FlareActor(
                          "assets/logof2.flr",
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          animation: "logo",
                        ),
                      ),


                      Expanded(

                        child: PageView(
                          children: <Widget>[

                            new ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: _buildSignUp(context),
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ],

              ),
            ),

          ),
        ),
      ),
    );
  }


  // SIGNUP BUTTON ---------------------------------------------------------
  setUpButtonChildsignup() {
    if (_state_signup == 0) {
      return Text(
        "${tokenchange}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state_signup == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (_state_signup == 3) {
      return Icon(Icons.error, color: Colors.white);
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  Future animateButtonsignup() async {
    double initialWidth = _globalKey_signup.currentContext.size.width;

    _controller_signup =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation_signup = Tween(begin: 0.0, end: 1).animate(_controller_signup)
      ..addListener(() {
        setState(() {
          _width_signup = initialWidth - ((initialWidth - 48) * _animation_signup.value);
        });
      });
    _controller_signup.forward();

    setState(() {
      _state_signup = 1;
    });




    if( email_reg.text == "" || pass1_reg.text == "" ){

      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _state_signup = 3;
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Complete all fields to Continue',style: TextStyle(color: Colors.redAccent),),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.white,

              ));
        });
      });
      Timer(Duration(milliseconds: 150), () {
        setState(() {
          _state_signup = 0;
          _controller_signup.reset();
        });
      });

    }

    else if( email_reg.text.contains('@') == false){

      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _state_signup = 3;
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("Input a valid Email",style: TextStyle(color: Colors.redAccent),),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.white,

              ));
        });
      });
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          _state_signup = 0;
          _controller_signup.reset();
        });
      });

    }

    else{


      makeRequest();
      Timer(Duration(milliseconds: 15000), () {
        setState(() {
          _state_signup = 0;
          _controller_signup.reset();
        });
      });


    }






  }


  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    _pageController?.dispose();
    super.dispose();
  }




  @override
  void initState() {



    if(signupEmailController.text == "" || signupPasswordController.text == "" ){
      _state_signup = 0;
    }

    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }





  /////////////////////////////////////////REGISTER/////////////////

  Widget _buildSignUp(BuildContext context) {



    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 240.0,
                  child: Column(
                    children: <Widget>[


                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(

                          controller: email_reg,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 15.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 14.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: pass1_reg,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 15.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 14.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                FontAwesomeIcons.eye,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 20,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: PhysicalModel(
                            elevation: 8,
                            shadowColor: Colors.redAccent,
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              key: _globalKey_signup,
                              height: 48,
                              width: _width_signup,
                              child: RaisedButton(
                                animationDuration: Duration(milliseconds: 1000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.all(0),
                                child: setUpButtonChildsignup(),
                                onPressed: () {
                                  setState(() {

                                    /*
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Sliderreg()),
                                    );
                                   */




                                    if (_state_signup == 0) {
                                      animateButtonsignup();
                                    }





                                  });
                                },
                                elevation: 4,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),












                    ],
                  ),
                ),

              ),


            ],
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }



  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}
