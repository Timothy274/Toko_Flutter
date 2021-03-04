import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import './admin_page.dart';

class tambahuser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return tambahuserRondo();
  }
}

class tambahuserRondo extends State<tambahuser> {
  var usernamebaru, emailbaru;
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  List<DataUser> dataUser = [];

  void initState() {
    super.initState();
    getUser();
  }

  Future<List> getUser() async {
    final response = await http.get("http://timothy.buzz/juljol/get_user.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        dataUser.add(DataUser.fromJson(Data));
      }
    });
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

  void _showkesamaanusr() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data Sama"),
          content: new Text(
              "Mohon periksa kembali username yang anda masukkan, username yang anda masukkan sudah dipakai"),
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
    if (username.text == "" || email.text == "" || password.text == "") {
      _showdataksng();
    } else {
      for (int a = 0; a < dataUser.length; a++) {
        if (dataUser[a].username == username.text) {
          _showkesamaanusr();
        } else {
          add_user();
        }
      }
    }
  }

  void add_user() {
    var url = "http://timothy.buzz/juljol/tambah_user.php";
    http.post(url, body: {
      "username": username.text,
      "email": email.text,
      "password": password.text,
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new admin()),
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
                  controller: username,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Username"),
                ),
                Divider(height: 50.0),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Email"),
                ),
                Divider(height: 50.0),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Password"),
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
                          child: const Text('Tambah User',
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
