import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/list_order.dart';
import './main.dart';

class dataPass {
  final String _siul;
  final String _aqua;
  final String _vit;
  final String _gasbsr;
  final String _gaskcl;
  final String _vitgls;
  final String _aquagls;

  dataPass(this._siul, this._aqua, this._vit, this._gasbsr, this._gaskcl, this._vitgls, this._aquagls);
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
  var siul,aqua,vit,gaskcl,gasbsr,vitgls,aquagls;

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
    for (var i = 0;i < _searchDetails.length;i++){
      if (_searchDetails[i].Barang == "Siul"){
        siul = _searchDetails[i].Jumlah;
      }
      else if (_searchDetails[i].Barang == "Aqua"){
        aqua = _searchDetails[i].Jumlah;
      }
      else if (_searchDetails[i].Barang == "Vit"){
        vit = _searchDetails[i].Jumlah;
      }
      else if (_searchDetails[i].Barang == "Gas_kcl"){
        gaskcl = _searchDetails[i].Jumlah;
      }
      else if (_searchDetails[i].Barang == "Gas_bsr"){
        gasbsr = _searchDetails[i].Jumlah;
      }
      else if (_searchDetails[i].Barang == "Vit_gls"){
        vitgls = _searchDetails[i].Jumlah;
      }
      else if (_searchDetails[i].Barang == "Aqua_gls"){
        aquagls = _searchDetails[i].Jumlah;
      }
    }
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      color: Colors.orange,
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
                        Text("${widget.list[widget.index]['Pekerja']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Alamat', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['Alamat']}", style: new TextStyle(fontSize: 25.0),),
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
                              color: Colors.orange,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(left: 20.0),
                                          child: Text(_searchDetails[i].Barang, style: TextStyle(fontSize: 30.0),),
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
    dataPass data = new dataPass(siul, aqua, vit, gasbsr, gaskcl, vitgls, aquagls);
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

  String siul,aqua,vit,gaskcl,gasbsr,vitgls,aquagls;
  int _n1,_n2,_n3,_n4,_n5,_n6,_n7;

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
  @override
  void initState(){
    super.initState();
    siul = widget.data._siul;
    aqua = widget.data._aqua;
    vit = widget.data._vit;
    gaskcl = widget.data._gaskcl;
    gasbsr = widget.data._gasbsr;
    vitgls = widget.data._vitgls;
    aquagls = widget.data._aquagls;

    if(siul != null){
      _n1 = int.parse(siul);
    } else {
      _n1 = 0;
    }

    if(aqua != null){
      _n2 = int.parse(aqua);
    } else {
      _n2 = 0;
    }

    if(vit != null){
      _n3 = int.parse(vit);
    } else {
      _n3 = 0;
    }

    if(gaskcl != null){
      _n4 = int.parse(gaskcl);
    } else {
      _n4 = 0;
    }

    if(gasbsr != null){
      _n5 = int.parse(gasbsr);
    } else {
      _n5 = 0;
    }

    if(vitgls != null){
      _n6 = int.parse(vitgls);
    } else {
      _n6 = 0;
    }

    if(aquagls != null){
      _n7 = int.parse(aquagls);
    } else {
      _n7 = 0;
    }
  }

  void update(nama, jumlah){
    String Barang = nama.toString();
    String Total = jumlah.toString();
//    print(Barang);
//    print(Total);
    var url="http://timothy.buzz/juljol/update_detail.php";
    http.post(url, body: {
      "id_pemesanan" : widget.list[widget.index]['id_pemesanan'],
      "Barang": Barang,
      "Jumlah": Total  ,
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Stack(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(bottom: 80, top:90),
            child: Form(
              child: SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
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
                                        heroTag: null,
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
                                        heroTag: null,
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
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(top: 50.0, left: 40.0),
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
                                        heroTag: null,
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
                                        heroTag: null,
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
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
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
                                        heroTag: null,
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
                                        heroTag: null,
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
                      ],
                    ),
                    new Row(
                      children: <Widget>[
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
                                        heroTag: null,
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
                                        heroTag: null,
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
                      ],
                    ),
                    new Row(
                      children: <Widget>[
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
                                        heroTag: null,
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
                                        heroTag: null,
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
                      ],
                    ),
                    new Row(
                      children: <Widget>[
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
                                        heroTag: null,
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
                                        heroTag: null,
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
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Container(
                          margin: const EdgeInsets.only(top: 50.0, left: 40.0),
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
                                        heroTag: null,
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
                                        heroTag: null,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "tambah",
        onPressed: () {
          if (_n1 != null){
            var nama = "Siul";
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context)=> new GridLayoutRondo()),
                (Route<dynamic> route) => false,
          );
        },
        icon: Icon(Icons.save),
        label: Text("Save"),
        backgroundColor: Colors.pink,
      ),
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
        body: Container(
          margin: const EdgeInsets.only(top: 150.0, left: 20.0, right: 20.0),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
          decoration: BoxDecoration(
            color: Colors.orange,
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