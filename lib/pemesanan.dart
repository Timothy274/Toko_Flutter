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

class Pemesanan extends StatefulWidget {
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
  Data(this._alamat, this._id, this._idpegawai, this._namapegawai,
      this._catatan);
}

class PemesananRondo extends State<Pemesanan> {
  String _mySelection;
  List<DataTahun> _tahunnosort = [];
  List<String> _tahun = [];
  List<String> _sorttahun = [];
  List<String> _tahunset = [];
  List<String> _tahunnocut = [];
  List _pekerja = List();
  List<DataPegawai> _caripekerja = [];
  Future<String> getSWData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_pegawai_except_p.php");
    final responseJson = json.decode(response.body);
    setState(() {
      _pekerja = responseJson;
      for (Map Data in responseJson) {
        _caripekerja.add(DataPegawai.fromJson(Data));
      }
    });
  }

  Future<String> getTahun() async {
    final response = await http.get("http://timothy.buzz/juljol/get_tahun.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _tahunnosort.add(DataTahun.fromJson(Data));
      }
      for (int a = 0; a < _tahunnosort.length; a++) {
        _tahun.add(_tahunnosort[a].Tahun);
      }
      _sorttahun = _tahun.toSet().toList();
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

  void initState() {
    super.initState();
    getSWData();
    getTahun();
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

  void _showDialogTahun() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(
              "Anda belum bisa melakukan tambah order dikarenakan terdapat tahun berbeda, mohon periksa laporan anda"),
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffff)),
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 170.0, left: 20.0, right: 20.0),
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
            decoration: BoxDecoration(
                color: Color.fromRGBO(76, 177, 247, 1),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                )),
            child: new Form(
              child: new Column(children: <Widget>[
                TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: alamat,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(labelText: "Alamat"),
                    validator: (val) =>
                        val.length == 1 ? "Masukkan alamat" : null),
                Divider(height: 50.0),
                new Container(
                  width: 270.0,
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
                    hint: Text('Pegawai'),
                    value: _mySelection,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextField(
                      controller: catatan,
                      maxLength: 100,
                      maxLines: 4,
                      decoration: new InputDecoration(labelText: "Catatan")),
                ),
                Divider(height: 50.0),
                Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    alignment: Alignment(-1.0, -1.0),
                    child: new SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Color.fromRGBO(76, 177, 247, 1),
                          onPressed: () => _sendDataToSecondScreen(context),
                          child: const Text('Buat Order',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black))),
                    )),
              ]),
            ),
          ),
        )),
      ),
    );
  }

  void _sendDataToSecondScreen(BuildContext context) async {
    var nama_pegawai;
    String tahunpil;
    for (int b = 0; b < _sorttahun.length; b++) {
      var bulannocut = _sorttahun[b];
      var bulancut = bulannocut.substring(5, 7);
      if (bulan == bulancut) {
        var tahuncut = bulannocut.substring(0, 4);
        _tahunnocut.add(tahuncut);
        _tahunset = _tahunnocut.toSet().toList();
      }
    }
    for (int s = 0; s < _tahunset.length; s++) {
      tahunpil = _tahunset[s];
    }
    for (int a = 0; a < _caripekerja.length; a++) {
      if (_mySelection == _caripekerja[a].id_pegawai) {
        nama_pegawai = (_caripekerja[a].Nama);
      }
    }
    if ((alamat.text == '') || (nama_pegawai == null)) {
      _showDialogPilihan();
    } else if ((tahunpil == null) || (tahunpil == year)) {
      Data data = new Data(
          alamat.text,
          alamat.text + year + bulan + tanggal + jam + menit + detik,
          _mySelection,
          nama_pegawai,
          catatan.text);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pemesanan2(
              data: data,
            ),
          ));
    } else if (tahunpil != year) {
      _showDialogTahun();
    }
  }
}

class Pemesanan2 extends StatefulWidget {
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
  List<test> _datapass = [];
  List<String> _dataStock = [];
  List<String> id_barang = List<String>();
  List<String> nilai_awal = List<String>();
  Map<String, String> map;

  void _showDialogPilihan() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Data kosong"),
          content: new Text(
              "Mohon Ulangi pemilihan data, pastikan data ada yang dipilih"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                cancel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showdialogStok() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Barang Kosong"),
          content:
              new Text("Barang Kosong, mohon periksa kembali atau isi stock"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                cancel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        nilai_awal.add(DataBarang.nilai_awal);
      });
    });
  }

  Map<String, int> quantities = {};
  void add(array, i) {
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

  void minus(array, i) {
    setState(() {
      int num, awal, akhir;
      num = int.parse(array);
      if (num != 0) {
        num--;
        String angka = num.toString();
        awal = i;
        akhir = awal + 1;
        nilai_awal.replaceRange(awal, akhir, [angka]);
      }
    });
  }

  void initState() {
    super.initState();
    getDataDetail();
  }

  void distribute() {
    int cek = 0;
    for (int b = 0; b < _dataBarang.length; b++) {
      if (_datapass[b].jumlah != '0') {
        if (_dataBarang[b].Stok == '0') {
          cek = cek + 1;
        }
      }
    }
    if (cek != 0) {
      Navigator.pop(context);
      _showdialogStok();
    } else {
      addData();
      for (int a = 0; a < _datapass.length; a++) {
        if (_datapass[a].jumlah != "0") {
          var nama = _datapass[a].id_Barang;
          var jumlah = _datapass[a].jumlah;
          data(nama, jumlah);
        }
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => new GridLayoutRondo()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void data(nama, jumlah) {
    var url = "http://timothy.buzz/juljol/adddata_detail.php";
    String Barang = nama.toString();
    String Total = jumlah.toString();
    http.post(url, body: {
      "id_pemesanan": widget.data._id,
      "id_Barang": Barang,
      "Jumlah": Total,
    });
  }

  void addData() {
    var url = "http://timothy.buzz/juljol/adddata.php";
    http.post(url, body: {
      "id_pemesanan": widget.data._id,
      "Tanggal": tahun,
      "idPekerja": widget.data._idpegawai,
      "NamaPegawai": widget.data._namapegawai,
      "Alamat": widget.data._alamat,
      "Catatan": widget.data._catatan,
    });
  }

  void validasi() {
    int b = 0;
    String jumlah;
    for (int a = 0; a < nilai_awal.length; a++) {
      String test = (nilai_awal[a]);
      if (test == "0") {
        b++;
      }
    }
    if (b == nilai_awal.length) {
      _showDialogPilihan();
    } else {
      pass_data();
    }
  }

  void pass_data() {
    String jsonlist;
    for (int a = 0; a < _dataBarang.length; a++) {
      var id_Barang = _dataBarang[a].id_barang;
      var nama = _dataBarang[a].Nama;
      var jumlah = nilai_awal[a];
      _datapass.add(test(id_Barang, nama, jumlah));
    }
    for (int b = 0; b < _dataBarang.length; b++) {
      var hasil = int.parse(_dataBarang[b].Stok) - int.parse(nilai_awal[b]);
      _dataStock.add(hasil.toString());
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => _accDialog(context),
      barrierDismissible: false,
    );
  }

  void cancel() {
    _datapass.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Color(0xffffff)),
          child: Stack(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 190),
                child: Form(
                    child: Container(
                        padding: const EdgeInsets.only(top: 40, bottom: 50),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(76, 177, 247, 1),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            )),
                        child: ListView.builder(
                          itemCount: _dataBarang.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int i) {
                            return Row(
                              children: <Widget>[
                                new Container(
                                  margin: const EdgeInsets.only(
                                      left: 40.0, bottom: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 120.0,
                                        child: Text(
                                          _dataBarang[i].Nama,
                                          style: new TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 40),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            new Container(
                                              width: 40,
                                              height: 40,
                                              child: FloatingActionButton(
                                                heroTag: null,
                                                onPressed: () =>
                                                    add(nilai_awal[i], i),
                                                child: new Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                ),
                                                backgroundColor: Colors.white,
                                              ),
                                            ),
                                            new Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(nilai_awal[i],
                                                  style: new TextStyle(
                                                      fontSize: 40.0)),
                                            ),
                                            new Container(
                                              width: 40,
                                              height: 40,
                                              child: FloatingActionButton(
                                                heroTag: null,
                                                onPressed: () =>
                                                    minus(nilai_awal[i], i),
                                                child: new Icon(Icons.remove,
                                                    color: Colors.black),
                                                backgroundColor: Colors.white,
                                              ),
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
                        ))),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          validasi();
        },
        icon: Icon(Icons.add),
        label: Text("Tambah", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }

  Widget _accDialog(BuildContext context) {
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
            distribute();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Order'),
        ),
        new FlatButton(
          onPressed: () {
            cancel();
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
          margin: const EdgeInsets.only(top: 10),
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  'Alamat',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  ':',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  "${widget.data._alamat}",
                  style: new TextStyle(fontSize: 15.0),
                ),
              ]),
              TableRow(children: [
                Text(
                  'Pengantar',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  ':',
                  style: new TextStyle(fontSize: 15.0),
                ),
                Text(
                  "${widget.data._namapegawai}",
                  style: new TextStyle(fontSize: 15.0),
                ),
              ]),
            ],
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(top: 50),
          child: SizedBox(
            height: 300,
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    new DataTable(
                      columns: [
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Jumlah'))
                      ],
                      rows: _datapass
                          .map((data) => DataRow(cells: [
                                DataCell(Text(data.nama)),
                                DataCell(Text(data.jumlah))
                              ]))
                          .toList(),
                    )
                  ],
                ),
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
      nilai_awal: json['nilai_awal'],
    );
  }
}

class test {
  String id_Barang;
  String nama;
  String jumlah;

  test(this.id_Barang, this.nama, this.jumlah);
  Map<String, dynamic> toJson() =>
      {'id_Barang': id_Barang, 'nama': nama, 'jumlah': jumlah};
}

class testDecode {
  String nama;
  String jumlah;
  testDecode({
    this.nama,
    this.jumlah,
  });
  factory testDecode.fromJson(Map<String, dynamic> json) {
    return testDecode(
      nama: json['nama'],
      jumlah: json['jumlah'],
    );
  }
}

class DataTahun {
  String Tahun;

  DataTahun({this.Tahun});
  factory DataTahun.fromJson(Map<String, dynamic> json) {
    return DataTahun(Tahun: json['Tanggal']);
  }
}
