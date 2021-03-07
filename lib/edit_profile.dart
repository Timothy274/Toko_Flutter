import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juljol/Detail_Order_Berjalan.dart';
import 'package:juljol/login.dart';
import 'package:juljol/main.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class editProfile extends StatefulWidget {
  String username;
  String email;
  String id;
  editProfile({this.username, this.email, this.id});
  @override
  State<StatefulWidget> createState() {
    return editProfileRondo();
  }
}

class editProfileRondo extends State<editProfile> {
  var usernamebaru, emailbaru;
  final username = TextEditingController();
  final email = TextEditingController();
  void initState() {
    super.initState();
  }

  void _showdataksng() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data kosong"),
          content: new Text(
              "Mohon periksa kembali data yang anda masukkan, pastikan sudah memasukkan semua datayang dibutuhkan"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
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

  void validasi() {
    if (username.text == "" && email.text == "") {
      _showdataksng();
    } else {
      if (username.text == "" && email.text != "") {
        usernamebaru = widget.username;
        emailbaru = email.text;
        password_changer(usernamebaru, emailbaru);
      } else if (username.text != "" && email.text == "") {
        usernamebaru = username.text;
        emailbaru = widget.email;
        password_changer(usernamebaru, emailbaru);
      }
    }
  }

  void password_changer(usernamebaru, emailbaru) {
    var url = "http://timothy.buzz/juljol/edit_profil.php";
    http.post(url, body: {
      "id": widget.id,
      "username": usernamebaru,
      "email": emailbaru,
    });
    exit();
  }

  Future exit() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new login()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffff)),
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 120.0, left: 20.0, right: 20.0),
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
            decoration: BoxDecoration(
                color: Color.fromRGBO(76, 177, 247, 1),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                )),
            child: new Form(
              child: new Column(children: <Widget>[
                TextFormField(
                  controller: username,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Username Baru"),
                ),
                Divider(height: 50.0),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Email Baru"),
                ),
                Divider(height: 50.0),
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    alignment: Alignment(-1.0, -1.0),
                    child: new SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.lightBlueAccent,
                          onPressed: () {
                            validasi();
                          },
                          child: const Text('Ubah Profil',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                        ))),
              ]),
            ),
          ),
        )),
      ),
    );
  }
}
