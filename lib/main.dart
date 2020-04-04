import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:juljol/Laporan.dart';
import 'package:juljol/list_order_berjalan.dart';
import 'package:juljol/pegawai.dart';
import './pemesanan.dart';
import './list_order.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';


void main() => runApp(
    MaterialApp(home:GridLayoutRondo())
);

class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}

class GridLayoutRondo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GridLayout();
  }

}

class GridLayout extends State<GridLayoutRondo> {

  List<String> events = [
    "Order",
    "List",
    "On Going",
    "Report",
    "Pegawai",
    "Stock"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/androidmobile2.png"), fit: BoxFit.cover),),

      child:Container(margin: const EdgeInsets.only(top: 170.0), // batas atas
          child: GridView(
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), //2 item dalam sebaris
            children: events.map((title) {
              return GestureDetector(
                child: Container(
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    child: getCardByTitle(title),
                    color: Colors.purple,
                  ),
                ),
                onTap: () {
                  if (title == "Order")
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => Pemesanan()));
                  else if (title == "List")
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => list()));
                  else if (title == "On Going")
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => List_order_berjalan()));
                  else if (title == "Report")
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => Laporan()));
                  else if (title == "Pegawai")
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => Pegawai()));
                },);
            }).toList(),
          )
      ),
    )
    );
  }

  Column getCardByTitle(String title) {
    String img = "";
    if (title == "Order")
      img = "assets/calendar.png";
    else if (title == "List")
      img = "assets/family_time.png";
    else if (title == "On Going")
      img = "assets/friends.png";
    else if (title == "Report")
      img = "assets/lovely_time.png";
    else if (title == "Pegawai")
      img = "assets/me_time.png";
    else
      img = "assets/team_time.png";

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
        ), Text(
          title,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
