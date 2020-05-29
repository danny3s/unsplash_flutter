import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:unsplash_app/var.dart';
import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dashboard.dart';
import 'data.dart';
import 'login.dart';

var username = "";
var nombres = "";
var profilepic = "";

var lst = new List(9);
var leng = 0;

class like extends StatefulWidget {
  @override
  _UnsplashState createState() => _UnsplashState();
}

class _UnsplashState extends State<like> {

  Map data;

  Future getuser() async {


    http.Response response = await http.get("https://api.unsplash.com/me?access_token=${access_token}");
    data = json.decode(response.body);




    data = json.decode(response.body);



    setState(() {
      username = data["username"];
      nombres = data["name"];
      profilepic = data["profile_image"]["medium"];

      getphotos();
    });

  }

  Map data2;
  List userData;

  Future getphotos() async {


    http.Response response = await http.get("https://api.unsplash.com/users/${username}/likes?access_token=${access_token}");
    userData = json.decode(response.body);



    leng = userData.length;


    setState(() {
      for(int i = 0 ; i < leng ; i++){
        lst[i] = userData[i]["urls"]["regular"];
      }
    });







  }





  final myController = TextEditingController();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getuser();



  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    InkWell(
                      onTap: (){

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Unsplash()),
                        );


                      },
                      child: Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.redAccent,
                      ),
                    ),




                  ],
                ),
                Container(
                  height: 150.0,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Liked Photos",
                        style:TextStyle(
                            color: Colors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Text(
                        "${nombres} , ${username}",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.0,),
                SingleChildScrollView(


                  child:  Container(
                    height: MediaQuery.of(context).size.height * .6 -10.0,
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: leng,
                      itemBuilder: (BuildContext context,int index)=>

Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: DecorationImage(
                                      image: NetworkImage("${lst[index]}"),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),



                      staggeredTileBuilder: (int index)=>
                          StaggeredTile.count(2,index.isEven ? 3 : 1.5),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 20.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),


      ),

    );
  }
}