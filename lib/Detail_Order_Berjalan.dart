import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/Detail_order_berjalan_lanjut.dart';
import 'package:juljol/detail.dart';
import './main.dart';


class DataDetail {
  String id_order;
  String id_pemesanan;
  String Alamat;
  String status;

  DataDetail({
    this.id_pemesanan,
    this.id_order,
    this.status,
    this.Alamat
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        id_order: json['id_order'],
        id_pemesanan: json['id_pemesanan'],
        status: json['status'],
        Alamat: json['ALamat']
    );
  }
}

class Detail_Order_berjalan extends StatefulWidget {
  List list;
  int index;
  Detail_Order_berjalan({this.index,this.list});
  @override
  Detail_Order_berjalanRondo createState() => new Detail_Order_berjalanRondo();
}

class Detail_Order_berjalanRondo extends State<Detail_Order_berjalan> {
  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  var siul,aqua,vit,gaskcl,gasbsr,vitgls,aquagls;

  void kirim(data){
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context)=> new Detail_order_berjalan_lanjut(id: data)
        )
    );
  }

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
    final response = await http.get("http://timothy.buzz/juljol/get_pemesanan_detail.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.id_order.contains(widget.list[widget.index]['id_order']))
          _searchDetails.add(dataDetail);
      });
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image : AssetImage("assets/androidmobile2.png"), fit: BoxFit.cover),),
        child: Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(top: 70.0, left: 25.0, right: 25.0),
                  child: Table(
                    border: TableBorder.all(width: 1.0,color: Colors.black),
                    children: [
                      TableRow(children: [
                        Text('Tanggal', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['Tanggal']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Waktu', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['Waktu']}", style: new TextStyle(fontSize: 25.0),),
                      ]),
                      TableRow(children: [
                        Text('Pengantar', style: new TextStyle(fontSize: 25.0),),
                        Text("${widget.list[widget.index]['pengantar']}", style: new TextStyle(fontSize: 25.0),),
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
                                  child: Container(
                                    color: Colors.blue,
                                    child: GestureDetector(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.only(left: 20.0),
                                                padding: const EdgeInsets.all(20.0),
                                                child: Text(_searchDetails[i].Alamat, style: TextStyle(fontSize: 30.0),),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                      onTap: (){
                                        kirim(_searchDetails[i].Alamat);
                                      }
                                    )
                                  ),
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

  }
}