import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/pegawai.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';

class DataDetail {
  String id_pemesanan;
  String Alamat;
  String Pekerja;

  DataDetail({
    this.id_pemesanan,
    this.Alamat,
    this.Pekerja,
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        id_pemesanan: json['id_pemesanan'],
        Alamat: json['Alamat'],
        Pekerja: json['Pekerja']
    );
  }
}

class pegawaiList extends StatefulWidget{
  List list;
  int index;
  pegawaiList({this.index,this.list});
  @override
  State<StatefulWidget> createState() {
    return pegawaiListRondo();
  }

}

class pegawaiListRondo extends State<pegawaiList> {
  List _selecteCategorys = List();
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];

  Future<List<DataDetail>> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.Pekerja.contains(widget.list[widget.index]['Nama']))
          _searchDetails.add(dataDetail);
      });

    });
  }

  void initState(){
    super.initState();
    getData();
  }

  void _onCategorySelected(bool selected, _searchDetails) {
    if (selected == true) {
      setState(() {
        _selecteCategorys.add(_searchDetails);
      });
    } else {
      setState(() {
        _selecteCategorys.remove(_searchDetails);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0, bottom: 20.0),
                  child: Card(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Icon(
                              Icons.account_circle,
                              size: 100,
                            ),
                          ),
                        ),
                        Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 50.0, bottom: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                  'Attendance'
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                  '10'
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                  'Performance'
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                  '10'
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 40),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            'Gaji',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          padding: const EdgeInsets.only(left: 40),
                          alignment: Alignment(-1.0,-1.0),
                          child: new Table(
                            children: [
                              TableRow(children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('Minggu', style: new TextStyle(fontSize: 30.0),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('4,0 Juta', style: new TextStyle(fontSize: 30.0),),
                                )
                              ]),
                              TableRow(children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('Bulan', style: new TextStyle(fontSize: 30.0),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('4,0 Juta', style: new TextStyle(fontSize: 30.0),),
                                )
                              ]),
                              TableRow(children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('Tahun', style: new TextStyle(fontSize: 30.0),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('4,0 Juta', style: new TextStyle(fontSize: 30.0),),
                                )
                              ]),
                            ],
                          ),
                        )
                      ],
                    )
                ),
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    margin: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 40),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            'More',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          alignment: Alignment(-1.0,-1.0),
                          child: new Table(
                            children: [
                              TableRow(children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('Gaji', style: new TextStyle(fontSize: 30.0),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: RaisedButton(
                                    color: Colors.orangeAccent,
                                    onPressed: (){

                                    },
                                    child: const Text(
                                        'Tinjau',
                                        style: TextStyle(fontSize: 20)
                                    ),
                                  )
                                )
                              ]),
                              TableRow(children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('Absen', style: new TextStyle(fontSize: 30.0),),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    child: RaisedButton(
                                      color: Colors.orangeAccent,
                                      onPressed: (){

                                      },
                                      child: const Text(
                                          'Tinjau',
                                          style: TextStyle(fontSize: 20)
                                      ),
                                    )
                                  )
                                ]),
                              TableRow(children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: Text('Akun', style: new TextStyle(fontSize: 30.0),),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(bottom: 25),
                                    child: RaisedButton(
                                      color: Colors.red,
                                      onPressed: (){

                                      },
                                      child: const Text(
                                          'Hapus', style: TextStyle(fontSize: 20)
                                      ),
                                    )
                                )
                              ]),
                            ],),
                        ),
                      ],
                    )
                ),
              ],
            ),
          )
        ],
      ),
    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context)=> new GridLayoutRondo()),
                (Route<dynamic> route) => false,
          );
        },
        icon: Icon(Icons.save),
        label: Text("Kirim"),
        backgroundColor: Colors.pink,
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
                    builder: (BuildContext context)=> new Detail(list:list , index: i,)
                )
            ),
            child: new Card(
              child: new ListTile(
                title: new Text(
                  list[i]['Alamat'],
                  style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
                ),
                subtitle: new Text(
                  "Pengantar : ${list[i]['Pekerja']}",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}