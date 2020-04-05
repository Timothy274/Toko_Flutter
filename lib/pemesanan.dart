import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juljol/main.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';


class Pemesanan extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PemesananRondo();
  }

}

class Data {
  final String _alamat;
  final String _id;
  final String _pegawai;
  final String _catatan;

  Data(this._alamat, this._id, this._pegawai, this._catatan);
}

class PemesananRondo extends State<Pemesanan> {

  String _mySelection;

  List _pekerja = List(); //edited line

  Future<String> getSWData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJson = json.decode(response.body);

    setState(() {
      _pekerja = responseJson;
    });
  }

  var _barang =['Isi Ulang','Aqua'];
  var _banyak =['1','2','3','4','5','6','7','8','9','10'];
  var _currentbanyak='1';


//  int _currentPrice = 1;
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
      body: Container(
        child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 170.0, left: 20.0, right: 20.0,bottom: 100),
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: new BorderRadius.all(Radius.circular(40.0)),
              ),
              child: new Form(
                child: new Column(
                    children: <Widget>[
                      TextFormField(
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
                              value: item['Nama'],
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
                      TextField(
                        controller: catatan,
                          maxLines: 4,
                          decoration: new InputDecoration(labelText: "Catatan")
                      ),
                      Divider(
                          height: 50.0),
                      RaisedButton(

                        color: Colors.purple,
                        onPressed: (){

                            // set up the buttons
                            Widget cancelButton = FlatButton(
                              child: Text("Cancel"),
                              onPressed:  () {
                                Navigator.pop(context);
                              },
                            );
                            Widget continueButton = FlatButton(
                              child: Text("Continue"),
                              onPressed:  () {
                                _sendDataToSecondScreen(context);
                              },
                            );
                            String id = alamat.text+year+bulan+tanggal+jam+menit+detik;
                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: Text("AlertDialog"),

                              content: Text("Id anda "+id+"anda Tinggal di "+alamat.text+" diantar oleh "+_mySelection+""),

                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                        child: const Text(
                            'Buat Order',
                            style: TextStyle(
                                fontSize: 20)
                        ),
                      ),
                    ]),
              ),
            )
        ),
      ),
    );
  }
  void _sendDataToSecondScreen(BuildContext context) async {
    Data data = new Data(alamat.text, alamat.text+year+bulan+tanggal+jam+menit+detik,_mySelection,catatan.text);
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

  void _showDialogPilihan() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Data yang dipilih tidak sama"),
          content: new Text("Mohon Ulangi pemilihan data, pastikan data yang dipilih meniliki pengirim yang sama"),
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

  int _n1 = 0;
  int _n2 = 0;
  int _n3 = 0;
  int _n4 = 0;
  int _n5 = 0;
  int _n6 = 0;
  int _n7 = 0;

  void add1() {
    setState(() {
      _n1++;
    });
  }

  void minus1() {
    setState(() {
      if (_n1 != 0)
        _n1--;
    });
  }

  void add2() {
    setState(() {
      _n2++;
    });
  }

  void minus2() {
    setState(() {
      if (_n2 != 0)
        _n2--;
    });
  }

  void add3() {
    setState(() {
      _n3++;
    });
  }

  void minus3() {
    setState(() {
      if (_n3 != 0)
        _n3--;
    });
  }

  void add4() {
    setState(() {
      _n4++;
    });
  }

  void minus4() {
    setState(() {
      if (_n4 != 0)
        _n4--;
    });
  }

  void add5() {
    setState(() {
      _n5++;
    });
  }

  void minus5() {
    setState(() {
      if (_n5 != 0)
        _n5--;
    });
  }

  void add6() {
    setState(() {
      _n6++;
    });
  }

  void minus6() {
    setState(() {
      if (_n6 != 0)
        _n6--;
    });
  }

  void add7() {
    setState(() {
      _n7++;
    });
  }

  void minus7() {
    setState(() {
      if (_n7 != 0)
        _n7--;
    });
  }

  void initState(){
    super.initState();
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
      "Pekerja" : widget.data._pegawai,
      "Alamat": widget.data._alamat,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Stack(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(top: 190),
            child: Form(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      )
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Table(
                        children: [
                          TableRow(children: [
                            new Container(
                              margin: const EdgeInsets.only(left: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      "Isi Ulang",
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
                                            onPressed: add1,
                                            child: new Icon(Icons.add, color: Colors.black,),
                                            backgroundColor: Colors.white,),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text('$_n1',
                                              style: new TextStyle(fontSize: 40.0)),
                                        ),

                                        new Container(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            onPressed: minus1,
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
                            ),
                          ]),
                          TableRow(children: [
                            new Container(
                              margin: const EdgeInsets.only(top: 50.0,left: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      "Aqua",
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
                                            onPressed: add2,
                                            child: new Icon(Icons.add, color: Colors.black,),
                                            backgroundColor: Colors.white,),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text('$_n2',
                                              style: new TextStyle(fontSize: 40.0)),
                                        ),

                                        new Container(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            onPressed: minus2,
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
                            ),
                          ]),
                          TableRow(children: [
                            new Container(
                              margin: const EdgeInsets.only(top: 50.0, left: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      "Vit",
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
                                            onPressed: add3,
                                            child: new Icon(Icons.add, color: Colors.black,),
                                            backgroundColor: Colors.white,),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text('$_n3',
                                              style: new TextStyle(fontSize: 40.0)),
                                        ),

                                        new Container(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            onPressed: minus3,
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
                          ]),
                          TableRow(children: [
                            new Container(
                              margin: const EdgeInsets.only(top: 50.0, left: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      "Gas Kecil",
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
                                            onPressed: add4,
                                            child: new Icon(Icons.add, color: Colors.black,),
                                            backgroundColor: Colors.white,),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text('$_n4',
                                              style: new TextStyle(fontSize: 40.0)),
                                        ),

                                        new Container(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            onPressed: minus4,
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
                          ]),
                          TableRow(children: [
                            new Container(
                              margin: const EdgeInsets.only(top: 50.0, left: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      "Gas Besar",
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
                                            onPressed: add5,
                                            child: new Icon(Icons.add, color: Colors.black,),
                                            backgroundColor: Colors.white,),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text('$_n5',
                                              style: new TextStyle(fontSize: 40.0)),
                                        ),

                                        new Container(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            onPressed: minus5,
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
                          ]),
                          TableRow(children: [
                            new Container(
                              margin: const EdgeInsets.only(top: 50.0, left: 40.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      "Vit Gelas",
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
                                            onPressed: add6,
                                            child: new Icon(Icons.add, color: Colors.black,),
                                            backgroundColor: Colors.white,),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text('$_n6',
                                              style: new TextStyle(fontSize: 40.0)),
                                        ),

                                        new Container(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            onPressed: minus6,
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
                          ]),
                          TableRow(children: [
                            new Container(
                              margin: const EdgeInsets.only(top: 50.0, left: 40.0, bottom: 80),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    child: Text(
                                      "Aqua Gelas",
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
                                            onPressed: add7,
                                            child: new Icon(Icons.add, color: Colors.black,),
                                            backgroundColor: Colors.white,),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                          child: Text('$_n7',
                                              style: new TextStyle(fontSize: 40.0)),
                                        ),

                                        new Container(
                                          width: 40,
                                          height: 40,
                                          child: FloatingActionButton(
                                            onPressed: minus7,
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
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
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
              if(_n1 == 0 && _n2 == 0 && _n3 == 0 && _n4 == 0 && _n5 == 0 && _n6 == 0 && _n7 == 0){
                _showDialogPilihan();
              } else {
                addData();
                if (_n1 != 0){
                  var nama = "Siul";
                  var jumlah = _n1;
                  data(nama, jumlah);
                }
                if (_n2 != 0){
                  var nama = "Aqua";
                  var jumlah = _n2;
                  data(nama, jumlah);
                }
                if (_n3 != 0){
                  var nama = "Vit";
                  var jumlah = _n3;
                  data(nama, jumlah);
                }
                if (_n4 != 0){
                  var nama = "Gas_bsr";
                  var jumlah = _n4;
                  data(nama, jumlah);
                }
                if (_n5 != 0){
                  var nama = "Gas_kcl";
                  var jumlah = _n5;
                  data(nama, jumlah);
                }
                if (_n6 != 0){
                  var nama = "Vit_gls";
                  var jumlah = _n6;
                  data(nama, jumlah);
                }
                if (_n7 != 0){
                  var nama = "Aqua_gls";
                  var jumlah = _n7;
                  data(nama, jumlah);
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context)=> new GridLayoutRondo()),
                      (Route<dynamic> route) => false,
                );
              }
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
                Text("${widget.data._pegawai}", style: new TextStyle(fontSize: 25.0),),
              ]),
              TableRow(children: [
                Text('Catatan', style: new TextStyle(fontSize: 25.0),),
                Text("${widget.data._catatan}", style: new TextStyle(fontSize: 25.0),),
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
                        Text('Siul', style: new TextStyle(fontSize: 25.0),),
                        Text('$_n1', style: new TextStyle(fontSize: 25.0),),
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
