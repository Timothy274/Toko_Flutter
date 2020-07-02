import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juljol/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
    MaterialApp(home:login())
);

class login extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return LoginRondo();
  }
}

class LoginRondo extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(43, 40, 35, 1)
      ),
        child: Stack(
          children: <Widget>[
           Center(
             child: SingleChildScrollView(
               child: Column(
                 children: <Widget>[
                   Container(
                       margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                       child: Image(
                         image: AssetImage(
                           'assets/logo.png',
                         ),
                       )
                   ),
                   Container(
                     margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                     child: TextField(
                       style: TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
                       decoration: InputDecoration(
                         enabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(color: Color.fromRGBO(187, 111, 51, 1)),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(color: Color.fromRGBO(187, 111, 51, 1)),
                         ),
                         hintText: "Username",
                         hintStyle: TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
                       ),
                     ),
                   ),
                   Divider(
                       height: 30.0),
                   Container(
                     margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                     child: TextField(
                       style: TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
                       obscureText: true,
                       decoration: InputDecoration(
                         enabledBorder: OutlineInputBorder(
                           borderSide: const BorderSide(color: Color.fromRGBO(187, 111, 51, 1)),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderSide: const BorderSide(color: Color.fromRGBO(187, 111, 51, 1)),
                         ),
                         hintText: "Password",
                         hintStyle: TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
                       ),
                     ),
                   ),
                   Container(
                       margin: const EdgeInsets.only(top: 30, bottom: 20),
                       padding: const EdgeInsets.only(left: 20, right: 20),
                       child: new SizedBox(
                           width: double.infinity,
                           child: RaisedButton(
                             color: Color.fromRGBO(187, 111, 51, 1),
                             onPressed: () {
                               Navigator.of(context).push(
                                   new MaterialPageRoute(
                                       builder: (BuildContext context)=> new GridLayoutRondo()
                                   )
                               );
                             },
                             child: const Text(
                                 'sign in',
                                 style: TextStyle(fontSize: 30)
                             ),
                           )
                       )
                   ),
                 ],
               ),
             ),
           )
          ],
        ),
      ),
    );
  }
}