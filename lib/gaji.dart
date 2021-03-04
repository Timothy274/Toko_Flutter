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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rxdart/rxdart.dart';

class DataDetail {
  String Tanggal;
  String Nama;
  DataDetail({
    this.Tanggal,
    this.Nama,
  });
  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(Tanggal: json['Tanggal'], Nama: json['pengantar']);
  }
}

class Gaji extends StatefulWidget {
  List list;
  int index;
  Gaji({this.index, this.list});
  @override
  State<StatefulWidget> createState() {
    return GajiRondo();
  }
}

class GajiRondo extends State<Gaji> {
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<String> Jan = [];
  List<String> Feb = [];
  List<String> Mar = [];
  List<String> Apr = [];
  List<String> Mei = [];
  List<String> Jun = [];
  List<String> Jul = [];
  List<String> Aug = [];
  List<String> Sep = [];
  List<String> Okt = [];
  List<String> Nov = [];

  List<String> Des = [];
  var _Jan, _Feb, _Mar, _Apr, _Mei, _Jun, _Jul, _Aug, _Sep, _Okt, _Nov, _Des;
  String datenow = 'awal';
  String datelast = 'akhir';
  String gaji = '0';
  String absen = '0';
  String Test;
  Future<List<DataDetail>> getData() async {
    final response = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_detail_only_selesai.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.Nama.contains(widget.list[widget.index]['Nama']))
          _searchDetails.add(dataDetail);
      });
      var p = _searchDetails.length;
      for (int i = 0; i < p; i++) {
        var bulan = _searchDetails[i].Tanggal;
        var _bulan = bulan.substring(5, 7);
        if (_bulan == '01') {
          Jan.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '02') {
          Feb.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '03') {
          Mar.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '04') {
          Apr.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '05') {
          Mei.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '06') {
          Jun.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '07') {
          Jul.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '08') {
          Aug.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '09') {
          Sep.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '10') {
          Okt.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '11') {
          Nov.add(_searchDetails[i].Tanggal);
        } else if (_bulan == '12') {
          Des.add(_searchDetails[i].Tanggal);
        }
      }
      var _Apr = Apr.toSet().toList();
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  void past(tanggal) {
    setState(() {
      datenow = tanggal;
      if (datelast != '0') {
        if (_searchDetails.contains(datenow)) {
          print('ada');
        } else {
          print('Tidak');
        }
      }
    });
  }

  void last(tanggal) {
    setState(() {
      datelast = tanggal;
      if (datelast != '0') {
        if (_searchDetails.contains(datelast)) {
          print('ada');
        } else {
          print('Tidak');
        }
      }
    });
  }

  void sort(now, last) {}
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
                          color: Colors.orange,
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
                              'Gaji',
                              style: new TextStyle(fontSize: 30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(
                            top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    child: FlatButton(
                                  child: Text(
                                    '$datenow',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    var tahun, bulan, hari;
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 1, 1),
                                        maxTime: DateTime(2080, 6, 7),
                                        onConfirm: (tanggal) {
                                      String date = tanggal.toString();
                                      tahun = date.substring(0, 4);
                                      bulan = date.substring(5, 7);
                                      hari = date.substring(8, 10);
                                      var full =
                                          (tahun + '-' + bulan + '-' + hari);
                                      past(full);
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.id);
                                  },
                                )),
                                Container(
                                    width: 20,
                                    margin: EdgeInsets.only(right: 15),
                                    child: FlatButton(
                                      child: Text(
                                        '>',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )),
                                Container(
                                    child: FlatButton(
                                  child: Text(
                                    '$datelast',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {
                                    var tahun, bulan, hari;
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 1, 1),
                                        maxTime: DateTime(2080, 6, 7),
                                        onConfirm: (tanggal) {
                                      String date = tanggal.toString();
                                      tahun = date.substring(0, 4);
                                      bulan = date.substring(5, 7);
                                      hari = date.substring(8, 10);
                                      var full =
                                          (tahun + '-' + bulan + '-' + hari);
                                      last(full);
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.id);
                                  },
                                )),
                              ],
                            ),
                            Container(
                              alignment: Alignment(0.0, 1.0),
                              child: FlatButton(
                                child: Text('Login'),
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                onPressed: () {
                                  sort(datenow, datelast);
                                },
                              ),
                            )
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 40),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'Gaji',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
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
                                      '$gaji',
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
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 40),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'Absen',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
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
                                      '$absen',
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
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 40),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'List Gaji',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            padding: const EdgeInsets.only(left: 40),
                            alignment: Alignment(-1.0, -1.0),
                          )
                        ],
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
