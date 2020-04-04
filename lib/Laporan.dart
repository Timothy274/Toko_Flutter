import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/order.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class Laporan extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LaporanRondo();
  }

}

class LaporanRondo extends State<Laporan> {
  var _pekerja =['Default','Eko','Wahyu'];
  var _currentpekerja='Default';
  List _selectedId = List();
  List _selectedPekerja = List();

  TextEditingController controller = new TextEditingController();
  String filter;

  void initState(){
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
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

  void _onCategorySelected(bool selected, _searchId, _searchPekerja) {
    if (selected == true) {
      setState(() {
        _selectedId.add(_searchId);
        _selectedPekerja.add(_searchPekerja);

      });
    } else {
      setState(() {
        _selectedId.remove(_searchId);
        _selectedPekerja.remove(_searchPekerja);
      });
    }
  }

  Future<List> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image : AssetImage("assets/androidmobile2.png"), fit: BoxFit.cover),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:20, left:40.0, right: 40.0, bottom: 20),
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
                          items: _pekerja.map((String dropDownStringItem){
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._currentpekerja = newValueSelected;
                            });
                          },
                          value: _currentpekerja,
                        ),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(top: 20),
                          width: 270,
                        child: RaisedButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2020, 3, 5),
                                  maxTime: DateTime(2080, 6, 7), onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                  }, currentTime: DateTime.now(), locale: LocaleType.id);
                            },
                          child: const Text(
                              'Tanggal',
                              style: TextStyle(fontSize: 20)
                          ),
                        )
                      ),
                    ],
                  ),
                ),

                Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 60),
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: FutureBuilder<List>(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? new ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return _currentpekerja == null || _currentpekerja == "" || _currentpekerja == 'Default'
                                  ? new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: new GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context)=> new Detail(list:snapshot.data , index: i,)
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
                                                  snapshot.data[i]['Alamat'],
                                                  style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
                                                ),
                                                subtitle: new Text(
                                                  "Pengantar : ${snapshot.data [i]['Pekerja']}",
                                                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(right: 20.0),
                                              child: Checkbox(
                                                value: _selectedId.contains(snapshot.data[i]['id_pemesanan']),
                                                onChanged: (bool selected){
                                                  _onCategorySelected(selected, (snapshot.data[i]['id_pemesanan']), snapshot.data[i]['Pekerja']);
                                                },
                                              ),
                                              alignment: Alignment.centerRight,
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              )
                                  : snapshot.data[i]['Pekerja'] == _currentpekerja
                                  ? new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: new GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context)=> new Detail(list:snapshot.data , index: i,)
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
                                                  snapshot.data[i]['Alamat'],
                                                  style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
                                                ),
                                                subtitle: new Text(
                                                  "Pengantar : ${snapshot.data [i]['Pekerja']}",
                                                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(right: 20.0),
                                              child: Checkbox(
                                                value: _selectedId.contains(snapshot.data[i]['id_pemesanan']),
                                                onChanged: (bool selected){
                                                  _onCategorySelected(selected, (snapshot.data[i]['id_pemesanan']), snapshot.data[i]['Pekerja']);
                                                },
                                              ),
                                              alignment: Alignment.centerRight,
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
