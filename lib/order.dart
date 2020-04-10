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
  String Stok;
  String Berat;

  DataBarang ({
    this.id_barang,
    this.Nama,
    this.Harga,
    this.Stok,
    this.Berat,
  });

  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga'],
        Stok: json['Stok'],
        Berat: json['Berat']
    );
  }
}

class DataDetail {
  String id_pemesanan;
  String Barang;
  String Jumlah;

  DataDetail({
    this.id_pemesanan,
    this.Barang,
    this.Jumlah,
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        id_pemesanan: json['id_pemesanan'],
        Barang: json['Barang'],
        Jumlah: json['Jumlah']
    );
  }
}

class DataAlamat {
  String id_pemesanan;
  String Alamat;
  String Pekerja;

  DataAlamat({
    this.id_pemesanan,
    this.Alamat,
    this.Pekerja,
  });

  factory DataAlamat.fromJson(Map<String, dynamic> json) {
    return DataAlamat(
        id_pemesanan: json['id_pemesanan'],
        Alamat: json['Alamat'],
        Pekerja: json['Pekerja']
    );
  }
}

class DataCek {
  String nama;

  DataCek({
    this.nama,
  });

  factory DataCek.fromJson(Map<String, dynamic> json) {
    return DataCek(
        nama: json['pengantar']
    );
  }
}



class Order extends StatefulWidget{
  List list;
  String pekerja;
  Order({this.list,this.pekerja});
  @override
  State<StatefulWidget> createState() {
    return OrderRondo();
  }

}

class OrderRondo extends State<Order> {
  List<DataBarang> _dataDetailsBarang = [];
  List<DataBarang> _searchDetailsBarang = [];
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails= [];
  List<DataAlamat> _dataDetailsAlamat = [];
  List<DataAlamat> _searchDetailsAlamat = [];
  List<DataCek>_dataDetailsCekData = [];
  int siul = 0;
  int aqua = 0;
  int vit = 0;
  int gaskcl = 0;
  int gasbsr = 0;
  int vitgls = 0;
  int aquagls = 0;
  int hrgsiul,hrgaqua,hrgvit,hrggaskcl,hrggasbsr,hrgvitgls,hrgaquagls,total;
  int brtsiul,brtaqua,brtvit,brtgaskcl,brtgasbsr,brtvitgls,brtaquagls,totalberat;
  int Modal;
  var tahun = Jiffy().format("yyyy-MM-dd");
  var waktu = Jiffy().format("HH:mm:SS");
  var jam = Jiffy().format("HH");
  var menit = Jiffy().format("mm");
  var detik = Jiffy().format("SS");

  bool _ignoring;

  String _mySelection;

  List _pekerja = List(); //edited line


  Future<String> CekData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pemesanan_only_nama.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataDetailsCekData.add(DataCek.fromJson(Data));
      }
    });
  }

  Future<String> getSWData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJson = json.decode(response.body);

    setState(() {
      _pekerja = responseJson;
    });
  }

  Future<List<DataBarang>> getDataBarang() async {
    await Future.delayed(Duration(seconds: 2));
    final responseC = await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonC = json.decode(responseC.body);

    setState(() {
      for (Map Data in responseJsonC) {
        _dataDetailsBarang.add(DataBarang.fromJson(Data));
      }
    });

    var p = _searchDetails.length;
    for (int a = 0;a < p;a++){
      if(_searchDetails[a].Barang == 'Siul'){
        siul = siul + int.parse(_searchDetails[a].Jumlah);
      } else if (_searchDetails[a].Barang == 'Aqua'){
        aqua = aqua + int.parse(_searchDetails[a].Jumlah);
      } else if (_searchDetails[a].Barang == 'Vit'){
        vit = vit + int.parse(_searchDetails[a].Jumlah);
      } else if (_searchDetails[a].Barang == 'Gas_kcl'){
        gaskcl = gaskcl + int.parse(_searchDetails[a].Jumlah);
      } else if (_searchDetails[a].Barang == 'Gas_bsr'){
        gasbsr = gasbsr + int.parse(_searchDetails[a].Jumlah);
      } else if (_searchDetails[a].Barang == 'Vit_gls'){
        vitgls = vitgls + int.parse(_searchDetails[a].Jumlah);
      } else if (_searchDetails[a].Barang == 'Aqua_gls'){
        aquagls = aquagls + int.parse(_searchDetails[a].Jumlah);
      }
    }

    hrgsiul = siul * int.parse(_dataDetailsBarang[0].Harga);
    hrgaqua = aqua * int.parse(_dataDetailsBarang[2].Harga);
    hrgvit = vit * int.parse(_dataDetailsBarang[3].Harga);
    hrggaskcl = gaskcl * int.parse(_dataDetailsBarang[4].Harga);
    hrggasbsr = gasbsr * int.parse(_dataDetailsBarang[5].Harga);
    hrgvitgls = vitgls * int.parse(_dataDetailsBarang[6].Harga);
    hrgaquagls = aquagls * int.parse(_dataDetailsBarang[7].Harga);

    total = hrgsiul + hrgaqua + hrgvit + hrggaskcl + hrggasbsr + hrgvitgls + hrgaquagls;

    brtsiul = siul * int.parse(_dataDetailsBarang[0].Berat);
    brtaqua = aqua * int.parse(_dataDetailsBarang[2].Berat);
    brtvit = vit * int.parse(_dataDetailsBarang[3].Berat);
    brtgaskcl = gaskcl * int.parse(_dataDetailsBarang[4].Berat);
    brtgasbsr = gasbsr * int.parse(_dataDetailsBarang[5].Berat);
    brtvitgls = vitgls * int.parse(_dataDetailsBarang[6].Berat);
    brtaquagls = aquagls * int.parse(_dataDetailsBarang[7].Berat);

    totalberat = brtsiul + brtaqua + brtvit + brtgaskcl + brtgasbsr + brtvitgls + brtaquagls;

    if(total < 10000){
      Modal = 10000;
    } else if (total < 20000 && total > 10000){
      Modal = 20000;
    } else if (total < 50000 && total > 20000){
      Modal = 50000;
    } else if (total < 100000 && total > 50000){
      Modal = 100000;
    } else if (total < 150000 && total > 100000){
      Modal = 150000;
    } else if (total < 200000 && total > 150000){
      Modal = 200000;
    } else {
      Modal = 300000;
    }

  }

  Future<List<DataDetail>> getDataDetail() async {
    final responseB = await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJsonB = json.decode(responseB.body);

    setState(() {
      for (Map Data in responseJsonB) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      widget.list.forEach((n) {
        _dataDetails.forEach((b) {
          if (b.id_pemesanan.contains(n))
            _searchDetails.add(b);
        });
      });
    });
  }

  Future<List<DataAlamat>> getData() async {
    final responseA = await http.get("http://timothy.buzz/juljol/get.php");
    final responseJsonA = json.decode(responseA.body);

    setState(() {
      for (Map Data in responseJsonA) {
        _dataDetailsAlamat.add(DataAlamat.fromJson(Data));
      }
      widget.list.forEach((n) {
        _dataDetailsAlamat.forEach((a) {
          if (a.id_pemesanan.contains(n))
            _searchDetailsAlamat.add(a);
        });
      });
    });
  }


  void initState(){
    super.initState();
    getData();
    getDataDetail();
    getDataBarang();
    getSWData();
    PilihPegawai();
    CekData();
    _mySelection = widget.pekerja;
  }

  void PilihPegawai(){
    if(_mySelection == "Default") {
      _ignoring = false;
    } else {
      _ignoring = true;
    }
  }

  void cek_pengantar_lanjut(eksepsi){
    var p = _dataDetailsCekData.length;
    int b = eksepsi;
    for (int a = 0; a < p;a++){
      if(_dataDetailsCekData[a].nama == widget.pekerja){
        b++;
      }
    }
    if (b == p){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Pegawai sedang dalam On Going"),
            content: new Text("Mohon untuk memeriksa apakah Pegawai masih dalam On Going atau belum menyelesaikan order"),
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
    } else {
      order();
      order_detail();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context)=> new GridLayoutRondo()),
            (Route<dynamic> route) => false,
      );
    }
  }
  void cek_pengantar(){
    if(_mySelection == "Default") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Anda belum mengigisi pengantar"),
            content: new Text("Mohon untuk mengisi kembali pegawai yang akan mengantar pesanan ini"),
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
    } else if (_mySelection != "Default"){
      var p = _dataDetailsCekData.length;
      if (p == 1){
        int b = 0;
        cek_pengantar_lanjut(b);
      } else {
        int b = 1;
        cek_pengantar_lanjut(b);
      }
    }
  }

  void order(){
    int num = total + totalberat + Modal + _searchDetailsAlamat.length + _searchDetails.length;
    var id = num.toString() + jam + menit + detik;
    var url = "http://timothy.buzz/juljol/addpemesanan.php";
    http.post(url, body: {
      "id_order": id,
      "pengantar": widget.pekerja,
      "Tanggal" : tahun,
      "Waktu": waktu,
      "Berat" : totalberat.toString(),
      "Total" : total.toString(),
      "Modal" : Modal.toString()
    });
  }

  void order_detail(){
    int num = total + totalberat + Modal + _searchDetailsAlamat.length + _searchDetails.length;
    var id = num.toString() + jam + menit + detik;
    var url = "http://timothy.buzz/juljol/addpemesanan_detail.php";
    var a = _searchDetailsAlamat.length;
    for (int x = 0;x < a;x++){
      http.post(url, body: {
        "id_order": id,
        "id_pemesanan": _searchDetailsAlamat[x].id_pemesanan,
        "Alamat" : _searchDetailsAlamat[x].Alamat
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
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
                        margin: const EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Text(
                          widget.pekerja,
                          style: new TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _searchDetailsAlamat.length,
                          itemBuilder: (context, i){
                            return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            margin: const EdgeInsets.only(left: 20.0),
                                            child: Text(_searchDetailsAlamat[i].Alamat, style: TextStyle(fontSize: 30.0),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 70),
                  width: 270.0,
                  child: IgnorePointer(
                    ignoring: _ignoring,
                    child: DropdownButton<String>(
                      items: _pekerja.map((item){
                        return DropdownMenuItem<String>(
                          value: item['Nama'],
                          child: Text(item['Nama']),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          this._mySelection = newValueSelected;
                        });
                      },
                      value: _mySelection,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 20.0, right: 20.0, bottom: 20.0),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Barang')),
                      DataColumn(label: Text('Jumlah')),
                      DataColumn(label: Text('Harga')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Isi Ulang')),
                        DataCell(Text(siul.toString())),
                        DataCell(Text(hrgsiul.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Aqua')),
                        DataCell(Text(aqua.toString())),
                        DataCell(Text(hrgaqua.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Vit')),
                        DataCell(Text(vit.toString())),
                        DataCell(Text(hrgvit.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Gas Kecil')),
                        DataCell(Text(gaskcl.toString())),
                        DataCell(Text(hrggaskcl.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Gas Besar')),
                        DataCell(Text(gasbsr.toString())),
                        DataCell(Text(hrggasbsr.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Vit Gelas')),
                        DataCell(Text(vitgls.toString())),
                        DataCell(Text(hrgvitgls.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Aqua Gelas')),
                        DataCell(Text(aquagls.toString())),
                        DataCell(Text(hrgaquagls.toString())),
                      ])
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 100, left: 20.0, right: 20.0, bottom: 120.0),
                  child : new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Table(
                        border: TableBorder.all(width: 1.0,color: Colors.black),
                        children: [
                          TableRow(children: [
                            Text('Berat', style: new TextStyle(fontSize: 25.0),),
                            Text(totalberat.toString(), style: new TextStyle(fontSize: 25.0),),
                          ]),
                          TableRow(children: [
                            Text('Total', style: new TextStyle(fontSize: 25.0),),
                            Text(total.toString(), style: new TextStyle(fontSize: 25.0),),
                          ]),
                          TableRow(children: [
                            Text('Modal', style: new TextStyle(fontSize: 25.0),),
                            Text(Modal.toString(), style: new TextStyle(fontSize: 25.0),),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cek_pengantar();
        },
        icon: Icon(Icons.save),
        label: Text("Kirim"),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
