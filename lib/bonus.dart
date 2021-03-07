import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/pegawai.dart';
import 'package:juljol/list_order.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:async';
import 'dart:convert';

class DataPegawai {
  String id_pegawai;
  String Nama;
  String Gaji;
  String Bonus_Barang;
  String Bonus_Absen;
  String Bonus_THR;

  DataPegawai({
    this.id_pegawai,
    this.Nama,
    this.Gaji,
    this.Bonus_Barang,
    this.Bonus_Absen,
    this.Bonus_THR,
  });

  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        id_pegawai: json['id_pegawai'],
        Nama: json['Nama'],
        Gaji: json['Gaji'],
        Bonus_Barang: json['Bonus_Barang'],
        Bonus_Absen: json['Bonus_Absen'],
        Bonus_THR: json['Bonus_THR']);
  }
}

class Bonus extends StatefulWidget {
  List list;
  int index;
  Bonus({this.index, this.list});
  @override
  State<StatefulWidget> createState() {
    return BonusRondo();
  }
}

class BonusRondo extends State<Bonus> {
  List<DataPegawai> _dataPegawai = [];
  List<DataPegawai> _sortDataPegawai = [];
  String Bonus_barang, Bonus_absen, Bonus_THR;
  final B_Barang = TextEditingController();
  final B_Absen = TextEditingController();
  final B_THR = TextEditingController();

  Future<List<DataPegawai>> getDataPegawai() async {
    final responseB =
        await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJsonB = json.decode(responseB.body);

    setState(() {
      for (Map Data in responseJsonB) {
        _dataPegawai.add(DataPegawai.fromJson(Data));
      }
      _dataPegawai.forEach((dataDetail) {
        if (dataDetail.id_pegawai
            .contains(widget.list[widget.index]['id_pegawai']))
          _sortDataPegawai.add(dataDetail);
      });
      var p = _sortDataPegawai.length;
      for (int i = 0; i < p; i++) {
        Bonus_barang = _sortDataPegawai[i].Bonus_Barang;
        Bonus_absen = _sortDataPegawai[i].Bonus_Absen;
        Bonus_THR = _sortDataPegawai[i].Bonus_THR;
      }
    });
  }

  void initState() {
    super.initState();
    getDataPegawai();
  }

  void eksepsi_kosong() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Data kosong"),
          content: new Text(
              "Mohon periksa kembali data apakah ada yang tidak di isi atau tidak"),
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

  void updateBonusBarang() {
    var url = "http://timothy.buzz/juljol/update_bonus_barang.php";
    http.post(url, body: {
      "id_pegawai": widget.list[widget.index]['id_pegawai'],
      "Bonus_Barang": B_Barang.text,
    });
    getDataPegawai();
  }

  void updateBonusAbsen() {
    var url = "http://timothy.buzz/juljol/update_bonus_absen.php";
    http.post(url, body: {
      "id_pegawai": widget.list[widget.index]['id_pegawai'],
      "Bonus_Absen": B_Absen.text,
    });
    getDataPegawai();
  }

  void updateBonusTHR() {
    var url = "http://timothy.buzz/juljol/update_bonus_thr.php";
    http.post(url, body: {
      "id_pegawai": widget.list[widget.index]['id_pegawai'],
      "Bonus_THR": B_THR.text,
    });
    getDataPegawai();
  }

  void dialogBonusBarang() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Update Bonus /Barang"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                controller: B_Barang,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Masukkan Bonus Terbaru',
                    hintText: 'Masukkan Angka'),
              ))
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                B_Barang.clear();
              },
            ),
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                if (B_Barang.text == "") {
                  eksepsi_kosong();
                } else {
                  updateBonusBarang();
                  B_Barang.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void dialogBonusAbsen() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Update Bonus Absen"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                controller: B_Absen,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    labelText: 'Masukkan Bonus Terbaru',
                    hintText: 'Masukkan Angka'),
                onChanged: (value) {},
              ))
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                B_Absen.clear();
              },
            ),
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                if (B_Absen.text == "") {
                  eksepsi_kosong();
                } else {
                  updateBonusAbsen();
                  B_Absen.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void dialogBonusTHR() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Update Bonus THR"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                controller: B_THR,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                    labelText: 'Masukkan Bonus THR',
                    hintText: 'Masukkan Angka'),
                onChanged: (value) {},
              ))
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                B_THR.clear();
              },
            ),
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                if (B_THR.text == "") {
                  eksepsi_kosong();
                } else {
                  updateBonusTHR();
                  B_THR.clear();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 1000,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(76, 177, 247, 1),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          )),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin:
                                const EdgeInsets.only(top: 70.0, bottom: 40.0),
                            child: Text(
                              'Bonus',
                              style: new TextStyle(fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        dialogBonusBarang();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        margin: const EdgeInsets.only(
                            top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
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
                                'Bonus /barang',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              padding: const EdgeInsets.only(left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: new Table(
                                children: [
                                  TableRow(children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                      child: Text(
                                        '${Bonus_barang}',
                                        style: new TextStyle(fontSize: 30.0),
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        dialogBonusAbsen();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        margin: const EdgeInsets.only(
                            top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
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
                                'Bonus /Absen',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              padding: const EdgeInsets.only(left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: new Table(
                                children: [
                                  TableRow(children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                      child: Text(
                                        '${Bonus_absen}',
                                        style: new TextStyle(fontSize: 30.0),
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        dialogBonusTHR();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        margin: const EdgeInsets.only(
                            top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
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
                                'Bonus THR',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              padding: const EdgeInsets.only(left: 40),
                              alignment: Alignment(-1.0, -1.0),
                              child: new Table(
                                children: [
                                  TableRow(children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                      child: Text(
                                        '${Bonus_THR}',
                                        style: new TextStyle(fontSize: 30.0),
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
