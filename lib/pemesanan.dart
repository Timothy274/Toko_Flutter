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
import 'package:juljol/Database/DBHelper.dart';
import 'package:juljol/Model/OdrMsk.dart';


class Pemesanan extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PemesananRondo();
  }

}

class Data {
  final String _alamat;
  final String _id;
  final String _idpegawai;
  final String _namapegawai;
  final String _catatan;

  Data(this._alamat, this._id, this._idpegawai, this._namapegawai, this._catatan);
}

class PemesananRondo extends State<Pemesanan> {

  String _mySelection;

  List _pekerja = List();
  List<DataPegawai> _caripekerja = [];

  Future<String> getSWData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJson = json.decode(response.body);

    setState(() {
      _pekerja = responseJson;

      for (Map Data in responseJson) {
        _caripekerja.add(DataPegawai.fromJson(Data));
      }
    });
  }

  var tahun = Jiffy().format("yyyy-MM-dd");
  var waktu = Jiffy().format("HH:mm:SS");
  var year = Jiffy().format("yyyy");
  var bulan = Jiffy().format("MM");
  var tanggal = Jiffy().format("dd");
  var jam = Jiffy().format("HH");
  var menit = Jiffy().format("mm");
  var detik = Jiffy().format("SS");

    final alamat = TextEditingController();
    final catatan = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    alamat.dispose();
    catatan.dispose();
    super.dispose();
  }

  void initState(){
    super.initState();
    getSWData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(43, 40, 35, 1)
        ),
        child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 170.0, left: 20.0, right: 20.0),
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(187, 111, 51, 1),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    )
                ),
                child: new Form(
                  child: new Column(
                      children: <Widget>[
                        TextFormField(textCapitalization: TextCapitalization.sentences,
                            controller: alamat,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(labelText: "Alamat"),
                            validator: (val) => val.length == 1 ? "Masukkan alamat":null
                        ),
                        Divider(
                            height: 50.0),
                        new Container(
                          width: 270.0,
                          child: DropdownButton<String>(
                            items: _pekerja.map((item){
                              return DropdownMenuItem<String>(
                                value: item['id_pegawai'],
                                child: Text(item['Nama']),
                              );
                            }).toList(),
                            onChanged: (String newValueSelected) {
                              setState(() {
                                this._mySelection = newValueSelected;
                              });
                            },
                            hint: Text('Pegawai'),
                            value: _mySelection,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: TextField(
                              controller: catatan,
                              maxLines: 4,
                              decoration: new InputDecoration(labelText: "Catatan")
                          ),

                        ),
                        Divider(
                            height: 50.0),
                        Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.only(left: 60, right: 60),
                            alignment: Alignment(-1.0,-1.0),
                            child: new SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  color: Color.fromRGBO(43, 40, 35, 1),
                                  onPressed: () => _sendDataToSecondScreen(context),
                                  child: const Text(
                                      'Buat Order',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromRGBO(187, 111, 51, 1)
                                      )
                                  ),
                                )
                            )
                        ),
                      ]),
                ),
              ),
            )
        ),
      ),
    );
  }
  void _sendDataToSecondScreen(BuildContext context) async {
    var nama_pegawai;
    for(int a = 0;a < _caripekerja.length;a++){
      if(_mySelection == _caripekerja[a].id_pegawai){
        nama_pegawai = (_caripekerja[a].Nama);
      }
    }
    Data data = new Data(alamat.text, alamat.text+year+bulan+tanggal+jam+menit+detik,_mySelection,nama_pegawai,catatan.text);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Pemesanan2(data : data,),
        ));
  }
}

class DataPemesanan{
  final String _n1;
  final String _n2;
  final String _n3;
  final String _n4;
  final String _n5;
  final String _n6;
  final String _n7;

  DataPemesanan(this._n1, this._n2, this._n3, this._n4, this._n5, this._n6, this._n7);
}

class Pemesanan2 extends StatefulWidget{
  final Data data;

  Pemesanan2({Key key, @required this.data}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return pemesanan2Rondo();
  }

}

class pemesanan2Rondo extends State<Pemesanan2> {
  var tahun = Jiffy().format("yyyy-MM-dd");
  List<DataBarang> _dataBarang = [];

  DBHelper dbHelper = DBHelper();
  List<barang> barangList;
  List<String> id_barang = List<String>();
  List<String> nilai_awal = List<String>();
  Map<String, String> map;


  void _showDialogPilihan() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Data kosong"),
          content: new Text("Mohon Ulangi pemilihan data, pastikan data ada yang dipilih"),
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

  Future<List<DataBarang>> getDataDetail() async {
    final responseB = await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonB = json.decode(responseB.body);

    setState(() {
      for (Map Data in responseJsonB) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _dataBarang.forEach((DataBarang) {
        nilai_awal.add(DataBarang.nilai_awal);
      });
    });
  }

  Map<String, int> quantities = {};

  int _n1 = 0;
  int _n2 = 0;
  int _n3 = 0;
  int _n4 = 0;
  int _n5 = 0;
  int _n6 = 0;
  int _n7 = 0;
  int _n8 = 0;

  void add(array, i){
    setState(() {
      int num, awal, akhir;
      num = int.parse(array);
      num++;
      String angka = num.toString();
      awal = i;
      akhir = awal + 1;
      nilai_awal.replaceRange(awal, akhir, [angka]);
    });
  }

  void minus(array, i){
    setState(() {
      int num, awal, akhir;
      num = int.parse(array);
      if (num != 0 ){
        num--;
        String angka = num.toString();
        awal = i;
        akhir = awal + 1;
        nilai_awal.replaceRange(awal, akhir, [angka]);
      }
    });
  }

  void initState(){
    super.initState();
    getDataDetail();
  }

  void data(nama, jumlah){
    var url = "http://timothy.buzz/juljol/adddata_detail.php";
    String Barang = nama.toString();
    String Total = jumlah.toString();
    http.post(url, body: {
      "id_pemesanan" : widget.data._id,
      "Barang" : Barang,
      "Jumlah": Total,
    });
  }

  void addData() {
    var url = "http://timothy.buzz/juljol/adddata.php";

    http.post(url, body: {
      "id_pemesanan": widget.data._id,
      "Tanggal": tahun,
      "idPekerja" : widget.data._idpegawai,
      "NamaPegawai" : widget.data._namapegawai,
      "Alamat": widget.data._alamat,
      "Catatan": widget.data._catatan,
    });
  }

  void validasi(){
    int a = 0;
    String jumlah;
    for (int a = 0;a < nilai_awal.length ;a++){
      String test = (nilai_awal[a]);
      if (test == "0"){
        a++;
      }
    }
    print(nilai_awal.length);
    print(a);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(43, 40, 35, 1)
        ),
      child: Stack(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(top: 190),
            child: Form(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(187, 111, 51, 1),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      )
                  ),
                  child: ListView.builder(
                    itemCount: _dataBarang.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int i) {
                      return Row(
                        children: <Widget>[
                          new Container(
                            margin: const EdgeInsets.only(left: 40.0, bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 120.0,
                                  child: Text(
                                    _dataBarang[i].Nama,
                                    style: new TextStyle(fontSize: 30),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 40),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Container(
                                        width: 40,
                                        height: 40,
                                        child: FloatingActionButton(
                                          heroTag: null,
                                          onPressed: () => add(nilai_awal[i],i),
                                          child: new Icon(Icons.add, color: Colors.black,),
                                          backgroundColor: Colors.white,),
                                      ),

                                      new Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        child: Text(nilai_awal[i],
                                            style: new TextStyle(fontSize: 40.0)),
                                      ),

                                      new Container(
                                        width: 40,
                                        height: 40,
                                        child: FloatingActionButton(
                                          heroTag: null,
                                          onPressed: () => minus(nilai_awal[i],i),
                                          child: new Icon(
                                              const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                                              color: Colors.black),
                                          backgroundColor: Colors.white,),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  )
                  )
                ),
              ),
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _accDialog(context),
          );
        },
        icon: Icon(Icons.save),
        label: Text("Save"),
        backgroundColor: Colors.pink,
      ),
    );
  }


  Widget _accDialog(BuildContext context){
    return new AlertDialog(
      title: const Text('Konfirmasi'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAccInput(),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              validasi();
            },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Order'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        )
      ],
    );
  }


  Widget _buildAccInput() {
    return new Column(
      children: <Widget>[
        new Container(
          child: Table(
            border: TableBorder.all(width: 1.0,color: Colors.black),
            children: [
              TableRow(children: [
                Text('Alamat', style: new TextStyle(fontSize: 25.0),),
                Text("${widget.data._alamat}", style: new TextStyle(fontSize: 25.0),),
              ]),
              TableRow(children: [
                Text('Pengantar', style: new TextStyle(fontSize: 25.0),),
                Text("${widget.data._namapegawai}", style: new TextStyle(fontSize: 25.0),),
              ]),
            ],
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(top: 50),
          child: Form(
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Table(
                    border: TableBorder.all(width: 1.0,color: Colors.black),
                    children: [
                      TableRow(children: [
                        Text('SiulA', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n1', style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('SiulB', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n8', style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Aqua', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n2', style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Vit', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n3', style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Gas Kecil', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n4', style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Gas Besar', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n5', style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Vit Gelas', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n6', style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Aqua Gelas', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n7', style: new TextStyle(fontSize: 25.0),),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DataPegawai {
  String id_pegawai;
  String Nama;


  DataPegawai({
    this.id_pegawai,
    this.Nama
  });

  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        id_pegawai: json['id_pegawai'],
        Nama: json['Nama']
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

  DataBarang ({
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

class DataBarangSqflite {
  String id_barang;
  String Nama;
  String Harga;
  String Stok;
  String Berat;

  DataBarangSqflite ({
    this.id_barang,
    this.Nama,
    this.Harga,
    this.Stok,
    this.Berat,
  });
}