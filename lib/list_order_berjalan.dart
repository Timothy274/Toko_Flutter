import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/Detail_Order_Berjalan.dart';
import 'package:juljol/main.dart';
import 'package:juljol/order.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';

class List_order_berjalan extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return list_order_berjalanRondo();
  }

}

class list_order_berjalanRondo extends State<List_order_berjalan> {
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
    final response = await http.get("http://timothy.buzz/juljol/get_pemesanan.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(43, 40, 35, 1)
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(187, 111, 51, 1),
                    borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                    ],
                  ),
                ),

                Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 30),
                      margin: const EdgeInsets.only(top: 50, left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(187, 111, 51, 1),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
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
                              return _currentpekerja == null || _currentpekerja == "" || _currentpekerja == 'Default'
                                  ? new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: new GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context)=> new Detail_Order_berjalan(list:snapshot.data , index: i,)
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
                                                  snapshot.data[i]['pengantar'],
                                                  style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.orange,
                                                size: 40.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                              )
                                  : snapshot.data[i]['pengantar'] == _currentpekerja
                                  ? new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: new GestureDetector(
                                  onTap: ()=>Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context)=> new Detail_Order_berjalan(list:snapshot.data , index: i,)
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
                                                  snapshot.data[i]['pengantar'],
                                                  style: TextStyle(fontSize: 25.0, color: Colors.orangeAccent),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(right: 10),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.orange,
                                                size: 40.0,
                                              ),
                                            )
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