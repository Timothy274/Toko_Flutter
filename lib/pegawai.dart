import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/pegawai.dart';
import 'package:juljol/pegawai_list.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Pegawai extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PegawaiRondo();
  }
}

class PegawaiRondo extends State<Pegawai>{
  List _selectedPegawai = List();
  List _selectedNama = List();

  Future<List> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    return json.decode(response.body);
  }

  void _onCategorySelected(bool selected, _searchId, _searchNama) {
    if (selected == true) {
      setState(() {
        _selectedPegawai.add(_searchId);
        _selectedNama.add(_searchNama);
      });
    } else {
      setState(() {
        _selectedPegawai.remove(_searchId);
        _selectedNama.remove(_searchNama);
      });
    }
  }

  void absensi(hari, bulan, tahun){
    var url = "http://timothy.buzz/juljol/addabsensi.php";
    var p = _selectedPegawai.length;
    for (int a = 0; a < p;a++){
      http.post(url, body: {
        "id_pegawai": _selectedPegawai[a],
        "nama" : _selectedNama[a],
        "tanggal": hari,
        "bulan" : bulan,
        "tahun" : tahun
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 170, left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                          )
                      ),
                      child: FutureBuilder<List>(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? new ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return new Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new GestureDetector(
                                      onTap: ()=>Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context)=> new pegawaiList(list:snapshot.data , index: i,)
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
                                                      snapshot.data[i]['Nama'],
                                                      style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
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
                              )
                              : new Center(
                            child: new CircularProgressIndicator(),
                          );
                        },
                      ),
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}