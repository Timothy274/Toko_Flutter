import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/order.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';

class order_selesai extends StatefulWidget{
  String month;
  order_selesai({this.month});
  @override
  State<StatefulWidget> createState() {
    return order_selesaiRondo();
  }

}

class order_selesaiRondo extends State<order_selesai> {
  List _selectedId = List();
  List _selectedPekerja = List();
  List _selectedIdPekerja = List();
  String _mySelection1 = "Eko";
  String _mySelection2;
  List _pekerja = List();
  List<DataSaw> _dataDetails = [];
  List<DataSaw> _searchDetails= [];

  String bulan = '00';

  TextEditingController controller = new TextEditingController();
  String filter;

  void initState(){
    super.initState();
    getData();
    getSWData();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  Future<String> getSWData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_list_pegawai.php");
    final responseJson = json.decode(response.body);

    setState(() {
      _pekerja = responseJson;
    });
  }

  void _showDialogerror() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Tidak ada data yang di pilih"),
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

  void _onCategorySelected(bool selected, _searchId, _searchPekerja, _searchIdPekerja) {
    if (selected == true) {
      setState(() {
        _selectedId.add(_searchId);
        _selectedIdPekerja.add(_searchIdPekerja);
        _selectedPekerja.add(_searchPekerja);

      });
    } else {
      setState(() {
        _selectedId.remove(_searchId);
        _selectedIdPekerja.remove(_searchIdPekerja);
        _selectedPekerja.remove(_searchPekerja);
      });
    }
  }

  Future<List> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pemesanan_detail_join_pemesanan.php");
    final responseJson = json.decode(response.body);

    setState((){
      for (Map Data in responseJson){
        _dataDetails.add(DataSaw.fromJson(Data));
      }
      _dataDetails.forEach((a) {
        var tanggal = a.Tanggal;
        var _bulan = tanggal.substring(5,7);
        if (widget.month == 'Jan'){
          bulan = '01';
        } else if (widget.month == 'Feb'){
          bulan = '02';
        } else if (widget.month == 'Mar'){
          bulan = '03';
        } else if (widget.month == 'Apr'){
          bulan = '04';
        } else if (widget.month == 'Mei'){
          bulan = '05';
        } else if (widget.month == 'Jun'){
          bulan = '06';
        } else if (widget.month == 'Jul'){
          bulan = '07';
        } else if (widget.month == 'Aug'){
          bulan = '08';
        } else if (widget.month == 'Sep'){
          bulan = '09';
        } else if (widget.month == 'Okt'){
          bulan = '10';
        } else if (widget.month == 'Nov'){
          bulan = '11';
        } else if (widget.month == 'Des'){
          bulan = '12';
        }
        if (_bulan == bulan){
          _searchDetails.add(a);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                padding: EdgeInsets.only(bottom: 20, top: 10),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:20, left:20.0, right: 20.0, bottom: 10),
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                        controller: controller,
                      ),
                    ),
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
                            this._mySelection2 = newValueSelected;
                            print(_mySelection2);
                          });
                        },
                        hint: Text('Pegawai'),
                        value: _mySelection2,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    margin: const EdgeInsets.only(top: 20, left: 10.0, right: 10.0),
                    child: new ListView.builder(
                      itemCount: _searchDetails.length,
                      itemBuilder: (context, i) {
                        return (_mySelection2 == null && filter == null ||
                            (_mySelection2 == "" && filter == null) ||
                            (_mySelection2 == "Semua" && filter == null))
                            ? new Container(
                          padding: const EdgeInsets.all(10.0),
                          child: new GestureDetector(
                            onTap: ()=>Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context)=> new Detail()
                                )
                            ),
                            child: new Card(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: new ListTile(
                                          title: new Text(
                                            _searchDetails[i].ALamat,
                                            style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
                                          ),
                                          subtitle: new Text(
                                            "Pengantar : ${_searchDetails[i].pengantar}",
                                            style: TextStyle(fontSize: 20.0, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        )
                            : new Container();
                      },
                    )
                  )
              ),
            ],
          )
      ),
    );
  }
}

class DataSaw {
  String id_pemesanan;
  String Tanggal;
  String pengantar;
  String ALamat;


  DataSaw({
    this.id_pemesanan,
    this.Tanggal,
    this.pengantar,
    this.ALamat,
  });

  factory DataSaw.fromJson(Map<String, dynamic> json) {
    return DataSaw(
        id_pemesanan: json['id_pemesanan'],
        Tanggal: json['Tanggal'],
        pengantar: json['pengantar'],
        ALamat: json['ALamat']
    );
  }
}
