import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/pegawai.dart';
import 'package:juljol/pegawai_list.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';

class Pegawai extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return PegawaiRondo();
  }
}

class PegawaiRondo extends State<Pegawai>{
  List _selectedId = List();

  Future<List> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    return json.decode(response.body);
  }

  void _onCategorySelected(bool selected, _searchId) {
    if (selected == true) {
      setState(() {
        _selectedId.add(_searchId);

      });
    } else {
      setState(() {
        _selectedId.remove(_searchId);
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
                                                Container(
                                                  margin: const EdgeInsets.only(right: 20.0),
                                                  child: Checkbox(
                                                    value: _selectedId.contains(snapshot.data[i]['id_pegawai']),
                                                    onChanged: (bool selected){
                                                      _onCategorySelected(selected, (snapshot.data[i]['id_pegawai']));
                                                    },
                                                  ),
                                                  alignment: Alignment.centerRight,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

        },
        icon: Icon(Icons.save),
        label: Text("Absensi"),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}