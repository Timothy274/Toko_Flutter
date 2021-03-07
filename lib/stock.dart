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
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DataBarang {
  String id_barang;
  String Nama;
  String Harga;
  String Stock;
  String Berat;
  String id_Brg;
  DataBarang(
      {this.id_barang,
      this.Nama,
      this.Harga,
      this.Stock,
      this.Berat,
      this.id_Brg});
  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga'],
        Stock: json['Stok'],
        Berat: json['Berat'],
        id_Brg: json['id_Barang']);
  }
}

class Stock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StockRondo();
  }
}

class StockRondo extends State<Stock> {
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _cek1 = [];
  List<DataBarang> _cek2 = [];
  final update_nama = TextEditingController();
  final update_stok = TextEditingController();
  final update_harga = TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<List<DataBarang>> getBarang() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  Future<List<DataBarang>> getCek() async {
    final responseA = await http
        .get("http://timothy.buzz/juljol/get_odr_msk_join_odr_msk_detail.php");
    final responseJsonA = json.decode(responseA.body);
    final responseB = await http
        .get("http://timothy.buzz/juljol/get_pemesanan_detail_only_proses.php");
    final responseJsonB = json.decode(responseB.body);
    setState(() {
      for (Map Data in responseJsonA) {
        _cek1.add(DataBarang.fromJson(Data));
      }
      for (Map Data in responseJsonB) {
        _cek2.add(DataBarang.fromJson(Data));
      }
    });
  }

  void _showdialogNama() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data Sama"),
          content: new Text("Mohon Ulangi pemilihan nama untuk nama barang"),
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

  void _showdialogPenggunaan() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Peringatan"),
          content: new Text(
              "Data yang ingin anda hapus masih digunakan, mohon selesaikan atau hapus dari order"),
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

  void _showdialogharga() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Peringatan"),
          content: new Text(
              "Data yang ingin anda ubah masih digunakan, mohon selesaikan atau hapus dari order"),
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

  void _showdialogkosong() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Peringatan"),
          content:
              new Text("Data yang anda masukkan salah, mohon periksa kembali"),
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

  void cek(id_barang) {
    int id = 0;
    String nama = update_nama.text;
    for (int a = 0; a < _dataBarang.length; a++) {
      if (_dataBarang[a].Nama == nama) {
        id = id + 1;
      }
    }
    if (id != 0) {
      _showdialogNama();
    } else {
      var url = "http://timothy.buzz/juljol/update_stock_nama.php";
      http.post(url, body: {"id_barang": id_barang, "nama": update_nama.text});
      Navigator.of(context).pop();
    }
  }

  void dialogNama(id_barang, nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Edit Nama"),
          content: new Row(
            children: <Widget>[
              new Text(""),
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Masukkan Nama', hintText: '$nama'),
                controller: update_nama,
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
                validasinama(id_barang);
              },
            ),
          ],
        );
      },
    );
  }

  void dialogStock(id_barang, stok) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Ubah Stock"),
          content: new Row(
            children: <Widget>[
              new Text(""),
              new Expanded(
                  child: new TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Masukkan Stock', hintText: '$stok'),
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
                validasistok(id_barang);
              },
            ),
          ],
        );
      },
    );
  }

  void dialogHarga(id_barang, harga) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Ubah Harga"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                keyboardType: TextInputType.number,
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
                validasiharga(id_barang);
              },
            ),
          ],
        );
      },
    );
  }

  void dialogHapus(id_barang, nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Konfirmasi Penghapusan"),
          content: new Text("Apa anda yakin ingin menghapus $nama"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Hapus"),
              onPressed: () {
                validasihapus(id_barang);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void validasihapus(id_barang) {
    int aba1 = 0;
    int aba2 = 0;
    for (int a = 0; a < _cek1.length; a++) {
      if (_cek1[a].id_Brg == id_barang) {
        aba1 = aba1 + 1;
      }
    }
    for (int b = 0; b < _cek2.length; b++) {
      if (_cek2[b].id_Brg == id_barang) {
        aba2 = aba2 + 1;
      }
    }
    if (aba1 != 0 || aba2 != 0) {
      _showdialogkosong();
    } else {
      hapus(id_barang);
    }
  }

  void validasiharga(id_barang) {
    if (update_harga.text == "" || update_harga.text == "0") {
      _showdialogkosong();
    } else {
      int aba1 = 0;
      int aba2 = 0;
      for (int a = 0; a < _cek1.length; a++) {
        if (_cek1[a].id_Brg == id_barang) {
          aba1 = aba1 + 1;
        }
      }
      for (int b = 0; b < _cek2.length; b++) {
        if (_cek2[b].id_Brg == id_barang) {
          aba2 = aba2 + 1;
        }
      }
      if (aba1 != 0 || aba2 != 0) {
        _showdialogharga();
      } else {
        var url = "http://timothy.buzz/juljol/update_stock_harga.php";
        http.post(url,
            body: {"id_barang": id_barang, "Harga": update_harga.text});
        Navigator.of(context).pop();
      }
    }
  }

  void validasistok(id_barang) {
    if (update_stok.text == "" || update_stok.text == "0") {
      _showdialogkosong();
    } else {
      var url = "http://timothy.buzz/juljol/update_stock_barang.php";
      http.post(url, body: {"id_barang": id_barang, "Stok": update_stok.text});
      Navigator.of(context).pop();
    }
  }

  void validasinama(id_barang) {
    if (update_nama.text == "" || update_nama.text == null) {
      _showdialogkosong();
    } else {
      cek(id_barang);
    }
  }

  void hapus(id_barang) {
    var url = "http://timothy.buzz/juljol/delete_barang.php";
    http.post(url, body: {
      "id_barang": id_barang,
    });
  }

  void initState() {
    super.initState();
    getBarang();
    getCek();
  }

  void _onRefresh() async {
// monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
// if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
// monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
// if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      _dataBarang.clear();
      getBarang();
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullUp: true,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Container(
          color: Color(0xffffff),
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
                              margin: const EdgeInsets.only(
                                  top: 70.0, bottom: 40.0),
                              child: Text(
                                'Stock',
                                style: new TextStyle(fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          color: Color.fromRGBO(76, 177, 247, 1),
                          margin: const EdgeInsets.only(
                              top: 50, left: 20.0, right: 20.0, bottom: 150.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Barang')),
                                DataColumn(label: Text('Stock')),
                                DataColumn(label: Text('Harga')),
                                DataColumn(label: Text('Hapus'))
                              ],
                              rows: _dataBarang
                                  .map((barang) => DataRow(cells: [
                                        DataCell(
                                          Text(barang.Nama),
                                          onTap: () {
                                            dialogNama(
                                                barang.id_barang, barang.Nama);
                                          },
                                        ),
                                        DataCell(
                                          Text(barang.Stock),
                                          onTap: () {
                                            dialogStock(
                                                barang.id_barang, barang.Stock);
                                          },
                                        ),
                                        DataCell(
                                          Text(barang.Harga),
                                          onTap: () {
                                            dialogHarga(
                                                barang.id_barang, barang.Harga);
                                          },
                                        ),
                                        DataCell(
                                          Text('Hapus'),
                                          onTap: () {
                                            dialogHapus(
                                                barang.id_barang, barang.Nama);
                                          },
                                        )
                                      ]))
                                  .toList(),
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(76, 177, 247, 1),
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new TambahStock(),
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class TambahStock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TambahStockRondo();
  }
}

class TambahStockRondo extends State<TambahStock> {
  TextEditingController _controllerId = new TextEditingController();
  TextEditingController _controllerNama = new TextEditingController();
  TextEditingController _controllerHarga = new TextEditingController();
  TextEditingController _controllerBerat = new TextEditingController();
  List<DataBarang> _dataBarang = [];
  Future<List<DataBarang>> getBarang() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  void _showdialogid_Barang() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data Sama"),
          content: new Text("Mohon Ulangi pemilihan nama untuk id barang"),
          actions: <Widget>[
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

  void _showDialogPilihan() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data kosong"),
          content: new Text(
              "Mohon periksa kembali data yang anda masukkan, pastikan sudah memasukkan semua data yang dibutuhkan"),
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

  void _showdialogNama() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data Sama"),
          content: new Text("Mohon Ulangi pemilihan nama untuk nama barang"),
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

  void validasi() {
    int id = 0;
    int num = 0;
    if (_controllerNama.text == "" ||
        _controllerBerat.text == "" ||
        _controllerHarga.text == "") {
      _showDialogPilihan();
    } else {
      String nama = _controllerNama.text;
      id_alamt(String words) => words.replaceAllMapped(
          new RegExp(r'\b(\w*?)([aeiou]\w*)', caseSensitive: false),
          (Match m) => "${m[2]}${m[1]}${m[1].isEmpty ? 'way' : 'ay'}");
      var id_alamat = id_alamt("$nama");
      for (int a = 0; a < _dataBarang.length; a++) {
        if (_dataBarang[a].id_barang == id_alamat) {
          id = id + 1;
        } else if (_dataBarang[a].Nama == nama) {
          num = num + 1;
        }
      }
      if (id != 0) {
        _showdialogid_Barang();
      } else if (num != 0) {
        _showdialogNama();
      } else {
        pass_data(id_alamat);
      }
    }
  }

  void pass_data(id_alamat) {
    var url = "http://timothy.buzz/juljol/addbarang.php";
    http.post(url, body: {
      "id_barang": id_alamat,
      "Nama": _controllerNama.text,
      "Berat": _controllerBerat.text,
      "Harga": _controllerHarga.text,
    });
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new GridLayoutRondo()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffff)),
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
            decoration: BoxDecoration(
                color: Color.fromRGBO(76, 177, 247, 1),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0),
                )),
            child: Center(
              child: Container(
                child: new Form(
                  child: new Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _controllerNama,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(labelText: "Nama"),
                      ),
                      Divider(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _controllerHarga,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(labelText: "Harga"),
                      ),
                      Divider(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _controllerBerat,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(labelText: "Berat"),
                      ),
                      Divider(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          validasi();
        },
        icon: Icon(Icons.save),
        label: Text("Input"),
        backgroundColor: Color.fromRGBO(76, 177, 247, 1),
      ),
    );
  }
}
