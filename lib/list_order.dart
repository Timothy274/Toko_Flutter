import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/order.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';

class list extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListRondo();
  }
}

class ListRondo extends State<list> {
  List _selectedId = List();
  List _selectedPekerja = List();
  List _selectedIdPekerja = List();
  String _mySelection1 = "Eko";
  String _mySelection2;
  List _pekerja = List(); //edited line
  TextEditingController controller = new TextEditingController();
  String filter;
  void initState() {
    super.initState();
    getSWData();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  Future<String> getSWData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_list_pegawai.php");
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
          content: new Text(
              "Mohon Ulangi pemilihan data, pastikan data yang dipilih meniliki pengirim yang sama"),
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
          content: new Text(
              "Mohon Ulangi pemilihan data, pastikan data yang dipilih meniliki pengirim yang sama"),
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

  void _onCategorySelected(
      bool selected, _searchId, _searchPekerja, _searchIdPekerja) {
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
    final response = await http.get("http://timothy.buzz/juljol/get.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(color: Color(0xffffff)),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(76, 177, 247, 1),
                    borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 40.0, right: 40.0, bottom: 20),
                          child: Text('List Pesanan',
                              style: TextStyle(fontSize: 40))),
                      new Container(
                        width: 270.0,
                        child: DropdownButton<String>(
                          items: _pekerja.map((item) {
                            return DropdownMenuItem<String>(
                              value: item['Nama'],
                              child: Text(item['Nama']),
                            );
                          }).toList(),
                          onChanged: (String newValueSelected) {
                            setState(() {
                              this._mySelection2 = newValueSelected;
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
                  margin:
                      const EdgeInsets.only(top: 50, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(76, 177, 247, 1),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      )),
                  child: FutureBuilder<List>(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? new ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return (_mySelection2 == null ||
                                        _mySelection2 == 'Semua')
                                    ? new Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: new GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .push(new MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          new Detail(
                                                            list: snapshot.data,
                                                            index: i,
                                                          ))),
                                          child: new Card(
                                              child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: new ListTile(
                                                    title: new Text(
                                                      snapshot.data[i]
                                                          ['Alamat'],
                                                      style: TextStyle(
                                                          fontSize: 25.0,
                                                          color: Colors.black),
                                                    ),
                                                    subtitle: new Text(
                                                      "Pengantar : ${snapshot.data[i]['NamaPekerja']}",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Checkbox(
                                                    value: _selectedId.contains(
                                                        snapshot.data[i]
                                                            ['id_pemesanan']),
                                                    onChanged: (bool selected) {
                                                      _onCategorySelected(
                                                          selected,
                                                          (snapshot.data[i]
                                                              ['id_pemesanan']),
                                                          (snapshot.data[i]
                                                              ['NamaPekerja']),
                                                          (snapshot.data[i]
                                                              ['id_pekerja']));
                                                    },
                                                  ),
                                                  alignment:
                                                      Alignment.centerRight,
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      )
                                    : (snapshot.data[i]['NamaPekerja'] ==
                                            _mySelection2)
                                        ? new Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: new GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .push(new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new Detail(
                                                            list: snapshot.data,
                                                            index: i,
                                                          ))),
                                              child: new Card(
                                                  child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: new ListTile(
                                                        title: new Text(
                                                          snapshot.data[i]
                                                              ['Alamat'],
                                                          style: TextStyle(
                                                              fontSize: 25.0,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        subtitle: new Text(
                                                          "Pengantar : ${snapshot.data[i]['NamaPekerja']}",
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20.0),
                                                      child: Checkbox(
                                                        value: _selectedId
                                                            .contains(snapshot
                                                                    .data[i][
                                                                'id_pemesanan']),
                                                        onChanged:
                                                            (bool selected) {
                                                          _onCategorySelected(
                                                              selected,
                                                              (snapshot.data[i][
                                                                  'id_pemesanan']),
                                                              (snapshot.data[i][
                                                                  'NamaPekerja']),
                                                              (snapshot.data[i][
                                                                  'id_pekerja']));
                                                        },
                                                      ),
                                                      alignment:
                                                          Alignment.centerRight,
                                                    ),
                                                  ],
                                                ),
                                              )),
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
                )),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          int b = 0;
          var p = _selectedIdPekerja.length;
          if (_selectedIdPekerja.isEmpty) {
            _showDialogerror();
          } else {
            for (int a = 0; a < p; a++) {
              if (_selectedIdPekerja[a] == _selectedIdPekerja[0]) {
                b++;
              }
            }
            if (b == p) {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Order(
                      list: _selectedId,
                      pekerja: _selectedPekerja[0],
                      idPegawai: _selectedIdPekerja[0])));
            } else {
              _showDialogPilihan();
            }
          }
        },
        icon: Icon(Icons.shopping_cart),
        label: Text(
          "Order",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
