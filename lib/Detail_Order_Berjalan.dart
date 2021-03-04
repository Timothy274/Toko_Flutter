import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/Detail_order_berjalan_lanjut.dart';
import 'package:juljol/detail.dart';
import './main.dart';

class Detail_Order_berjalan extends StatefulWidget {
  List list;
  int index;
  Detail_Order_berjalan({this.index, this.list});
  @override
  Detail_Order_berjalanRondo createState() => new Detail_Order_berjalanRondo();
}

class Detail_Order_berjalanRondo extends State<Detail_Order_berjalan> {
  List _selectedId = List();
  List _selectedAlamat = List();
  List _selectedCatatan = List();
  List<data_detail_order> array_data_detail = [];
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<DataBarangDetail> _databarangDetails = [];
  List<DataBarangDetail> _searchbarangDetails = [];
  List<DataBarang> _dataBarang = [];
  List<DataBarang> _searchdataBarang = [];
  List<DataBarang> _searchdataStock = [];
  var siul, aqua, vit, gaskcl, gasbsr, vitgls, aquagls;
  List<DataBarang> _dataStock = [];
  List<String> nilai_awal = [];
  List<String> nilai_akhir = [];
  List<int> harga = [];
  List<int> modal = [];
  List<DataPemesanan> dataPemesanan = [];
  List<DataPemesanan> searchdataPemesanan = [];
  int _totsbaru = 0;
  int _modsbaru = 0;
  String totkembalian;
  void kirim(data) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) =>
            new Detail_order_berjalan_lanjut(id: data)));
  }

  void deleteData_Pemesanan() {
    var url = "http://timothy.buzz/juljol/delete_pemesanan.php";
    http.post(url, body: {'id_order': widget.list[widget.index]['id_order']});
  }

  void deleteData_PemesananDetail() {
    var url = "http://timothy.buzz/juljol/delete_pemesanan_detail.php";
    http.post(url, body: {'id_order': widget.list[widget.index]['id_order']});
  }

  void deleteDataDetail() {
    var url = "http://timothy.buzz/juljol/delete_detail.php";
    http.post(url,
        body: {'id_pemesanan': widget.list[widget.index]['id_pemesanan']});
  }

  Future cek() async {}
  void confirm() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text(
          "Are You sure want to delete '${widget.list[widget.index]['Alamat']}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "OK DELETE!",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.red,
          onPressed: () {
            deleteData_Pemesanan();
            deleteData_PemesananDetail();
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

  Future<List<DataDetail>> getData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_pemesanan_detail.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.id_order.contains(widget.list[widget.index]['id_order']))
          _searchDetails.add(dataDetail);
      });
      for (int a = 0; a < _searchDetails.length; a++) {
        var _id = _searchDetails[a].id_pemesanan;
        var _nama = _searchDetails[a].Alamat;
        var _total = _searchDetails[a].Harga;
        var _modal;
        var _catatan = _searchDetails[a].Catatan;
        var _totalint = int.parse(_total);
        if (_totalint < 10000) {
          _modal = 10000 - _totalint;
        } else if (_totalint < 20000 && _totalint > 10000) {
          _modal = 20000 - _totalint;
        } else if (_totalint < 50000 && _totalint > 20000) {
          _modal = 50000 - _totalint;
        } else if (_totalint < 100000 && _totalint > 50000) {
          _modal = 100000 - _totalint;
        } else if (_totalint < 150000 && _totalint > 100000) {
          _modal = 150000 - _totalint;
        } else if (_totalint < 200000 && _totalint > 150000) {
          _modal = 200000 - _totalint;
        } else {
          _modal = 300000 - _totalint;
        }
        array_data_detail.add(
            data_detail_order(_id, _nama, _total, _modal.toString(), _catatan));
      }
    });
  }

  Future<List<DataBarangDetail>> getDataPemesanan() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_pemesanan.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        dataPemesanan.add(DataPemesanan.fromJson(Data));
      }
      dataPemesanan.forEach((dataDetail) {
        if (dataDetail.id_order.contains(widget.list[widget.index]['id_order']))
          searchdataPemesanan.add(dataDetail);
      });
    });
  }

  Future<List<DataBarangDetail>> getDataBarang() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _databarangDetails.add(DataBarangDetail.fromJson(Data));
      }
      _databarangDetails.forEach((dataDetail) {
        var a = _searchDetails.length;
        for (int b = 0; b < a; b++) {
          if (dataDetail.id_pemesanan.contains(_searchDetails[b].id_pemesanan))
            _searchbarangDetails.add(dataDetail);
        }
      });
    });
  }

  Future<List<DataBarang>> getBarang() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      _dataBarang.forEach((DataBarang) {
        nilai_awal.add(DataBarang.nilai_awal);
      });
    });
  }

  Future<List<DataBarang>> getStock() async {
    final response = await http.get("http://timothy.buzz/juljol/get_stock.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataStock.add(DataBarang.fromJson(Data));
      }
      _dataStock.forEach((dataDetail) {
        var a = _searchDetails.length;
        for (int b = 0; b < a; b++) {
          if (dataDetail.id_pemesanan.contains(_searchDetails[b].id_pemesanan))
            _searchdataStock.add(dataDetail);
        }
      });
    });
  }

  void initState() {
    super.initState();
    cek();
    getData();
    getDataBarang();
    getStock();
    getBarang();
    getDataPemesanan();
    kembalian();
  }

  void kembalian() {
    int _totkembalian = int.parse(widget.list[widget.index]['Modal']) +
        int.parse(widget.list[widget.index]['Total']);
    totkembalian = _totkembalian.toString();
  }

  void pass_data() {
    for (int b = 0; b < _searchdataStock.length; b++) {
      int tot, tothasil;
      for (int a = 0; a < _dataBarang.length; a++) {
        if (_dataBarang[a].id_barang == _searchdataStock[b].id_barang) {
          tot = int.parse(_searchdataStock[b].Jumlah);
          int _a = a + 1;
          if (nilai_awal[a] == "0") {
            nilai_awal.replaceRange(a, _a, [_searchdataStock[b].Jumlah]);
          } else {
            int old = int.parse(nilai_awal[b]);
            int _old = old + int.parse(_searchdataStock[b].Jumlah);
            nilai_awal.replaceRange(a, _a, [_old.toString()]);
          }
        }
      }
    }
    for (int y = 0; y < _dataBarang.length; y++) {
      int tot = int.parse(_dataBarang[y].Stok) - int.parse(nilai_awal[y]);
      nilai_akhir.add(tot.toString());
    }
    stock();
  }

  void stock() {
    for (int a = 0; a < _dataBarang.length; a++) {
      var url = "http://timothy.buzz/juljol/update_stock_after.php";
      String id_barang = _dataBarang[a].id_barang;
      String stok = nilai_akhir[a];
      http.post(url, body: {
        "id_barang": id_barang,
        "stok": stok,
      });
    }
  }

  void prerecreate() {
    if (_selectedId.length == 0) {
      _showpilerror();
    } else if (_selectedId.length == _searchDetails.length) {
      recreate();
      deleteData_Pemesanan();
      deleteData_PemesananDetail();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new GridLayoutRondo()),
        (Route<dynamic> route) => false,
      );
    } else {
      recreate();
      resetHarga();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new GridLayoutRondo()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void resetHarga() {
    int totbaru = 0;
    int modbaru = 0;
    for (int a = 0; a < _selectedId.length; a++) {
      for (int b = 0; b < array_data_detail.length; b++) {
        if (array_data_detail[b].id == _selectedId[a]) {
          harga.add(int.parse(array_data_detail[b].total));
          modal.add(int.parse(array_data_detail[b].modal));
        }
      }
    }
    for (int c = 0; c < harga.length; c++) {
      totbaru = totbaru + harga[c];
      modbaru = modbaru + modal[c];
    }
    for (int d = 0; d < searchdataPemesanan.length; d++) {
      _totsbaru = int.parse(searchdataPemesanan[d].Total) - totbaru;
      _modsbaru = int.parse(searchdataPemesanan[d].Modal) - modbaru;
    }
    updateharga();
  }

  void recreate() {
    var url = "http://timothy.buzz/juljol/adddata.php";
    var a = _selectedId.length;
    for (int b = 0; b < a; b++) {
      http.post(url, body: {
        "id_pemesanan": _selectedId[b],
        "Tanggal": widget.list[widget.index]['Tanggal'],
        "NamaPegawai": widget.list[widget.index]['pengantar'],
        "Alamat": _selectedAlamat[b],
        "idPekerja": widget.list[widget.index]['id_pegawai'],
        "Catatan": _selectedCatatan[b]
      });
    }
  }

  void updateharga() {
    var url1 = "http://timothy.buzz/juljol/update_modal.php";
    var url2 =
        "http://timothy.buzz/juljol/delete_pemesanan_detail_only_id_pemesanan.php";
    http.post(url1, body: {
      "id_order": widget.list[widget.index]['id_order'],
      "Total": _totsbaru.toString(),
      "Modal": _modsbaru.toString()
    });
    for (int a = 0; a < _selectedId.length; a++) {
      http.post(url2, body: {'id_pemesanan': _selectedId[a]});
    }
  }

  void konfirmasi_pemesanan_detail() {
    var url = "http://timothy.buzz/juljol/addpemesenan_detail_selesai.php";
    var a = _searchDetails.length;
    for (int x = 0; x < a; x++) {
      http.post(url, body: {
        "id_pemesanan": _searchDetails[x].id_pemesanan,
      });
    }
  }

  void konfirmasi_pemesanan() {
    var url = "http://timothy.buzz/juljol/addpemesanan_selesai.php";
    var a = _searchDetails.length;
    for (int x = 0; x < a; x++) {
      http.post(url, body: {
        "id_order": _searchDetails[x].id_order,
      });
    }
    pass_data();
  }

  void _onCategorySelected(
      bool selected, _searchId, _searchAlamat, _searchCatatan) {
    if (selected == true) {
      setState(() {
        _selectedId.add(_searchId);
        _selectedAlamat.add(_searchAlamat);
        _selectedCatatan.add(_searchCatatan);
      });
    } else {
      setState(() {
        _selectedId.remove(_searchId);
        _selectedAlamat.remove(_searchAlamat);
        _selectedCatatan.remove(_searchCatatan);
      });
    }
  }

  void _showpilerror() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(
              "Anda belum memilih data, silahkan pilih dalah satu data terlebih dahulu"),
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
                      top: 50, bottom: 50, left: 20, right: 20),
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
                          "${widget.list[widget.index]['Tanggal']}",
                          style: new TextStyle(fontSize: 25.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Waktu',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          "${widget.list[widget.index]['Waktu']}",
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
                          "${widget.list[widget.index]['pengantar']}",
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
                          "${widget.list[widget.index]['Modal']}",
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
                          "${widget.list[widget.index]['Total']}",
                          style: new TextStyle(fontSize: 25.0),
                        ),
                      ]),
                      TableRow(children: [
                        Text(
                          'Kembalian',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          ':',
                          style: new TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          "$totkembalian",
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
                        Text(
                          "${widget.list[widget.index]['Catatan']}",
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
                            return Container();
                          }
                          return ListView.builder(
                            itemCount: _searchDetails.length,
                            itemBuilder: (context, i) {
                              return new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: new GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Detail_order_berjalan_lanjut(
                                                id: _searchDetails[i]
                                                    .id_pemesanan,
                                                alamat:
                                                    _searchDetails[i].Alamat,
                                                pengantar:
                                                    widget.list[widget.index]
                                                        ['pengantar'],
                                              ))),
                                  child: new Card(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  187, 111, 51, 1)),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: new ListTile(
                                                      title: new Text(
                                                        array_data_detail[i]
                                                            .alamat,
                                                        style: TextStyle(
                                                          fontSize: 25.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: Checkbox(
                                                      value:
                                                          _selectedId.contains(
                                                              array_data_detail[
                                                                      i]
                                                                  .id),
                                                      onChanged:
                                                          (bool selected) {
                                                        _onCategorySelected(
                                                            selected,
                                                            (array_data_detail[
                                                                    i]
                                                                .id),
                                                            (array_data_detail[
                                                                    i]
                                                                .alamat),
                                                            (array_data_detail[
                                                                    i]
                                                                .catatan));
                                                      },
                                                    ),
                                                    alignment:
                                                        Alignment.centerRight,
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                padding: const EdgeInsets.only(
                                                    left: 40),
                                                alignment:
                                                    Alignment(-1.0, -1.0),
                                                child: new Table(
                                                  columnWidths: {
                                                    1: FlexColumnWidth(0.2),
                                                  },
                                                  children: [
                                                    TableRow(children: [
                                                      Text(
                                                        'Total',
                                                        style: new TextStyle(
                                                            fontSize: 25.0),
                                                      ),
                                                      Text(
                                                        ':',
                                                        style: new TextStyle(
                                                            fontSize: 25.0),
                                                      ),
                                                      Text(
                                                        "${array_data_detail[i].total}",
                                                        style: new TextStyle(
                                                            fontSize: 25.0),
                                                      ),
                                                    ]),
                                                    TableRow(children: [
                                                      Text(
                                                        'Modal',
                                                        style: new TextStyle(
                                                            fontSize: 25.0),
                                                      ),
                                                      Text(
                                                        ':',
                                                        style: new TextStyle(
                                                            fontSize: 25.0),
                                                      ),
                                                      Text(
                                                        "${array_data_detail[i].modal}",
                                                        style: new TextStyle(
                                                            fontSize: 25.0),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ))),
                                ),
                              );
                            },
                          );
                        },
                      )),
                ),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          prerecreate();
                        },
                        child: new Text("CANCEL"),
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.all(10.0),
                      child: RaisedButton(
                        onPressed: () {
                          confirm();
                        },
                        child: new Text("DELETE"),
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
                                builder: (BuildContext context) =>
                                    new GridLayoutRondo()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: new Text("FINISH"),
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
}

class DataDetail {
  String id_order;
  String id_pemesanan;
  String Alamat;
  String status;
  String Catatan;
  String Harga;
  DataDetail(
      {this.id_pemesanan,
      this.id_order,
      this.status,
      this.Alamat,
      this.Catatan,
      this.Harga});
  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        id_order: json['id_order'],
        id_pemesanan: json['id_pemesanan'],
        status: json['status'],
        Alamat: json['ALamat'],
        Catatan: json['Catatan'],
        Harga: json['harga']);
  }
}

class DataBarangDetail {
  String id_pemesanan;
  String Barang;
  String Jumlah;
  String Harga;
  String Modal;
  DataBarangDetail(
      {this.id_pemesanan, this.Barang, this.Jumlah, this.Harga, this.Modal});
  factory DataBarangDetail.fromJson(Map<String, dynamic> json) {
    return DataBarangDetail(
        id_pemesanan: json['id_pemesanan'],
        Barang: json['Barang'],
        Jumlah: json['Jumlah'],
        Harga: json['Harga'],
        Modal: json['Modal']);
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
  String nilai_awal;
  DataBarang(
      {this.id_barang,
      this.Nama,
      this.Harga,
      this.Stok,
      this.id_pemesanan,
      this.Barang,
      this.Jumlah,
      this.nilai_awal});
  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga'],
        Stok: json['Stok'],
        id_pemesanan: json['id_pemesanan'],
        Barang: json['Barang'],
        Jumlah: json['Jumlah'],
        nilai_awal: json['nilai_awal']);
  }
}

class DataPemesanan {
  String id_order;

  String Total;
  String Modal;
  DataPemesanan({this.id_order, this.Total, this.Modal});

  factory DataPemesanan.fromJson(Map<String, dynamic> json) {
    return DataPemesanan(
        id_order: json['id_order'], Total: json['Total'], Modal: json['Modal']);
  }
}

class data_detail_order {
  String id;
  String alamat;
  String total;
  String modal;
  String catatan;
  data_detail_order(this.id, this.alamat, this.total, this.modal, this.catatan);
  Map<String, dynamic> toJson() => {
        'id': id,
        'alamat': alamat,
        'total': total,
        'modal': modal,
        'catatan': catatan
      };
}
