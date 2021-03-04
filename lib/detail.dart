import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/list_order.dart';
import './main.dart';

class Detail extends StatefulWidget {
  List list;
  int index;
  Detail({this.index, this.list});
  @override
  _DetailState createState() => new _DetailState();
}

class _DetailState extends State<Detail> {
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<String> id_barang = List<String>();
  List<String> nilai_awal = List<String>();
  List<DataBarang> _dataBarang = [];
  List<String> array_barang = [];

  void deleteData() {
    var url = "http://timothy.buzz/juljol/delete.php";
    http.post(url,
        body: {'id_pemesanan': widget.list[widget.index]['id_pemesanan']});
  }

  void deleteDataDetail() {
    var url = "http://timothy.buzz/juljol/delete_detail.php";
    http.post(url,
        body: {'id_pemesanan': widget.list[widget.index]['id_pemesanan']});
  }

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

  Future<List<DataDetail>> getData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.id_pemesanan
            .contains(widget.list[widget.index]['id_pemesanan']))
          _searchDetails.add(dataDetail);
      });
    });
  }

  void Detail_Barang() {
    int awal, akhir;
    String num;
    for (var i = 0; i < _searchDetails.length; i++) {
      for (var o = 0; o < id_barang.length; o++) {
        if (_searchDetails[i].id_barang == id_barang[o]) {
          int a = o + 1;
          num = _searchDetails[i].Jumlah;
          array_barang.replaceRange(o, a, [num]);
        }
      }
    }
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
                          "${widget.list[widget.index]['Tanggal']}",
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
                          "${widget.list[widget.index]['NamaPekerja']}",
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
                          "${widget.list[widget.index]['Alamat']}",
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
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          Detail_Barang();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _accDialog(context),
                          );
                        },
                        child: new Text("EDIT"),
                        color: Colors.green,
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          confirm();
                        },
                        child: new Text("DELETE"),
                        color: Colors.red,
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

  Widget _accDialog(BuildContext context) {
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
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new EditPemesanan(
                      list: widget.list,
                      index: widget.index,
                    ),
                  )),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))),
          new OutlineButton(
              child: new Text("Ubah Pesanan"),
              onPressed: () {
                pass_data(context);
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)))
        ],
      ),
    );
  }

  void pass_data(BuildContext context) async {
    dataPass data = new dataPass(array_barang);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditOrderan(
                list: widget.list, index: widget.index, data: data)));
  }
}

class EditOrderan extends StatefulWidget {
  final List list;
  final int index;
  final dataPass data;
  EditOrderan({this.list, this.index, this.data});
  @override
  State<StatefulWidget> createState() {
    return EditOderanRondo();
  }
}

class EditOderanRondo extends State<EditOrderan> {
  String siulA, siulB, aqua, vit, gaskcl, gasbsr, vitgls, aquagls;
  List<String> arraybarang = List<String>();
  List<test> _datapass = [];
  List<String> _dataBarang_Baru = List<String>();
  List<String> _dataBarang_Lama = List<String>();
  List<DataBarang> _dataBarang = [];
  List<String> nilai_awal = List<String>();
  @override
  void initState() {
    super.initState();
    arraybarang = widget.data.dataBarang;
    _dataBarang_Lama = widget.data.dataBarang;
    getDataDetail();
  }

  void update(nama, jumlah) {
    String Barang = nama.toString();
    String Total = jumlah.toString();
    var url = "http://timothy.buzz/juljol/update_detail.php";
    http.post(url, body: {
      "id_pemesanan": widget.list[widget.index]['id_pemesanan'],
      "id_Barang": Barang,
      "Jumlah": Total,
    });
  }

  Future<List<DataBarang>> getDataDetail() async {
    final responseB =
        await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonB = json.decode(responseB.body);

    setState(() {
      for (Map Data in responseJsonB) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  void validasi() {
    int b = 0;
    for (int a = 0; a < arraybarang.length; a++) {
      String test = (arraybarang[a]);
      if (test == "0") {
        b++;
      }
    }
    if (b == arraybarang.length) {
      _showDialogPilihan();
    } else {
      pass_data();
    }
  }

  void pass_data() {
    for (int a = 0; a < _dataBarang.length; a++) {
      var id_barang = _dataBarang[a].id_barang;
      var nama = _dataBarang[a].Nama;
      var jumlah = arraybarang[a];
      _datapass.add(test(id_barang, nama, jumlah));
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => _accDialog(context),
      barrierDismissible: false,
    );
  }

  void distribute() {
    for (int a = 0; a < _datapass.length; a++) {
      var id_barang = _datapass[a].nama;
      var jumlah = _datapass[a].id_barang;
      update(id_barang, jumlah);
    }
  }

  void cancel() {
    _datapass.clear();
  }

  void add(array, i) {
    setState(() {
      int num, awal, akhir;
      num = int.parse(array);
      num++;
      String angka = num.toString();
      awal = i;
      akhir = awal + 1;
      arraybarang.replaceRange(awal, akhir, [angka]);
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
        arraybarang.replaceRange(awal, akhir, [angka]);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(43, 40, 35, 1)),
          child: Stack(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 190),
                child: Form(
                    child: Container(
                        padding: const EdgeInsets.only(top: 40, bottom: 50),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(187, 111, 51, 1),
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
                                                    add(arraybarang[i], i),
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
                                              child: Text(arraybarang[i],
                                                  style: new TextStyle(
                                                      fontSize: 40.0)),
                                            ),
                                            new Container(
                                              width: 40,
                                              height: 40,
                                              child: FloatingActionButton(
                                                heroTag: null,
                                                onPressed: () =>
                                                    minus(arraybarang[i], i),
                                                child: new Icon(
                                                    const IconData(0xe15b,
                                                        fontFamily:
                                                            'MaterialIcons'),
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
        icon: Icon(Icons.save),
        label: Text(
          "Update",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
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
              "Mohon Ulangi pemilihan data, pastikan data ada yang dipilih"),
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
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => new GridLayoutRondo()),
              (Route<dynamic> route) => false,
            );
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
                  "${widget.list[widget.index]['Alamat']}",
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
                  "${widget.list[widget.index]['NamaPekerja']}",
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
                                DataCell(Text(data.jumlah)),
                                DataCell(Text(data.id_barang))
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

class EditPemesanan extends StatefulWidget {
  final List list;
  final int index;
  EditPemesanan({this.list, this.index});
  @override
  State<StatefulWidget> createState() {
    return EditPemesananRondo();
  }
}

class EditPemesananRondo extends State<EditPemesanan> {
  TextEditingController _controllerId;
  TextEditingController _controllerAlamat;
  TextEditingController _controllerPegawai;
  TextEditingController _controllerCatatan;
  var nama_pegawai_lama, id_pegawai_lama;
  @override
  void initState() {
    super.initState();
    getSWData();
    _controllerId = new TextEditingController(
        text: widget.list[widget.index]['id_pemesanan']);
    _controllerAlamat =
        new TextEditingController(text: widget.list[widget.index]['Alamat']);
    _controllerCatatan =
        new TextEditingController(text: widget.list[widget.index]['Catatan']);
    id_pegawai_lama = widget.list[widget.index]['id_pekerja'];
    nama_pegawai_lama = widget.list[widget.index]['NamaPekerja'];
  }

  String _mySelection;
  List _pekerja = List();
  List<DataPegawai> _caripekerja = [];
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

  void editData() {
    var nama_pegawai_baru, nama_pegawai, id_pegawai;
    for (int a = 0; a < _caripekerja.length; a++) {
      if (_mySelection == _caripekerja[a].id_pegawai) {
        nama_pegawai_baru = _caripekerja[a].Nama;
      }
    }
    if (_mySelection == null) {
      nama_pegawai = nama_pegawai_lama;
      id_pegawai = id_pegawai_lama;
    } else {
      nama_pegawai = nama_pegawai_baru;
      id_pegawai = _mySelection;
    }
    var url = "http://timothy.buzz/juljol/editdata.php";
    http.post(url, body: {
      "id_pemesanan": _controllerId.text,
      "id_pegawai": id_pegawai,
      "NamaPekerja": nama_pegawai,
      "Alamat": _controllerAlamat.text,
      "Catatan": _controllerCatatan.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(43, 40, 35, 1)),
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
                top: 150.0, left: 20.0, right: 20.0, bottom: 40),
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
            decoration: BoxDecoration(
                color: Color.fromRGBO(187, 111, 51, 1),
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
                        controller: _controllerId,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(labelText: "Id"),
                      ),
                      Divider(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _controllerAlamat,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(labelText: "Alamat"),
                      ),
                      Divider(
                        height: 50,
                      ),
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
                      Divider(
                        height: 50,
                      ),
                      TextField(
                          controller: _controllerCatatan,
                          maxLines: 4,
                          decoration:
                              new InputDecoration(labelText: "Catatan")),
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
          editData();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new GridLayoutRondo()),
            (Route<dynamic> route) => false,
          );
        },
        icon: Icon(Icons.save),
        label: Text(
          "Update",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
    );
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

class dataPass {
  final List dataBarang;
  dataPass(this.dataBarang);
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

class DataPegawai {
  String id_pegawai;
  String Nama;

  DataPegawai({this.id_pegawai, this.Nama});
  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(id_pegawai: json['id_pegawai'], Nama: json['Nama']);
  }
}
