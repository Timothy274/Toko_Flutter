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
  Future<List> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
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
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 170, left: 20.0, right: 20.0),
                      child: FutureBuilder<List>(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);
                          return snapshot.hasData
                              ? new ItemList(
                            list: snapshot.data,
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

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: new GestureDetector(
            onTap: ()=>Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (BuildContext context)=> new pegawaiList(list:list , index: i,)
                )
            ),
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['Nama'],
                  style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}