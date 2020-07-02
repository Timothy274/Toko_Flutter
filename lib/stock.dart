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

class DataBarang {
  String id_barang;
  String Nama;
  String Harga;
  String Stock;
  String Berat;

  DataBarang({
    this.id_barang,
    this.Nama,
    this.Harga,
    this.Stock,
    this.Berat,
  });

  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga'],
        Stock: json['Stok'],
        Berat: json['Berat']
    );
  }
}

class Stock extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return StockRondo();
  }
}

class StockRondo extends State<Stock> {
  List<DataBarang> _dataBarang = [];
  final update_stok = TextEditingController();
  final update_harga = TextEditingController();

  Future<List<DataBarang>> getBarang() async {
    final response = await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  void dialogStock(id_barang,stok) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Tambah Stock"),
          content: new Row(
            children: <Widget>[
              new Text(""),
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Team Name', hintText: '$stok'),
                    controller: update_stok,
                  ))
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                var url = "http://timothy.buzz/juljol/update_stock_barang.php";
                http.post(url, body: {
                  "id_barang": id_barang,
                  "Stok" : update_stok.text
                });
              },
            ),
          ],
        );
      },
    );
  }

  void dialogHarga(id_barang,harga) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Tambah Harga"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Masukkan Harga Baru', hintText: '$harga'),
                    controller: update_harga,
                  ))
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                var url = "http://timothy.buzz/juljol/update_stock_harga.php";
                http.post(url, body: {
                  "id_barang": id_barang,
                  "Harga" : update_harga.text
                });
              },
            ),
          ],
        );
      },
    );
  }

  void initState(){
    super.initState();
    getBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
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
                        )
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 70.0, bottom: 40.0),
                          child: Text(
                            'Stock',
                            style: new TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 20.0, right: 20.0, bottom: 80.0),
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Barang')),
                        DataColumn(label: Text('Stock')),
                        DataColumn(label: Text('Harga'))
                      ],
                      rows: _dataBarang.map((barang) => DataRow(
                          cells: [
                            DataCell(
                              Text(barang.Nama),
                              onTap: () {
                                print('Selected ${barang.Nama}');
                              },
                            ),
                            DataCell(
                              Text(barang.Stock),
                              onTap: () {
                                print('Selected ${barang.Stock}');
                                dialogStock(barang.id_barang,barang.Stock);
                              },
                            ),
                            DataCell(
                              Text(barang.Harga),
                              onTap: () {
                                print('Selected ${barang.Harga}');
                                dialogHarga(barang.id_barang,barang.Harga);
                              },
                            )
                          ]
                      )).toList(),
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