import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/list_order.dart';
import './main.dart';

class detail_order_selesai extends StatefulWidget {
  String id_pemesanan;
  String tanggal;
  String alamat;
  String pegawai;
  detail_order_selesai(
      {this.id_pemesanan, this.alamat, this.tanggal, this.pegawai});
  @override
  State<StatefulWidget> createState() {
    return detail_order_selesai_rondo();
  }
}

class detail_order_selesai_rondo extends State<detail_order_selesai> {
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<String> id_barang = List<String>();
  List<String> nilai_awal = List<String>();
  List<DataBarang> _dataBarang = [];
  List<String> array_barang = [];

  Future<List<DataBarang>> getDataDetail() async {
    final responseB =
        await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonB = json.decode(responseB.body);
    setState(() {
      for (Map Data in responseJsonB) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _dataBarang.forEach((DataBarang) {
        id_barang.add(DataBarang.id_barang);
        array_barang.add(DataBarang.nilai_awal);
      });
    });
  }

  Future<List<DataDetail>> getData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.id_pemesanan.contains(widget.id_pemesanan))
          _searchDetails.add(dataDetail);
      });
    });
  }

  void initState() {
    super.initState();
    getData();
    getDataDetail();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(43, 40, 35, 1)),
        child: Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      color: Color.fromRGBO(187, 111, 51, 1),
                      borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(25.0),
                        bottomRight: const Radius.circular(25.0),
                      )),
                  padding: const EdgeInsets.only(
                      top: 70, bottom: 50, left: 20, right: 20),
                  child: Table(
                    columnWidths: {
                      1: FlexColumnWidth(0.2),
                    },
                    children: [
                      TableRow(children: [
                        Text(
                          'Tanggal',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          "${widget.tanggal}",
                          style: new TextStyle(fontSize: 25.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Pengantar',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          "${widget.pegawai}",
                          style: new TextStyle(fontSize: 25.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Alamat',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          "${widget.alamat}",
                          style: new TextStyle(fontSize: 25.0),
                        ),
                      ]),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                      child: FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.none &&
                              snapshot.hasData == null) {
//print('project snapshot data is: ${projectSnap.data}');
                            return Container();
                          }
                          return ListView.builder(
                            itemCount: _searchDetails.length,
                            itemBuilder: (context, i) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Color.fromRGBO(187, 111, 51, 1),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                _searchDetails[i].Nama,
                                                style:
                                                    TextStyle(fontSize: 30.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              right: 20.0),
                                          child: Text(
                                            _searchDetails[i].Jumlah,
                                            style: TextStyle(fontSize: 50.0),
                                          ),
                                          alignment: Alignment.centerRight,
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          );
                        },
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DataDetail {
  String id_pemesanan;
  String id_barang;
  String Barang;
  String Jumlah;
  String Nama;
  DataDetail({
    this.id_pemesanan,
    this.id_barang,
    this.Barang,
    this.Jumlah,
    this.Nama,
  });
  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        id_pemesanan: json['id_pemesanan'],
        id_barang: json['id_Barang'],
        Barang: json['Barang'],
        Jumlah: json['Jumlah'],
        Nama: json['Nama']);
  }
}

class DataBarang {
  String id_barang;
  String Nama;
  String Stok;
  String Berat;
  String nilai_awal;
  DataBarang({
    this.id_barang,
    this.Nama,
    this.Stok,
    this.Berat,
    this.nilai_awal,
  });
  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
      id_barang: json['id_barang'],
      Nama: json['Nama'],
      Stok: json['Stok'],
      Berat: json['Berat'],
      nilai_awal: json['nilai_awal'],
    );
  }
}
