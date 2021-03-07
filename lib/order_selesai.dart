import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/order.dart';
import './detail.dart';
import './order_detail_selesai.dart';
import 'dart:async';
import 'dart:convert';

class order_selesai extends StatefulWidget {
  String month;
  order_selesai({this.month});
  @override
  State<StatefulWidget> createState() {
    return order_selesaiRondo();
  }
}

class order_selesaiRondo extends State<order_selesai> {
  List _selectedId = List();
  List _selectedPekerja = List();
  List _selectedIdPekerja = List();
  String _mySelection1 = "Eko";
  String _mySelection2;
  List _pekerja = List();
  List<DataSaw> _dataDetails = [];
  List<DataSaw> _searchDetails = [];
  String bulan = '00';
  String namaBulan = 'Bulan';
  TextEditingController controller = new TextEditingController();
  String filter;
  void initState() {
    super.initState();
    getData();
    getSWData();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  Future<String> getSWData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_list_pegawai.php");
    final responseJson = json.decode(response.body);
    setState(() {
      _pekerja = responseJson;
    });
  }

  Future<List> getData() async {
    final response = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_detail_join_pemesanan.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataSaw.fromJson(Data));
      }
      _dataDetails.forEach((a) {
        var tanggal = a.Tanggal;
        var _bulan = tanggal.substring(5, 7);
        if (widget.month == 'Jan') {
          bulan = '01';
          namaBulan = 'Januari';
        } else if (widget.month == 'Feb') {
          bulan = '02';
          namaBulan = 'Febuari';
        } else if (widget.month == 'Mar') {
          bulan = '03';
          namaBulan = 'Maret';
        } else if (widget.month == 'Apr') {
          bulan = '04';
          namaBulan = 'April';
        } else if (widget.month == 'Mei') {
          bulan = '05';
          namaBulan = 'Mei';
        } else if (widget.month == 'Jun') {
          bulan = '06';
          namaBulan = 'Juni';
        } else if (widget.month == 'Jul') {
          bulan = '07';
          namaBulan = 'Juli';
        } else if (widget.month == 'Aug') {
          bulan = '08';
          namaBulan = 'Agustus';
        } else if (widget.month == 'Sep') {
          bulan = '09';
          namaBulan = 'September';
        } else if (widget.month == 'Okt') {
          bulan = '10';
          namaBulan = 'Oktober';
        } else if (widget.month == 'Nov') {
          bulan = '11';
          namaBulan = 'November';
        } else if (widget.month == 'Des') {
          bulan = '12';
          namaBulan = 'Desember';
        }
        if (_bulan == bulan) {
          _searchDetails.add(a);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          decoration: BoxDecoration(color: Color(0xffffff)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                padding: EdgeInsets.only(bottom: 20, top: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(76, 177, 247, 1),
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 40.0, right: 40.0, bottom: 20),
                        child: Text('List Order $namaBulan',
                            style: TextStyle(fontSize: 40))),
                    new Container(
                      width: 270.0,
                      child: DropdownButton<String>(
                        items: _pekerja.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['Nama'],
                            child: Text(item['Nama']),
                          );
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          setState(() {
                            this._mySelection2 = newValueSelected;
                          });
                        },
                        hint: Text('Pegawai'),
                        value: _mySelection2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 30),
                      margin: const EdgeInsets.only(
                          top: 20, left: 10.0, right: 10.0),
                      child: new ListView.builder(
                        itemCount: _searchDetails.length,
                        itemBuilder: (context, i) {
                          return (_mySelection2 == null ||
                                  _mySelection2 == 'Semua')
                              ? new Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new detail_order_selesai(
                                                  id_pemesanan:
                                                      _searchDetails[i]
                                                          .id_pemesanan,
                                                  alamat:
                                                      _searchDetails[i].ALamat,
                                                  tanggal:
                                                      _searchDetails[i].Tanggal,
                                                  pegawai: _searchDetails[i]
                                                      .pengantar,
                                                ))),
                                    child: new Card(
                                        child: Container(
                                      color: Colors.lightBlueAccent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: new ListTile(
                                              title: new Text(
                                                _searchDetails[i].ALamat,
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: Colors.black),
                                              ),
                                              subtitle: new Text(
                                                "Pengantar : ${_searchDetails[i].pengantar}",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                )
                              : (_searchDetails[i].pengantar == _mySelection2)
                                  ? new Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: new GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    new detail_order_selesai(
                                                      id_pemesanan:
                                                          _searchDetails[i]
                                                              .id_pemesanan,
                                                      alamat: _searchDetails[i]
                                                          .ALamat,
                                                      tanggal: _searchDetails[i]
                                                          .Tanggal,
                                                    ))),
                                        child: new Card(
                                            child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: new ListTile(
                                                  title: new Text(
                                                    _searchDetails[i].ALamat,
                                                    style: TextStyle(
                                                        fontSize: 25.0,
                                                        color: Colors.black),
                                                  ),
                                                  subtitle: new Text(
                                                    "Pengantar : ${_searchDetails[i].pengantar}",
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                      ),
                                    )
                                  : new Container();
                        },
                      ))),
            ],
          )),
    );
  }
}

class DataSaw {
  String id_pemesanan;
  String Tanggal;
  String pengantar;
  String ALamat;

  DataSaw({
    this.id_pemesanan,
    this.Tanggal,
    this.pengantar,
    this.ALamat,
  });
  factory DataSaw.fromJson(Map<String, dynamic> json) {
    return DataSaw(
        id_pemesanan: json['id_pemesanan'],
        Tanggal: json['Tanggal'],
        pengantar: json['pengantar'],
        ALamat: json['ALamat']);
  }
}
