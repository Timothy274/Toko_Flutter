import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/pegawai_list.dart';
import 'package:juljol/new_pegawai.dart';
import 'dart:async';
import 'dart:convert';

class Pegawai extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PegawaiRondo();
  }
}

class PegawaiRondo extends State<Pegawai> {
  List _selectedPegawai = List();
  List _selectedNama = List();

  Future<List> getData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_pegawai_except.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Color(0xffffff),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                  margin:
                      const EdgeInsets.only(top: 170, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(76, 177, 247, 1),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                      )),
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
                                    onTap: () => Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new pegawaiList(
                                                  list: snapshot.data,
                                                  index: i,
                                                ))),
                                    child: new Card(
                                        child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: new ListTile(
                                              title: new Text(
                                                snapshot.data[i]['Nama'],
                                                style: TextStyle(
                                                    fontSize: 25.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ),
                                );
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new newpegawai()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
