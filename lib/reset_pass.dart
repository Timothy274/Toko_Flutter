import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juljol/Detail_Order_Berjalan.dart';
import 'package:juljol/main.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:sqflite/sqflite.dart';

class ResetPass extends StatefulWidget {
  String pass;
  String username;
  ResetPass({this.pass, this.username});
  @override
  State<StatefulWidget> createState() {
    return ResetPassRondo();
  }
}

class ResetPassRondo extends State<ResetPass> {
  final passbaru = TextEditingController();
  final passlama = TextEditingController();
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
              "Mohon periksa kembali data yang anda masukkan, pastikan sudah memasukkan semua data yang dibutuhkan"),
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

  void _showpasslama() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(
              "Password yang anda masukkan berbeda, mohon masukkan ulang password lama anda"),
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

  void _showpassbaru() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(
              "Password yang anda masukkan sama dengan password yang lama, mohon masukkan ulang password baru anda"),
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
    if (passlama.text == "" && passbaru.text == "") {
      _showdataksng();
    } else {
      if (passlama.text != widget.pass) {
        _showpasslama();
      } else {
        if (passbaru.text == widget.pass) {
          _showpassbaru();
        } else {
          password_changer();
        }
      }
    }
  }

  void password_changer() {
    var url = "http://timothy.buzz/juljol/update_pass.php";
    http.post(url, body: {
      "username": widget.username,
      "password": passbaru.text,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => new GridLayoutRondo()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(43, 40, 35, 1)),
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 120.0, left: 20.0, right: 20.0),
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
            decoration: BoxDecoration(
                color: Color.fromRGBO(187, 111, 51, 1),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                )),
            child: new Form(
              child: new Column(children: <Widget>[
                TextFormField(
                  controller: passlama,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Password Lama"),
                ),
                Divider(height: 50.0),
                TextFormField(
                  controller: passbaru,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Password Baru"),
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
                          color: Color.fromRGBO(43, 40, 35, 1),
                          onPressed: () {
                            validasi();
                          },
                          child: const Text('Ubah Password',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromRGBO(187, 111, 51, 1))),
                        ))),
              ]),
            ),
          ),
        )),
      ),
    );
  }
}
