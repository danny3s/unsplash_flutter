import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:unsplash_app/like.dart';
import 'package:unsplash_app/var.dart';
import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data.dart';
import 'login.dart';

var username = "";
var nombres = "";
var profilepic = "";

var lst = new List(9);
var id = new List(9);

class Unsplash extends StatefulWidget {
  @override
  _UnsplashState createState() => _UnsplashState();
}

class _UnsplashState extends State<Unsplash> {

  Map data;

  Future getuser() async {


    http.Response response = await http.get("https://api.unsplash.com/me?access_token=${access_token}");
    data = json.decode(response.body);


    setState(() {
      username = data["username"];
      nombres = data["name"];
      profilepic = data["profile_image"]["medium"];

    });

  }

  Map data2;
  List userData;

  Future getphotos() async {


    http.Response response = await http.get("https://api.unsplash.com/photos/?client_id=e2658d4b6b17ae24b50a7ab36d13ca67da9761322a5e4cb0e9cc531e69cecb90&page=30");
    userData = json.decode(response.body);



    setState(() {
      for(int i = 0 ; i < 9 ; i++){
        lst[i] = userData[i]["urls"]["regular"];
        id[i] = userData[i]["id"];
      }
    });

  }



  Future searchphotos() async {


    http.Response response = await http.get("https://api.unsplash.com/search/photos?page=1&query=${myController.text}&access_token=${access_token}&page=30");

    var data = json.decode(response.body);


    data["results"][1]["urls"]["regular"];

    setState(() {
      for(int i = 0 ; i < 9 ; i++){
        lst[i] = data["results"][i]["urls"]["regular"];
        id[i] = data["results"][i]["id"];
      }
    });

  }



  final myController = TextEditingController();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getuser();
    getphotos();


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
                    Icon(Icons.menu,size: 25.0,),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => like()),
                            );


                          },
                          child: Icon(
                            FontAwesomeIcons.heart,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage("${profilepic}"),

                        ),
                      ],
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
                        "Unsplash",
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
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: 65.0,
                  child: TextFormField(
                    controller: myController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: 'Search photos',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.grey.shade50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:  BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.grey.shade50),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .6 -10.0,
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: 9,
                      itemBuilder: (BuildContext context,int index)=>


                          GestureDetector(
                            onTap: (){

                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      new SecondPage(lst[index],id[index])
                                  ));



                            },
                            child:  Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                    image: NetworkImage("${lst[index]}"),
                                    fit: BoxFit.cover
                                )
                            ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: searchphotos,
          tooltip: 'Increment',
          child: Icon(Icons.search),
        ),

      ),

    );
  }
}

class SecondPage extends StatefulWidget{
  SecondPage(this.userData,this.id);
  final userData;
  final id;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool isPressed = false;

  var color = Colors.white;
  var icono = FontAwesomeIcons.heart;

  Map data;
  List userData;



  Future<http.Response> like() async {

    var url = "https://api.unsplash.com/photos/${widget.id}/like?access_token=${access_token}";



    Map<String, dynamic> body = {

      "id": widget.id,
      "client_id": client_id,
      "client_secret": client_secret,
      "redirect_uri": redirect_uri,
      "code": code2,
      "grant_type": "authorization_code"

    };


    final response = await http.post(url,
        //body: body,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        encoding: Encoding.getByName("utf-8")
    );


    data = json.decode(response.body);



    setState(() {
      icono = FontAwesomeIcons.solidHeart;
      color = Colors.redAccent;
    });




  }

  @override
  Widget build(BuildContext context) => Scaffold(

    body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding:
              const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black,),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),

                ],
              )),
          SizedBox(height: 45.0),

          Stack(
            children: <Widget>[

              Image.network(
                widget.userData,
              ),

              Row(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                    height: 50.0,
                    width: 50.0,
                  )

                ],
              ),



                      Row(
                      children: <Widget>[
                      IconButton(
                      icon: Icon(
                        icono,
                        color: color),

                  onPressed: () {

                        like();



                  }),

              ],
              ),


            ],
          ),







//            _getEnterAmountSection()
        ],
      ),
    ),
  );
}