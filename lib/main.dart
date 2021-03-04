import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juljol/Laporan.dart';
import 'package:juljol/list_order_berjalan.dart';
import 'package:juljol/pegawai.dart';
import 'package:juljol/stock.dart';
import 'package:juljol/user_profile.dart';
import './pemesanan.dart';
import './list_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

class GridLayoutRondo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GridLayout();
  }
}

class GridLayout extends State<GridLayoutRondo> {
  String nama = "";
  var userLogin;
  List<String> events = [
    "Order",
    "List",
    "On Going",
    "Report",
    "Pegawai",
    "Stock"
  ];
  Future cekuser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("username") != null) {
      setState(() {
        nama = pref.getString("username");
      });
    }
  }

  void initState() {
    super.initState();
    cekuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(43, 40, 35, 1)),
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 20),
                  padding: EdgeInsets.only(bottom: 20, top: 20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(187, 111, 51, 1),
                    borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 40.0, right: 40.0, bottom: 20),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  'Selamat Datang',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                alignment: Alignment(1.0, -1.0),
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new userDetail()));
                                      },
                                      child: Text(
                                        nama,
                                        style: new TextStyle(fontSize: 30.0),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: GridView(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3), //2 item dalam sebaris
                  children: events.map((title) {
                    return GestureDetector(
                      child: Container(
                        child: Card(
                          margin: const EdgeInsets.all(10.0),
                          child: getCardByTitle(title),
                          color: Color.fromRGBO(187, 111, 51, 1),
                        ),
                      ),
                      onTap: () {
                        if (title == "Order")
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pemesanan()));
                        else if (title == "List")
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => list()));
                        else if (title == "On Going")
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => List_order_berjalan()));
                        else if (title == "Report")
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Laporan()));
                        else if (title == "Pegawai")
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pegawai()));
                        else if (title == "Stock")
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Stock()));
                      },
                    );
                  }).toList(),
                )),
              ],
            )));
  }

  Column getCardByTitle(String title) {
    String img = "";
    if (title == "Order")
      img = "assets/baseline_playlist_add_black.png";
    else if (title == "List")
      img = "assets/baseline_list_black.png";
    else if (title == "On Going")
      img = "assets/baseline_hourglass_empty_black.png";
    else if (title == "Report")
      img = "assets/outline_assessment_black.png";
    else if (title == "Pegawai")
      img = "assets/outline_people_alt_black.png";
    else
      img = "assets/outline_store_black.png";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: Container(
              child: new Stack(
            children: <Widget>[
              new Image.asset(
                img,
                width: 50.0,
                height: 50.0,
              )
            ],
          )),
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(43, 40, 35, 1)),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
