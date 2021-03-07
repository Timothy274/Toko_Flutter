import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/pegawai.dart';
import 'package:juljol/list_order.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:async';
import 'dart:convert';

class Order extends StatefulWidget {
  List list;
  String pekerja;
  String idPegawai;
  Order({this.list, this.pekerja, this.idPegawai});
  @override
  State<StatefulWidget> createState() {
    return OrderRondo();
  }
}

class OrderRondo extends State<Order> {
  List _selectedId = List();
  List _selectedTotal = List();
  List<DataBarang> _dataDetailsBarang = [];
  List<DataBarang> _searchDetailsBarang = [];
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<DataAlamat> _dataDetailsAlamat = [];
  List<DataAlamat> _searchDetailsAlamat = [];
  List<DataCek> _dataDetailsCekData = [];
  List<String> id_barang = List<String>();
  List<String> nilai_awal = List<String>();
  List<String> array_barang = List<String>();
  List<String> array_harga = List<String>();
  List<String> array_berat = List<String>();
  List<String> array_barang_satuan = List<String>();
  List<data_detail_order> array_data_detail = [];
  List<data_order> dataOrder = [];
  List<String> tots = List<String>();
  int total_harga = 0;
  int total_berat = 0;
  int Modal = 0;
  List<String> array_modal = List<String>();
  var tahun = Jiffy().format("yyyy-MM-dd");
  var waktu = Jiffy().format("HH:mm:SS");
  var jam = Jiffy().format("HH");
  var menit = Jiffy().format("mm");
  var detik = Jiffy().format("SS");
  int savemodal, modalakhir;
  final catatan = TextEditingController();
  List<DataPegawai> _caripekerja = [];
  var namaPengirim;
  var nama_pegawai;
  bool _ignoring;
  String _mySelection;
  List _pekerja = List(); //edited line

  Future<String> CekData() async {
    final response = await http
        .get("http://timothy.buzz/juljol/get_pemesanan_only_nama.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataDetailsCekData.add(DataCek.fromJson(Data));
      }
    });
  }

  Future<String> getSWData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJson = json.decode(response.body);
    setState(() {
      _pekerja = responseJson;
      for (Map Data in responseJson) {
        _caripekerja.add(DataPegawai.fromJson(Data));
      }
    });
  }

  void data_harga_satuan() {
    for (var i = 0; i < widget.list.length; i++) {
      print(widget.list[i]);
      int harga_per_rumah = 0;
      int total = 0;
      for (var j = 0; j < _searchDetails.length; j++) {
        if (widget.list[i] == _searchDetails[j].id_pemesanan) {
          for (var k = 0; k < _dataDetailsBarang.length; k++) {
            if (_searchDetails[j].Barang == _dataDetailsBarang[k].id_barang) {
              harga_per_rumah = int.parse(_searchDetails[j].Jumlah) *
                  int.parse(_dataDetailsBarang[k].Harga);
              total = total + harga_per_rumah;
            }
          }
        }
      }
      tots.add(total.toString());
    }
  }

  void data_awal() {
    String num;
    for (var i = 0; i < _searchDetails.length; i++) {
      for (var o = 0; o < id_barang.length; o++) {
        if (_searchDetails[i].Barang == id_barang[o]) {
          int a = o + 1;
          num = _searchDetails[i].Jumlah;
          var data = array_barang.getRange(o, a);
          var _data = data.toList();
          var _data_akhir = _data[0];
          if (_data_akhir == "0") {
            array_barang.replaceRange(o, a, [num]);
          } else {
            int data_int = int.parse(_data_akhir);
            int hasil = data_int + int.parse(num);
            String _hasil = hasil.toString();
            array_barang.replaceRange(o, a, [_hasil]);
          }
        }
      }
    }
  }

  void harga_awal() {
    for (int a = 0; a < _dataDetailsBarang.length; a++) {
      if (array_barang[a] == "0") {
        array_harga.add("0");
      } else {
        array_harga.add(_dataDetailsBarang[a].Harga);
      }
    }
    for (int b = 0; b < array_harga.length; b++) {
      var harga = array_harga[b];
      var jumlah = array_barang[b];
      int _total_harga = int.parse(harga) * int.parse(jumlah);
      total_harga = total_harga + _total_harga;
    }
  }

  void berat_awal() {
    for (int a = 0; a < _dataDetailsBarang.length; a++) {
      array_berat.add(_dataDetailsBarang[a].Berat);
    }
    for (int b = 0; b < array_berat.length; b++) {
      var harga = array_berat[b];
      var jumlah = array_barang[b];
      int _total_berat = int.parse(harga) * int.parse(jumlah);
      total_berat = total_berat + _total_berat;
    }
  }

  void pass_array() {
    for (int a = 0; a < _dataDetailsBarang.length; a++) {
      var id_barang = _dataDetailsBarang[a].id_barang;
      var nama = _dataDetailsBarang[a].Nama;
      var jumlah = array_barang[a];
      int _harga = int.parse(array_harga[a]) * int.parse(array_barang[a]);
      String harga = _harga.toString();
      var berat = array_berat[a];
      dataOrder.add(data_order(id_barang, nama, jumlah, harga, berat));
    }
  }

  Future<List<DataBarang>> getDataBarang() async {
    await Future.delayed(Duration(seconds: 2));
    final responseC =
        await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonC = json.decode(responseC.body);
    setState(() {
      for (Map Data in responseJsonC) {
        _dataDetailsBarang.add(DataBarang.fromJson(Data));
      }
      _dataDetailsBarang.forEach((DataBarang) {
        id_barang.add(DataBarang.id_barang);
        array_barang.add(DataBarang.nilai_awal);
        array_barang_satuan.add(DataBarang.nilai_awal);
      });
    });
    data_harga_satuan();
    data_awal();
    harga_awal();
    berat_awal();
    pass_array();
    data_detaru();
  }

  void data_detaru() {
    for (int a = 0; a < _searchDetailsAlamat.length; a++) {
      var _id = _searchDetailsAlamat[a].id_pemesanan;
      var _modal = 0;
      var _nama = _searchDetailsAlamat[a].Alamat;
      var _total = tots[a];
      if (int.parse(_total) < 10000) {
        _modal = 10000 - int.parse(_total);
      } else if (int.parse(_total) < 20000 && int.parse(_total) > 10000) {
        _modal = 20000 - int.parse(_total);
      } else if (int.parse(_total) < 50000 && int.parse(_total) > 20000) {
        _modal = 50000 - int.parse(_total);
      } else if (int.parse(_total) < 100000 && int.parse(_total) > 50000) {
        _modal = 100000 - int.parse(_total);
      } else if (int.parse(_total) < 150000 && int.parse(_total) > 100000) {
        _modal = 150000 - int.parse(_total);
      } else if (int.parse(_total) < 200000 && int.parse(_total) > 150000) {
        _modal = 200000 - int.parse(_total);
      } else {
        _modal = 300000 - int.parse(_total);
      }
      array_data_detail
          .add(data_detail_order(_id, _nama, _total, _modal.toString()));
      Modal = Modal + _modal;
    }
  }

  Future<List<DataDetail>> getDataDetail() async {
    final responseB =
        await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJsonB = json.decode(responseB.body);
    setState(() {
      for (Map Data in responseJsonB) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      widget.list.forEach((n) {
        _dataDetails.forEach((b) {
          if (b.id_pemesanan.contains(n)) _searchDetails.add(b);
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
          if (a.id_pemesanan.contains(n)) _searchDetailsAlamat.add(a);
        });
      });
    });
  }

  void initState() {
    super.initState();
    getData();
    getDataDetail();
    getDataBarang();
    getSWData();
    PilihPegawai();
    CekData();
    _mySelection = widget.idPegawai;
    for (int a = 0; a < _caripekerja.length; a++) {
      if (_mySelection == _caripekerja[a].id_pegawai) {
        namaPengirim = _caripekerja[a].Nama;
      }
    }
  }

  void PilihPegawai() {
    if (_mySelection == "Default") {
      _ignoring = true;
    } else {
      _ignoring = false;
    }
  }

  void cek_pengantar_lanjut(eksepsi, nama_pegawai) {
    var p = _dataDetailsCekData.length;
    int b = eksepsi;
    for (int a = 0; a < p; a++) {
      if (_dataDetailsCekData[a].nama == nama_pegawai) {
        b++;
      }
    }
    if (b == p) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
// return object of type Dialog
          return AlertDialog(
            title: new Text("Pegawai sedang dalam On Going"),
            content: new Text(
                "Mohon untuk memeriksa apakah Pegawai masih dalam On Going atau belummenyelesaikan order"),
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
            builder: (BuildContext context) => new GridLayoutRondo()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void cek_pengantar() {
    for (int a = 0; a < _caripekerja.length; a++) {
      if (_mySelection == _caripekerja[a].id_pegawai) {
        nama_pegawai = _caripekerja[a].Nama;
      }
    }
    if (nama_pegawai == "Default") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
// return object of type Dialog
          return AlertDialog(
            title: new Text("Anda belum mengigisi pengantar"),
            content: new Text(
                "Mohon untuk mengisi kembali pegawai yang akan mengantar pesanan ini"),
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
    } else if (nama_pegawai != "Default") {
      var p = _dataDetailsCekData.length;
      if (p == 1) {
        int b = 0;
        cek_pengantar_lanjut(b, nama_pegawai);
      } else {
        int b = 1;
        cek_pengantar_lanjut(b, nama_pegawai);
      }
    }
  }

  void order() {
    var nama_pegawai;
    for (int a = 0; a < _caripekerja.length; a++) {
      if (_mySelection == _caripekerja[a].id_pegawai) {
        nama_pegawai = _caripekerja[a].Nama;
      }
    }
    int num = total_harga +
        total_berat +
        Modal +
        _searchDetailsAlamat.length +
        _searchDetails.length;
    var id = num.toString() + jam + menit + detik;
    var url = "http://timothy.buzz/juljol/addpemesanan.php";
    http.post(url, body: {
      "id_order": id,
      "id_pegawai": _mySelection,
      "pengantar": nama_pegawai,
      "Tanggal": tahun,
      "Waktu": waktu,
      "Berat": total_berat.toString(),
      "Total": total_harga.toString(),
      "Catatan": catatan.text,
      "Modal": Modal.toString()
    });
  }

  void order_detail() {
    int num = total_harga +
        total_berat +
        Modal +
        _searchDetailsAlamat.length +
        _searchDetails.length;
    var id = num.toString() + jam + menit + detik;
    var url = "http://timothy.buzz/juljol/addpemesanan_detail.php";
    var a = _searchDetailsAlamat.length;
    for (int x = 0; x < a; x++) {
      http.post(url, body: {
        "id_order": id,
        "id_pemesanan": _searchDetailsAlamat[x].id_pemesanan,
        "Alamat": _searchDetailsAlamat[x].Alamat,
        "Catatan": _searchDetailsAlamat[x].Catatan,
        "harga": tots[x]
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffff)),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(76, 177, 247, 1),
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                        )),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                              top: 70.0, left: 20.0, right: 20.0, bottom: 10.0),
                          child: Text(
                            'Order',
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
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _searchDetailsAlamat.length,
                            itemBuilder: (context, i) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Text(
                                            _searchDetailsAlamat[i].Alamat,
                                            style: TextStyle(fontSize: 30.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(76, 177, 247, 1),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(10.0)),
                    ),
                    margin: EdgeInsets.only(top: 70),
                    width: 270.0,
                    child: IgnorePointer(
                      ignoring: _ignoring,
                      child: DropdownButton<String>(
                        items: _pekerja.map((item) {
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
                        value: _mySelection,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: array_data_detail.length,
                      itemBuilder: (context, i) {
                        return Card(
                            color: Color.fromRGBO(76, 177, 247, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: GestureDetector(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: new ListTile(
                                            title: new Text(
                                              array_data_detail[i].alamat,
                                              style: TextStyle(
                                                fontSize: 25.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      padding: const EdgeInsets.only(left: 40),
                                      alignment: Alignment(-1.0, -1.0),
                                      child: new Table(
                                        columnWidths: {
                                          1: FlexColumnWidth(0.2),
                                        },
                                        children: [
                                          TableRow(children: [
                                            Text(
                                              'Total',
                                              style:
                                                  new TextStyle(fontSize: 25.0),
                                            ),
                                            Text(
                                              ':',
                                              style:
                                                  new TextStyle(fontSize: 25.0),
                                            ),
                                            Text(
                                              "${array_data_detail[i].total}",
                                              style:
                                                  new TextStyle(fontSize: 25.0),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Text(
                                              'Modal',
                                              style:
                                                  new TextStyle(fontSize: 25.0),
                                            ),
                                            Text(
                                              ':',
                                              style:
                                                  new TextStyle(fontSize: 25.0),
                                            ),
                                            Text(
                                              "${array_data_detail[i].modal}",
                                              style:
                                                  new TextStyle(fontSize: 25.0),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 50, left: 20.0, right: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(76, 177, 247, 1),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Barang')),
                        DataColumn(label: Text('Jumlah')),
                        DataColumn(label: Text('Harga')),
                      ],
                      rows: dataOrder
                          .map((data) => DataRow(cells: [
                                DataCell(Text(data.nama)),
                                DataCell(
                                  Text(data.jumlah),
                                ),
                                DataCell(Text(data.harga)),
                              ]))
                          .toList(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 100, left: 10.0, right: 10.0, bottom: 120.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(76, 177, 247, 1),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new Table(
                          columnWidths: {
                            1: FlexColumnWidth(0.2),
                          },
                          children: [
                            TableRow(children: [
                              Text(
                                'Berat',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              Text(
                                ':',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              Text(
                                total_berat.toString(),
                                style: new TextStyle(fontSize: 25.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'Total',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              Text(
                                ':',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              Text(
                                total_harga.toString(),
                                style: new TextStyle(fontSize: 25.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'Modal',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              Text(
                                ':',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              Text(
                                Modal.toString(),
                                style: new TextStyle(fontSize: 25.0),
                              ),
                            ]),
                            TableRow(children: [
                              Text(
                                'Catatan',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              Text(
                                ':',
                                style: new TextStyle(fontSize: 25.0),
                              ),
                              TextField(
                                controller: catatan,
                                maxLines: 2,
                                maxLength: 50,
                              ),
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
        icon: Icon(Icons.send),
        label: Text(
          "Kirim",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}

class DataPegawai {
  String id_pegawai;
  String Nama;

  DataPegawai({this.id_pegawai, this.Nama});
  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(id_pegawai: json['id_pegawai'], Nama: json['Nama']);
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
        nilai_awal: json['nilai_awal']);
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
        Barang: json['id_Barang'],
        Jumlah: json['Jumlah']);
  }
}

class DataAlamat {
  String id_pemesanan;
  String Alamat;
  String Pekerja;
  String Catatan;
  DataAlamat({this.id_pemesanan, this.Alamat, this.Pekerja, this.Catatan});
  factory DataAlamat.fromJson(Map<String, dynamic> json) {
    return DataAlamat(
        id_pemesanan: json['id_pemesanan'],
        Alamat: json['Alamat'],
        Pekerja: json['Pekerja'],
        Catatan: json['Catatan']);
  }
}

class DataCek {
  String nama;
  DataCek({
    this.nama,
  });
  factory DataCek.fromJson(Map<String, dynamic> json) {
    return DataCek(nama: json['pengantar']);
  }
}

class data_order {
  String id_barang;
  String jumlah;
  String nama;
  String harga;
  String berat;
  data_order(this.id_barang, this.nama, this.jumlah, this.harga, this.berat);
  Map<String, dynamic> toJson() => {
        'id_Barang': id_barang,
        'nama': nama,
        'jumlah': jumlah,
        'harga': harga,
        'berat': berat
      };
}

class data_detail_order {
  String id;
  String alamat;
  String total;
  String modal;
  data_detail_order(this.id, this.alamat, this.total, this.modal);
  Map<String, dynamic> toJson() =>
      {'id': id, 'alamat': alamat, 'total': total, 'modal': modal};
}
