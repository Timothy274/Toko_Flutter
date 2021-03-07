import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './reset_pass.dart';
import './edit_profile.dart';
import './admin_page.dart';

class userEdit extends StatefulWidget {
  List list;
  int index;
  userEdit({this.index, this.list});
  @override
  State<StatefulWidget> createState() {
    return userEditRondo();
  }
}

class userEditRondo extends State<userEdit> {
  void initState() {
    super.initState();
  }

  void _showdialogNama() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Perhatian Hapus"),
          content: new Text(
              "Jika anda menghapus akun ini, maka peilik akun melakukan login ulang kembali"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Proses"),
              onPressed: () {
                exit();
              },
            ),
          ],
        );
      },
    );
  }

  void exit() {
    var url = "http://timothy.buzz/juljol/delete_akun.php";
    http.post(url, body: {'id_user': widget.list[widget.index]['id_user']});
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new admin()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffffff),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 100.0, left: 20.0, right: 20.0, bottom: 20.0),
                    child: Card(
                      color: Color.fromRGBO(76, 177, 247, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Icon(
                                Icons.account_circle,
                                size: 100,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 25),
                              child: Text(
                                widget.list[widget.index]['Username'],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: 500,
                      padding: const EdgeInsets.only(
                          top: 20, left: 20.0, right: 20.0),
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(76, 177, 247, 1),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(bottom: 20.0),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  'User Data',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => editProfile(
                                                username:
                                                    widget.list[widget.index]
                                                        ['Username'],
                                                email: widget.list[widget.index]
                                                    ['Email'],
                                                id: widget.list[widget.index]
                                                    ['id_user'],
                                              )));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 20.0, left: 20),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 24.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(0.6),
                                1: FlexColumnWidth(0.1),
                              },
                              children: [
                                TableRow(children: [
                                  Text(
                                    'Username',
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    ':',
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    widget.list[widget.index]['Username'],
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(
                                    'Email',
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    ':',
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    widget.list[widget.index]['Email'],
                                    style: new TextStyle(fontSize: 20.0),
                                  ),
                                ]),
                              ],
                            ),
                          )
                        ],
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(76, 177, 247, 1),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 40),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'More',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            alignment: Alignment(-1.0, -1.0),
                            child: new Table(
                              children: [
                                TableRow(children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      'Password',
                                      style: new TextStyle(fontSize: 25.0),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                      child: RaisedButton(
                                        color: Colors.lightBlueAccent,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResetPass(
                                                        pass: widget.list[widget
                                                            .index]['Password'],
                                                        username: widget.list[
                                                                widget.index]
                                                            ['Username'],
                                                      )));
                                        },
                                        child: const Text('Ubah',
                                            style: TextStyle(fontSize: 20)),
                                      ))
                                ]),
                                TableRow(children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    child: Text(
                                      'Akun',
                                      style: new TextStyle(fontSize: 25.0),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                      child: RaisedButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          _showdialogNama();
                                        },
                                        child: const Text('Hapus',
                                            style: TextStyle(fontSize: 20)),
                                      ))
                                ]),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
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
