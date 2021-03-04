import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juljol/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import './admin_page.dart';

void main() => runApp(MaterialApp(home: login()));

class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginRondo();
  }
}

class LoginRondo extends State<login> {
  bool isLogin = false;
  var userLogin;
  List<DataUser> _datauser = [];
  final username = TextEditingController();
  final password = TextEditingController();

  Future<List<DataUser>> getUser() async {
    final response = await http.get("http://timothy.buzz/juljol/get_user.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _datauser.add(DataUser.fromJson(Data));
      }
      print(_datauser.length);
    });
  }

  Future cek() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GridLayoutRondo()));
    }
  }

  void _showdialogerror() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Error Login"),
          content:
              new Text("Username / Password salah, Mohon lakukan login ulang"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void validasi() async {
    String _username = username.text;
    String _password = password.text;
    String susername = "";
    String spassword = "";

    for (int a = 0; a < _datauser.length; a++) {
      if (_datauser[a].username == _username) {
        susername = _username;
      }
      if (_datauser[a].password == _password) {
        spassword = _password;
      }
    }
    if ((susername == "") || (spassword == "")) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLogin", false);
      _showdialogerror();
    } else if ((susername == "admin") && (spassword == "root")) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLogin", true);
      pref.setString("username", susername);
      Navigator.push(context, MaterialPageRoute(builder: (context) => admin()));
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLogin", true);
      pref.setString("username", susername);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GridLayoutRondo()));
    }
  }

  void initState() {
    super.initState();
    getUser();
    cek();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(43, 40, 35, 1)),
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                        child: Image(
                          image: AssetImage(
                            'assets/logo.png',
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextField(
                        controller: username,
                        style:
                            TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(187, 111, 51, 1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(187, 111, 51, 1)),
                          ),
                          hintText: "Username",
                          hintStyle:
                              TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
                        ),
                      ),
                    ),
                    Divider(height: 30.0),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextField(
                        controller: password,
                        style:
                            TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(187, 111, 51, 1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(187, 111, 51, 1)),
                          ),
                          hintText: "Password",
                          hintStyle:
                              TextStyle(color: Color.fromRGBO(187, 111, 51, 1)),
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
                                validasi();
                              },
                              child: const Text('sign in',
                                  style: TextStyle(fontSize: 30)),
                            ))),
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

class DataUser {
  String id_user;
  String username;
  String password;
  String email;
  DataUser({
    this.id_user,
    this.username,
    this.password,
    this.email,
  });
  factory DataUser.fromJson(Map<String, dynamic> json) {
    return DataUser(
        id_user: json['id_user'],
        username: json['Username'],
        password: json['Password'],
        email: json['Email']);
  }
}
