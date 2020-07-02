import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:juljol/bonus.dart';
import 'package:juljol/gaji.dart';
import 'package:juljol/main.dart';
import 'package:juljol/pegawai.dart';
import './detail.dart';
import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';


class DataDetail {
  String Tanggal;
  String Nama;
  String Jumlah;
  String Alamat;

  DataDetail({
    this.Tanggal,
    this.Nama,
    this.Jumlah,
    this.Alamat
  });

  factory DataDetail.fromJson(Map<String, dynamic> json) {
    return DataDetail(
        Tanggal: json['Tanggal'],
        Nama: json['pengantar'],
        Jumlah: json['Jumlah'],
        Alamat: json['ALamat']
    );
  }
}

class DataPegawai {
  String Nama;
  String Bonus_Barang;
  String Bonus_Absen;

  DataPegawai({
    this.Nama,
    this.Bonus_Barang,
    this.Bonus_Absen
  });

  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        Nama: json['Nama'],
        Bonus_Barang: json['Bonus_Barang'],
        Bonus_Absen: json['Bonus_Absen']
    );
  }
}

class Penjualan{
  final String day;
  final int sold;

  Penjualan(this.day,this.sold);
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
  String _day = 'Bulan';
  String _pendapatan = '0';

  List<DataDetail> _dataDetails = [];
  List<DataDetail> _searchDetails = [];
  List<DataPegawai> _dataPegawai = [];
  List<DataPegawai> _searchDataPegawai = [];

  List<String> Jan = [];
  List<String> Feb = [];
  List<String> Mar = [];
  List<String> Apr = [];
  List<String> Mei = [];
  List<String> Jun = [];
  List<String> Jul = [];
  List<String> Aug = [];
  List<String> Sep = [];
  List<String> Okt = [];
  List<String> Nov = [];
  List<String> Des = [];

  List<String> _Jan = [];
  List<String> _Feb = [];
  List<String> _Mar = [];
  List<String> _Apr = [];
  List<String> _Mei = [];
  List<String> _Jun = [];
  List<String> _Jul = [];
  List<String> _Aug = [];
  List<String> _Sep = [];
  List<String> _Okt = [];
  List<String> _Nov = [];
  List<String> _Des = [];

  List<String> Jan_ = [];
  List<String> Feb_ = [];
  List<String> Mar_ = [];
  List<String> Apr_ = [];
  List<String> Mei_ = [];
  List<String> Jun_ = [];
  List<String> Jul_ = [];
  List<String> Aug_ = [];
  List<String> Sep_ = [];
  List<String> Okt_ = [];
  List<String> Nov_ = [];
  List<String> Des_ = [];

  int Absensi = 0;

  String Gaji = '0';

  Future<List<DataDetail>> getData() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pemesanan_join_odr_msk_detail.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataDetail.fromJson(Data));
      }
      _dataDetails.forEach((dataDetail) {
        if (dataDetail.Nama.contains(widget.list[widget.index]['Nama']))
          _searchDetails.add(dataDetail);
      });
      var p = _searchDetails.length;
      for (int i = 0;i < p;i++){
        var bulan = _searchDetails[i].Tanggal;
        var _bulan = bulan.substring(5,7);
        if (_bulan == '01'){
          Jan.add(_searchDetails[i].Alamat);
          _Jan.add(_searchDetails[i].Tanggal);
          Jan_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '02'){
          Feb.add(_searchDetails[i].Alamat);
          _Feb.add(_searchDetails[i].Tanggal);
          Feb_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '03'){
          Mar.add(_searchDetails[i].Alamat);
          _Mar.add(_searchDetails[i].Tanggal);
          Mar_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '04'){
          Apr.add(_searchDetails[i].Alamat);
          _Apr.add(_searchDetails[i].Tanggal);
          Apr_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '05'){
          Mei.add(_searchDetails[i].Alamat);
          _Mei.add(_searchDetails[i].Tanggal);
          Mei_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '06'){
          Jun.add(_searchDetails[i].Alamat);
          _Jun.add(_searchDetails[i].Tanggal);
          Jun_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '07'){
          Jul.add(_searchDetails[i].Alamat);
          _Jul.add(_searchDetails[i].Tanggal);
          Jul_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '08'){
          Aug.add(_searchDetails[i].Alamat);
          _Aug.add(_searchDetails[i].Tanggal);
          Aug_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '09'){
          Sep.add(_searchDetails[i].Alamat);
          _Sep.add(_searchDetails[i].Tanggal);
          Sep_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '10'){
          Okt.add(_searchDetails[i].Alamat);
          _Okt.add(_searchDetails[i].Tanggal);
          Okt_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '11'){
          Nov.add(_searchDetails[i].Alamat);
          _Nov.add(_searchDetails[i].Tanggal);
          Nov_.add(_searchDetails[i].Jumlah);
        } else if (_bulan == '12'){
          Des.add(_searchDetails[i].Alamat);
          _Des.add(_searchDetails[i].Tanggal);
          Des_.add(_searchDetails[i].Jumlah);
        }
      }
      Jan = Jan.toSet().toList();
      Feb = Feb.toSet().toList();
      Mar = Mar.toSet().toList();
      Apr = Apr.toSet().toList();
      Mei = Mei.toSet().toList();
      Jun = Jun.toSet().toList();
      Jul = Jul.toSet().toList();
      Aug = Aug.toSet().toList();
      Sep = Sep.toSet().toList();
      Okt = Okt.toSet().toList();
      Nov = Nov.toSet().toList();
      Des = Des.toSet().toList();

      _Jan = _Jan.toSet().toList();
      _Feb = _Feb.toSet().toList();
      _Mar = _Mar.toSet().toList();
      _Apr = _Apr.toSet().toList();
      _Mei = _Mei.toSet().toList();
      _Jun = _Jun.toSet().toList();
      _Jul = _Jul.toSet().toList();
      _Aug = _Aug.toSet().toList();
      _Sep = _Sep.toSet().toList();
      _Okt = _Okt.toSet().toList();
      _Nov = _Nov.toSet().toList();
      _Des = _Des.toSet().toList();
    });
  }

  Future<List<DataDetail>> getPegawai() async {
    final response = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJson = json.decode(response.body);

    setState(() {
      for (Map Data in responseJson) {
        _dataPegawai.add(DataPegawai.fromJson(Data));
      }
      _dataPegawai.forEach((dataDetail) {
        if (dataDetail.Nama.contains(widget.list[widget.index]['Nama']))
          _searchDataPegawai.add(dataDetail);
      });
    });
  }


  void initState(){
    super.initState();
    getData();
    getPegawai();
  }



  void _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var day;
    final measures = <String, num>{};
    List jumlah = [];
    int kalkulasi = 0;

    if (selectedDatum.isNotEmpty) {
      day = selectedDatum.first.datum.day;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sold;
      });
    }

    // Request a build.
    setState(() {
      _day = day;
      measures?.forEach((String series, num value) {
        _pendapatan = value.toString();
      });
      if(_day == 'Jan'){
        Absensi = _Jan.length;
        jumlah = Jan_;
      } else if (_day == 'Feb'){
        Absensi = _Feb.length;
        jumlah = Feb_;
      } else if (_day == 'Mar'){
        Absensi = _Mar.length;
        jumlah = Mar_;
      } else if (_day == 'Apr'){
        Absensi = _Apr.length;
        jumlah = Apr_;
      } else if (_day == 'Mei'){
        Absensi = _Mei.length;
        jumlah = Mei_;
      } else if (_day == 'Jun'){
        Absensi = _Jun.length;
        jumlah = Jun_;
      } else if (_day == 'Jul'){
        Absensi = _Jul.length;
        jumlah = Jul_;
      } else if (_day == 'Aug'){
        Absensi = _Aug.length;
        jumlah = Aug_;
      } else if (_day == 'Sep'){
        Absensi = _Sep.length;
        jumlah = Sep_;
      } else if (_day == 'Okt'){
        Absensi = _Okt.length;
        jumlah = Okt_;
      } else if (_day == 'Nov'){
        Absensi = _Nov.length;
        jumlah = Nov_;
      } else if (_day == 'Des') {
        Absensi = _Des.length;
        jumlah = Des_;
      }

      var p = jumlah.length;

      for(int i = 0;i < p;i++){
        kalkulasi = kalkulasi + int.parse(jumlah[i]);
      }

      kalkulasi = kalkulasi * int.parse(_searchDataPegawai[0].Bonus_Barang);

      final oCcy = new NumberFormat.currency(locale: 'id');

      Gaji = oCcy.format(kalkulasi);

    });
  }

  @override
  Widget build(BuildContext context) {

    Map<String, num> _measures;

    var databulanan =[
      Penjualan("Jan", Jan.length),
      Penjualan("Feb", Feb.length),
      Penjualan("Mar", Mar.length),
      Penjualan("Apr", Apr.length),
      Penjualan("Mei", Mei.length),
      Penjualan("Jun", Jun.length),
      Penjualan("Jul", Jul.length),
      Penjualan("Aug", Aug.length),
      Penjualan("Sep", Sep.length),
      Penjualan("Okt", Okt.length),
      Penjualan("Nov", Nov.length),
      Penjualan("Des", Des.length),
    ];


    var seriesbulanan= [
      charts.Series(
          domainFn: (Penjualan penjualan,_)=>penjualan.day,
          measureFn: (Penjualan penjualan,_)=>penjualan.sold,
          id: 'Penjualan',
          data: databulanan
      )
    ];

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
                            padding: const EdgeInsets.only(top: 20,bottom: 25),
                            child: Text(
                              '${widget.list[widget.index]['Nama']}', style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
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
                            'Statistik Bulan',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          alignment: Alignment(-1.0,-1.0),
                          child: SizedBox(
                            height: 400,
                            child: new charts.BarChart(
                              seriesbulanan,
                              vertical: false,
                              selectionModels: [
                                new charts.SelectionModelConfig(
                                  type: charts.SelectionModelType.info,
                                  changedListener: _onSelectionChanged,
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 10,bottom: 20),
                              child: Text(
                                '$_day',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        'Orderan',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        '$_pendapatan',
                                        style: TextStyle(fontSize: 35),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        'Absensi',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        '$Absensi',
                                        style: TextStyle(fontSize: 35),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 60),
                                  alignment: Alignment(-1.0,-1.0),
                                  child: Text(
                                    'Gaji',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20,bottom: 20),
                                  padding: const EdgeInsets.only(left: 60),
                                  alignment: Alignment(-1.0,-1.0),
                                  child: Text(
                                    '$Gaji',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
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
                                  child: Text('Bonus', style: new TextStyle(fontSize: 30.0),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 25),
                                  child: RaisedButton(
                                    color: Colors.orangeAccent,
                                    onPressed: (){
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (BuildContext context)=> new Bonus(list: widget.list, index: widget.index,)
                                          )
                                      );
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