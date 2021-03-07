import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'dart:async';
import 'dart:convert';

class newpegawai extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return newpegawairondo();
  }
}

class newpegawairondo extends State<newpegawai> {
  final nama = TextEditingController();
  final bonus_brg = TextEditingController();
  final bonus_abs = TextEditingController();
  void _showDialogPilihan() {
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
    if (nama.text == "" || bonus_brg.text == "" || bonus_abs.text == "") {
      _showDialogPilihan();
    } else {
      addPegawai();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new GridLayoutRondo()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void addPegawai() {
    var url = "http://timothy.buzz/juljol/addpegawai.php";
    http.post(url, body: {
      "Nama": nama.text,
      "Bonus_Barang": bonus_brg.text,
      "Bonus_Absen": bonus_abs.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffff)),
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 170.0, left: 20.0, right: 20.0),
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
                  textCapitalization: TextCapitalization.sentences,
                  controller: nama,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(labelText: "Nama Pegawai"),
                ),
                Divider(height: 50.0),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: bonus_brg,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Bonus Barang"),
                ),
                Divider(height: 50.0),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: bonus_abs,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Bonus Absensi"),
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
                          color: Color.fromRGBO(76, 177, 247, 1),
                          onPressed: () {
                            validasi();
                          },
                          child: const Text('Tambah Pegawai',
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
