import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/main.dart';
import 'package:juljol/order.dart';
import 'package:juljol/tambah_user.dart';
import './detail.dart';
import './user_profile.dart';
import './edit_user.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class admin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return adminRondo();
  }
}

class adminRondo extends State<admin> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController controller = new TextEditingController();
  String filter;
  void initState() {
    super.initState();
  }

  Future<List> getData() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_user_without_admin.php");
    return json.decode(response.body);
  }

  void _onRefresh() async {
// monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
// if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
// monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
// if failed,use loadFailed(),if no data return,use LoadNodata()
    setState(() {
      getData();
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SmartRefresher(
        enablePullUp: true,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Container(
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
                                top: 20, left: 70.0, right: 70.0, bottom: 10),
                            child: Text('List User',
                                style: TextStyle(fontSize: 40))),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => userDetail()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 10.0, left: 20, right: 20),
                            alignment: Alignment(1.0, -1.0),
                            child: Icon(
                              Icons.settings,
                              size: 24.0,
                            ),
                          ),
                        )
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
                                  return Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: new GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new userEdit(
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
                                                  snapshot.data[i]['Username'],
                                                  style: TextStyle(
                                                      fontSize: 25.0,
                                                      color: Colors.black),
                                                ),
                                                subtitle: new Text(
                                                  snapshot.data[i]['Email'],
                                                  style: TextStyle(
                                                      fontSize: 20.0,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new tambahuser()));
        },
        icon: Icon(Icons.add),
        label: Text(
          "Add",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(76, 177, 247, 1),
      ),
    );
  }
}
