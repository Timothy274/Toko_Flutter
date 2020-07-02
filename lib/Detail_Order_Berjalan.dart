import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/Detail_order_berjalan_lanjut.dart';
import 'package:juljol/detail.dart';
import './main.dart';


class DataDetail {
  String id_order;
  String id_pemesanan;
  String Alamat;
  String status;
  String Catatan;

  DataDetail({
    this.id_pemesanan,
    this.id_order,
    this.status,
    this.Alamat,
    this.Catatan
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        id_order: json['id_order'],
        id_pemesanan: json['id_pemesanan'],
        status: json['status'],
        Alamat: json['ALamat'],
        Catatan: json['Catatan']
    );
  }
}

class DataBarangDetail {
  String id_pemesanan;
  String Barang;
  String Jumlah;

  DataBarangDetail({
    this.id_pemesanan,
    this.Barang,
    this.Jumlah
  });

  factory DataBarangDetail.fromJson(Map<String, dynamic> json) {
    return DataBarangDetail(
        id_pemesanan: json['id_pemesanan'],
        Barang: json['Barang'],
        Jumlah: json['Jumlah']
    );
  }
}

class DataBarang {
  String id_barang;
  String Nama;
  String Harga;
  String Stok;
  String id_pemesanan;
  String Barang;
  String Jumlah;

  DataBarang({
    this.id_barang,
    this.Nama,
    this.Harga,
    this.Stok,
    this.id_pemesanan,
    this.Barang,
    this.Jumlah
  });

  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga'],
        Stok: json['Stok'],
        id_pemesanan: json['id_pemesanan'],
        Barang: json['Barang'],
        Jumlah: json['Jumlah']
    );
  }
}

class Detail_Order_berjalan extends StatefulWidget {
  List list;
  int index;
  Detail_Order_berjalan({this.index,this.list});
  @override
  Detail_Order_berjalanRondo createState() => new Detail_Order_berjalanRondo();
}

class Detail_Order_berjalanRondo extends State<Detail_Order_berjalan> {
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<DataBarangDetail> _databarangDetails = [];
  List<DataBarangDetail> _searchbarangDetails = [];
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _searchdataBarang = [];
  var siul,aqua,vit,gaskcl,gasbsr,vitgls,aquagls;

  void kirim(data){
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context)=> new Detail_order_berjalan_lanjut(id: data)
        )
    );
  }

  void deleteData_Pemesanan(){
    var url="http://timothy.buzz/juljol/delete_pemesanan.php";
    http.post(url, body: {
      'id_order': widget.list[widget.index]['id_order']
    });
  }

  void deleteData_PemesananDetail(){
    var url="http://timothy.buzz/juljol/delete_pemesanan_detail.php";
    http.post(url, body: {
      'id_order': widget.list[widget.index]['id_order']
    });
  }

  void deleteDataDetail(){
    var url="http://timothy.buzz/juljol/delete_detail.php";
    http.post(url, body: {
      'id_pemesanan': widget.list[widget.index]['id_pemesanan']
    });
  }

  Future cek() async {

  }

  void confirm () {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text("Are You sure want to delete '${widget.list[widget
          .index]['Alamat']}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "OK DELETE!", style: new TextStyle(color: Colors.black),),
          color: Colors.red,
          onPressed: () {
            deleteData_Pemesanan();
            deleteData_PemesananDetail();
            deleteDataDetail();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context)=> new GridLayoutRondo()),
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


  Future<List<DataDetail>> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pemesanan_detail.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.id_order.contains(widget.list[widget.index]['id_order']))
          _searchDetails.add(dataDetail);
      });
    });
  }

  Future<List<DataBarangDetail>> getDataBarang() async {
    final response = await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _databarangDetails.add(DataBarangDetail.fromJson(Data));
      }
      _databarangDetails.forEach((dataDetail) {
        var a = _searchDetails.length;
        for(int b = 0;b < a;b++){
          if (dataDetail.id_pemesanan.contains(_searchDetails[b].id_pemesanan))
            _searchbarangDetails.add(dataDetail);
        }
      });
    });
  }

  Future<List<DataBarang>> getBarang() async {
    final response = await http.get("http://timothy.buzz/juljol/get_stock.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _dataBarang.forEach((dataDetail) {
        var a = _searchDetails.length;
        for(int b = 0;b < a;b++){
          if (dataDetail.id_pemesanan.contains(_searchDetails[b].id_pemesanan))
            _searchdataBarang.add(dataDetail);
        }
      });
    });
  }

  void initState() {
    super.initState();
    cek();
    getData();
    getDataBarang();
    getBarang();
  }

  void stock(){
    var url = "http://timothy.buzz/juljol/update_stock_after.php";
    var l = _searchdataBarang.length;
    for(int b = 0;b < l;b++){
      var a = int.parse(_searchdataBarang[b].Jumlah);
      var c = int.parse(_searchdataBarang[b].Stok);
      var hasil = (c - a);
      http.post(url, body: {
        "Nama": _searchdataBarang[b].Barang,
        "Jumlah": hasil.toString(),
      });
    }
  }

  void recreate(){
    var url = "http://timothy.buzz/juljol/adddata.php";
    var a = _searchDetails.length;
    for(int b = 0;b < a;b++){
      http.post(url, body: {
        "id_pemesanan": _searchDetails[b].id_pemesanan,
        "Tanggal": widget.list[widget.index]['Tanggal'],
        "NamaPegawai" : widget.list[widget.index]['pengantar'],
        "Alamat": _searchDetails[b].Alamat,
        "idPekerja": widget.list[widget.index]['id_pegawai'],
        "Catatan": _searchDetails[b].Catatan
      });
    }
  }

  void konfirmasi_pemesanan_detail(){
    var url = "http://timothy.buzz/juljol/addpemesenan_detail_selesai.php";
    var a = _searchDetails.length;
    for (int x = 0;x < a;x++){
      http.post(url, body: {
        "id_pemesanan": _searchDetails[x].id_pemesanan,
      });
    }
  }

  void konfirmasi_pemesanan(){
    var url = "http://timothy.buzz/juljol/addpemesanan_selesai.php";
    var a = _searchDetails.length;
    for (int x = 0;x < a;x++){
      http.post(url, body: {
        "id_order": _searchDetails[x].id_order,
      });
    }
    stock();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(43, 40, 35, 1)
        ),
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
                      )
                  ),
                  padding: const EdgeInsets.only(top: 100, bottom: 50, left: 20, right: 20),
                  child: Table(
                    border: TableBorder.all(width: 1.0,color: Colors.black),
                    children: [
                      TableRow(children: [
                        Text('Tanggal', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['Tanggal']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Waktu', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['Waktu']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Pengantar', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['pengantar']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.none &&
                              snapshot.hasData == null) {
                            //print('project snapshot data is: ${projectSnap.data}');
                            return Container();
                          }
                          return ListView.builder(
                            itemCount: _searchDetails.length,
                            itemBuilder: (context, i){
                              return new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: new GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context)=> new Detail_order_berjalan_lanjut(id: _searchDetails[i].id_pemesanan,alamat: _searchDetails[i].Alamat,pengantar: widget.list[widget.index]['pengantar'],)
                                      )
                                  ),
                                  child: new Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(187, 111, 51, 1)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: new ListTile(
                                                title: new Text(
                                                  _searchDetails[i].Alamat,
                                                  style: TextStyle(fontSize: 25.0,
                                                ),
                                              ),
                                            ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                  ),
                ),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          recreate();
                          deleteData_Pemesanan();
                          deleteData_PemesananDetail();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context)=> new GridLayoutRondo()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: new Text("CANCEL"),
                        color: Colors.green,
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          confirm();
                        },
                        child: new Text("DELETE"),
                        color: Colors.red,
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          konfirmasi_pemesanan();
                          konfirmasi_pemesanan_detail();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context)=> new GridLayoutRondo()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: new Text("FINISH"),
                        color: Colors.blue,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _accDialog(BuildContext context){
    return new AlertDialog(
      title: const Text('Edit Data'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAccInput(),
        ],
      ),
    );
  }


  Widget _buildAccInput() {
    return new Center(
      child: Column(
        children: <Widget>[
          new OutlineButton(
              child: new Text("Ubah Alamat"),

              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
          ),
          new OutlineButton(
              child: new Text("Ubah Pesanan"),
              onPressed: (){
                pass_ubah_data(context);
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
          )
        ],
      ),
    );
  }

  void pass_data(String id){

  }

  void pass_ubah_data(BuildContext context) async {

  }
}