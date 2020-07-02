import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/list_order.dart';
import './main.dart';


class Detail extends StatefulWidget {
  List list;
  int index;
  Detail({this.index,this.list});
  @override
  _DetailState createState() => new _DetailState();
}

class _DetailState extends State<Detail> {
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  var siulA,siulB,aqua,vit,gaskcl,gasbsr,vitgls,aquagls;
  List<String> id_barang = List<String>();
  List<String> nilai_awal = List<String>();
  List<DataBarang> _dataBarang = [];
  List<String> array_barang = [];

  void deleteData(){
    var url="http://timothy.buzz/juljol/delete.php";
    http.post(url, body: {
      'id_pemesanan': widget.list[widget.index]['id_pemesanan']
    });
  }

  void deleteDataDetail(){
    var url="http://timothy.buzz/juljol/delete_detail.php";
    http.post(url, body: {
      'id_pemesanan': widget.list[widget.index]['id_pemesanan']
    });
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
            deleteData();
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

  Future<List<DataBarang>> getDataDetail() async {
    final responseB = await http.get("http://timothy.buzz/juljol/get_barang.php");
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
    final response = await http.get("http://timothy.buzz/juljol/get_detail.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.id_pemesanan.contains(widget.list[widget.index]['id_pemesanan']))
          _searchDetails.add(dataDetail);
      });
    });
  }

  void Detail_Barang(){
    int awal, akhir;
    String num;
    for (var i = 0;i < _searchDetails.length;i++){
      for( var o = 0; o < id_barang.length;o++){
        if( _searchDetails[i].Nama == id_barang[o]){
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
                        Text('Pengantar', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['NamaPekerja']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Alamat', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['Alamat']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Catatan', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['Catatan']}", style: new TextStyle(fontSize: 25.0),),
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
                            return Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Color.fromRGBO(187, 111, 51, 1),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(left: 20.0),
                                          child: Text(_searchDetails[i].Nama, style: TextStyle(fontSize: 30.0),),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 20.0),
                                      child: Text(_searchDetails[i].Jumlah, style: TextStyle(fontSize: 50.0),),
                                      alignment: Alignment.centerRight,
                                    ),
                                  ],
                                ),
                              )
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
                      margin: const EdgeInsets.all(20.0),
                      child: RaisedButton(
                        onPressed: () {
                          Detail_Barang();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => _accDialog(context),
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
              onPressed: ()=>Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context)=>new EditPemesanan(list: widget.list, index: widget.index, ),
                  )
              ),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
          ),
          new OutlineButton(
              child: new Text("Ubah Pesanan"),
              onPressed: (){
                pass_data(context);
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
          )
        ],
      ),
    );
  }

  void pass_data(BuildContext context) async {
    dataPass data = new dataPass(array_barang);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrderan(list: widget.list, index: widget.index, data: data)
      )
    );
  }
}

class EditOrderan extends StatefulWidget{
  final List list;
  final int index;
  final dataPass data;

  EditOrderan({this.list, this.index, this.data});
  @override
  State<StatefulWidget> createState() {
    return EditOderanRondo();
  }
}

class EditOderanRondo extends State<EditOrderan>{

  String siulA,siulB,aqua,vit,gaskcl,gasbsr,vitgls,aquagls;
  int _n1,_n2,_n3,_n4,_n5,_n6,_n7,_n8;
  List <String> arraybarang = List<String>();

  List<DataBarang> _dataBarang = [];
  List<String> nilai_awal = List<String>();


  @override
  void initState(){
    super.initState();
    arraybarang = widget.data.dataBarang;
    getDataDetail();
  }

  void update(nama, jumlah){
    String Barang = nama.toString();
    String Total = jumlah.toString();
    var url="http://timothy.buzz/juljol/update_detail.php";
    http.post(url, body: {
      "id_pemesanan" : widget.list[widget.index]['id_pemesanan'],
      "Barang": Barang,
      "Jumlah": Total  ,
    });
  }

  Future<List<DataBarang>> getDataDetail() async {
    final responseB = await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonB = json.decode(responseB.body);

    setState(() {
      for (Map Data in responseJsonB) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
    });
  }

  void add(array, i){
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

  void minus(array, i){
    setState(() {
      int num, awal, akhir;
      num = int.parse(array);
      if (num != 0 ){
        num--;
        String angka = num.toString();
        awal = i;
        akhir = awal + 1;
        arraybarang.replaceRange(awal, akhir, [angka]);
      }
    });
  }


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
                          itemCount: _dataBarang .length,
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
                                                onPressed: () => add(arraybarang[i],i),
                                                child: new Icon(Icons.add, color: Colors.black,),
                                                backgroundColor: Colors.white,),
                                            ),

                                            new Container(
                                              margin: const EdgeInsets.only(left: 10, right: 10),
                                              child: Text(arraybarang[i],
                                                  style: new TextStyle(fontSize: 40.0)),
                                            ),

                                            new Container(
                                              width: 40,
                                              height: 40,
                                              child: FloatingActionButton(
                                                heroTag: null,
                                                onPressed: () => minus(arraybarang[i],i),
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
        heroTag: "tambah",
        onPressed: () {
          if(_n1 == 0 && _n2 == 0 && _n3 == 0 && _n4 == 0 && _n5 == 0 && _n6 == 0 && _n7 == 0 && _n8 == 0){
            _showDialogPilihan();
          } else {
            if (_n1 != null){
              var nama = "SiulA";
              var jumlah = _n1;
              update(nama, jumlah);
            }
            if (_n2 != null){
              var nama = "Aqua";
              var jumlah = _n2;
              update(nama, jumlah);
            }
            if (_n3 != null){
              var nama = "Vit";
              var jumlah = _n3;
              update(nama, jumlah);
            }
            if (_n4 != null){
              var nama = "Gas_bsr";
              var jumlah = _n4;
              update(nama, jumlah);
            }
            if (_n5 != null){
              var nama = "Gas_kcl";
              var jumlah = _n5;
              update(nama, jumlah);
            }
            if (_n6 != null){
              var nama = "Vit_gls";
              var jumlah = _n6;
              update(nama, jumlah);
            }
            if (_n7 != null){
              var nama = "Aqua_gls";
              var jumlah = _n7;
              update(nama, jumlah);
            }
            if (_n8 != null){
              var nama = "SiulB";
              var jumlah = _n7;
              update(nama, jumlah);
            }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context)=> new GridLayoutRondo()),
                  (Route<dynamic> route) => false,
            );
          }
        },
        icon: Icon(Icons.save),
        label: Text("Save"),
        backgroundColor: Colors.pink,
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

}

class EditPemesanan extends StatefulWidget{
  final List list;
  final int index;

  EditPemesanan({this.list, this.index});
  @override
  State<StatefulWidget> createState() {
    return EditPemesananRondo();
  }
}

class EditPemesananRondo extends State<EditPemesanan>{
  TextEditingController _controllerId;
  TextEditingController _controllerAlamat;
  TextEditingController _controllerPegawai;
  TextEditingController _controllerCatatan;

  @override
  void initState() {
    super.initState();
    _controllerId = new TextEditingController(text:  widget.list[widget.index]['id_pemesanan']);
    _controllerAlamat = new TextEditingController(text:  widget.list[widget.index]['Alamat']);
    _controllerPegawai = new TextEditingController(text:  widget.list[widget.index]['Pekerja']);
  }

  void editData(){
    var url="http://timothy.buzz/juljol/editdata.php";
    http.post(url, body: {
      "id_pemesanan": _controllerId.text,
      "Pekerja": _controllerPegawai.text,
      "Alamat": _controllerAlamat.text,
    });
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
                margin: const EdgeInsets.only(top: 150.0, left: 20.0, right: 20.0),
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(187, 111, 51, 1),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                    )
                ),
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
                          TextFormField(
                            controller: _controllerPegawai,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(labelText: "Pegawai"),
                          ),
                          Divider(
                            height: 50,
                          ),
                          TextField(
                              controller: _controllerCatatan,
                              maxLines: 4,
                              decoration: new InputDecoration(labelText: "Catatan")
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          editData();
          Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (BuildContext context)=>new GridLayoutRondo()
              )
          );
        },
        icon: Icon(Icons.save),
        label: Text("Update"),
        backgroundColor: Colors.pink,
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

class dataPass {
  final List dataBarang;

  dataPass(this.dataBarang);
}

class DataDetail {
  String id_pemesanan;
  String Barang;
  String Jumlah;
  String Nama;

  DataDetail({
    this.id_pemesanan,
    this.Barang,
    this.Jumlah,
    this.Nama,
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        id_pemesanan: json['id_pemesanan'],
        Barang: json['Barang'],
        Jumlah: json['Jumlah'],
        Nama: json['Nama']
    );
  }
}