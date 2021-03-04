import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/list_order.dart';
import './main.dart';

class Detail_order_berjalan_lanjut extends StatefulWidget {
  String id;
  String alamat;
  String pengantar;
  Detail_order_berjalan_lanjut({this.pengantar, this.alamat, this.id});
  @override
  Detail_order_berjalan_lanjutRondo createState() =>
      new Detail_order_berjalan_lanjutRondo();
}

class Detail_order_berjalan_lanjutRondo
    extends State<Detail_order_berjalan_lanjut> {
  List<DataAlamat> _dataAlamat = [];
  List<DataAlamat> _searchAlamat = [];
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<DataBarang> _dataBarang = [];
  List<String> id_barang = List<String>();
  List<String> array_barang = [];
  List<String> nama_barang = List<String>();
  List<String> jumlah_barang = List<String>();
  List<String> id_barang_pesanan = List<String>();
  var siulA, siulB, aqua, vit, gaskcl, gasbsr, vitgls, aquagls;
  void deleteData() {
    var url = "http://timothy.buzz/juljol/delete.php";
    http.post(url, body: {'id_pemesanan': widget.id});
  }

  void deleteDataDetail() {
    var url = "http://timothy.buzz/juljol/delete_detail.php";
    http.post(url, body: {'id_pemesanan': widget.id});
  }

  void confirm() {
    AlertDialog alertDialog = new AlertDialog(
      content:
          new Text("Are You sure want to delete '${_searchAlamat[0].Alamat}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "OK DELETE!",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.red,
          onPressed: () {
            deleteData();
            deleteDataDetail();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new GridLayoutRondo()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        new RaisedButton(
          child: new Text("CANCEL", style: new TextStyle(color: Colors.black)),
          color: Colors.green,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

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

  Future<List<DataDetail>> getDataBarang() async {
    final responseB =
        await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJsonB = json.decode(responseB.body);
    setState(() {
      for (Map Data in responseJsonB) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.id_pemesanan.contains(widget.id))
          _searchDetails.add(dataDetail);
      });
      _searchDetails.forEach((e) {
        nama_barang.add(e.Nama);
        jumlah_barang.add(e.Jumlah);
        id_barang_pesanan.add(e.id_barang);
      });
    });
  }

  Future<List<DataAlamat>> getDataAlamat() async {
    final responseA = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_detail_for_detail_pemeanan_lanjut.php");
    final responseJsonA = json.decode(responseA.body);
    setState(() {
      for (Map Data in responseJsonA) {
        _dataAlamat.add(DataAlamat.fromJson(Data));
      }
      _dataAlamat.forEach((dataDetail) {
        if (dataDetail.id_pemesanan.contains(widget.id))
          _searchAlamat.add(dataDetail);
      });
    });
  }

  void initState() {
    super.initState();
    getDataAlamat();
    getDataBarang();
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
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.all(15.0),
                  margin:
                      const EdgeInsets.only(top: 70.0, left: 25.0, right: 25.0),
                  child: Table(
                    columnWidths: {
                      1: FlexColumnWidth(0.2),
                    },
                    children: [
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
                          "${widget.alamat}",
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
                          "${widget.pengantar}",
                          style: new TextStyle(fontSize: 25.0),
                        ),
                      ]),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.none &&
                              snapshot.hasData == null) {
//print('project snapshot data is: ${projectSnap.data}');
                            return CircularProgressIndicator();
                          }
                          return ListView.builder(
                            itemCount: _searchDetails.length,
                            itemBuilder: (context, i) {
                              return Container(
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(187, 111, 51, 1)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                              _searchDetails[i].Nama,
                                              style: TextStyle(fontSize: 30.0),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20, right: 20.0),
                                                  child: Text(
                                                    jumlah_barang[i],
                                                    style: TextStyle(
                                                        fontSize: 50.0),
                                                  ),
                                                  alignment:
                                                      Alignment.centerRight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
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

class DataBarang {
  String id_barang;
  String Nama;
  String Harga;
  String Stok;
  String Berat;
  String nilai_awal;
  DataBarang({
    this.id_barang,
    this.Nama,
    this.Harga,
    this.Stok,
    this.Berat,
    this.nilai_awal,
  });
  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
      id_barang: json['id_barang'],
      Nama: json['Nama'],
      Harga: json['Harga'],
      Stok: json['Stok'],
      Berat: json['Berat'],
      nilai_awal: json['nilai_awal'],
    );
  }
}

class dataPass {
  final List dataBarang;

  dataPass(this.dataBarang);
}

class DataAlamat {
  String id_pemesanan;
  String Jumlah;
  String Alamat;
  String Pekerja;
  String Total;
  String Harga;
  DataAlamat(
      {this.id_pemesanan,
      this.Jumlah,
      this.Alamat,
      this.Pekerja,
      this.Total,
      this.Harga});
  factory DataAlamat.fromJson(Map<String, dynamic> json) {
    return DataAlamat(
        id_pemesanan: json['id_pemesanan'],
        Jumlah: json['Jumlah'],
        Alamat: json['ALamat'],
        Pekerja: json['pengantar'],
        Total: json['Total'],
        Harga: json['harga']);
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

class test {
  String nama;
  String jumlah;
  String id_barang;
  test(this.nama, this.jumlah, this.id_barang);
  Map<String, dynamic> toJson() =>
      {'id_barang': id_barang, 'nama': nama, 'jumlah': jumlah};
}
