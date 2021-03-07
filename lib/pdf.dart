import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import './pdf.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:math';

class pdf extends StatefulWidget {
  String month;
  String JmlOrder;
  String Pendapatan;
  String PegawaiTerbaik;
  pdf({this.month, this.JmlOrder, this.PegawaiTerbaik, this.Pendapatan});
  @override
  State<StatefulWidget> createState() {
    return pdfRondo();
  }
}

class pdfRondo extends State<pdf> {
  String namaBulan;
  final catatan = TextEditingController();
  List<DataPegawai> _pekerja = [];
  List<DataPegawaiDetail> _pekerjaDetail = [];
  List<DataPegawaiDetail> _sortpekerjaDetail = [];
  String bulan;
  List<int> _jmlkirim = [];
  List<int> Absensi = [];
  List<int> jmlbrg = [];
  List<String> sortAbsensi = [];
  List<DataBarang> barang = [];
  List<DataBarang> sortbarang = [];
  String tot_gaji;
  List<array_report> array_laporan = [];
  List<array_report_detail> array_laporan_detail = [];
  List<DataSaw> _dataDetails = [];
  List<DataSaw> _sortdataDetails = [];
  void konverter_barang() {
    int jumlah = 0;
    for (int a = 0; a < _pekerja.length; a++) {
      jumlah = 0;
      for (int b = 0; b < sortbarang.length; b++) {
        if (_pekerja[a].id_pegawai == sortbarang[b].id_pegawai) {
          jumlah = jumlah + int.parse(sortbarang[b].Jumlah);
        }
      }
      jmlbrg.add(jumlah);
    }
    print(jmlbrg);
  }

  Future<String> getBarang() async {
    await Future.delayed(Duration(seconds: 2));
    final response = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_join_odr_msk_detail.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        barang.add(DataBarang.fromJson(Data));
      }
      barang.forEach((a) {
        var tanggal = a.Tanggal;
        var _bulan = tanggal.substring(5, 7);
        if (_bulan == bulan) {
          sortbarang.add(a);
        }
      });
      konverter_barang();
    });
  }

  Future<String> getPegawai() async {
    final response =
        await http.get("http://timothy.buzz/juljol/get_pegawai_except_p.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _pekerja.add(DataPegawai.fromJson(Data));
      }
    });
  }

  void konverter_absensi() {
    List<String> tanggal = [];
    List<String> _tanggal = [];
    for (int a = 0; a < _pekerja.length; a++) {
      tanggal.clear();
      _tanggal.clear();
      for (int b = 0; b < _sortpekerjaDetail.length; b++) {
        if (_pekerja[a].id_pegawai == _sortpekerjaDetail[b].id_pegawai) {
          tanggal.add(_sortpekerjaDetail[b].Tanggal);
        }
      }
      _tanggal = tanggal.toSet().toList();
      Absensi.add(_tanggal.length);
    }
    print(Absensi);
  }

  Future<String> getPegawaiDetail() async {
    await Future.delayed(Duration(seconds: 2));
    final response = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_detail_only_selesai.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _pekerjaDetail.add(DataPegawaiDetail.fromJson(Data));
      }
      _pekerjaDetail.forEach((a) {
        var tanggal = a.Tanggal;
        var _bulan = tanggal.substring(5, 7);
        if (_bulan == bulan) {
          _sortpekerjaDetail.add(a);
        }
      });
      konverter_absensi();
      List<String> arraysementara = [];
      List<String> arraysementaralimpah = [];
      for (int b = 0; b < _pekerja.length; b++) {
        arraysementara.clear();
        arraysementaralimpah.clear();
        for (int c = 0; c < _sortpekerjaDetail.length; c++) {
          if (_pekerja[b].id_pegawai == _sortpekerjaDetail[c].id_pegawai) {
            arraysementara.add(_sortpekerjaDetail[c].id_pemesanan);
            arraysementaralimpah = arraysementara.toSet().toList();
          }
        }
        _jmlkirim.add(arraysementaralimpah.length);
      }
      print(_jmlkirim);
    });
  }

  Future<List> getData() async {
    final response = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_detail_join_pemesanan.php");
    final responseJson = json.decode(response.body);
    setState(() {
      for (Map Data in responseJson) {
        _dataDetails.add(DataSaw.fromJson(Data));
      }
      _dataDetails.forEach((a) {
        var tanggal = a.tanggal;
        var _bulan = tanggal.substring(5, 7);
        if (_bulan == bulan) {
          _sortdataDetails.add(a);
        }
      });
    });
  }

  void pra_array() {
    array_laporan.clear();
    array_laporan.add(array_report(
        'id', 'Nama Pegawai', 'Gaji', 'Absensi', 'Jumlah Kiriman'));
    for (int a = 0; a < jmlbrg.length; a++) {
      var bonus_brg = jmlbrg[a] * int.parse(_pekerja[a].Bonus_Barang);
      var bonus_absen = jmlbrg[a] * int.parse(_pekerja[a].Bonus_Absen);
      var gaji = bonus_brg + bonus_absen;
      final oCcy = new NumberFormat.currency(locale: 'id');
      tot_gaji = oCcy.format(gaji);
      var nama = _pekerja[a].Nama;
      var id_pegawai = _pekerja[a].id_pegawai;
      var absensi = Absensi[a];
      var jmlkirim = _jmlkirim[a];
      array_laporan.add(array_report(
          id_pegawai, nama, tot_gaji, absensi.toString(), jmlkirim.toString()));
    }
  }

  void pra_laporan() {
    array_laporan_detail.clear();
    array_laporan_detail.add(array_report_detail('id order', 'id pemesanan',
        'Alamat', 'Tanggal', 'Waktu', 'Pengirim', 'Harga'));
    for (int a = 0; a < _sortdataDetails.length; a++) {
      var id_order = _sortdataDetails[a].id_order;
      var id_pemesanan = _sortdataDetails[a].id;
      var alamat = _sortdataDetails[a].alamat;
      var tanggal = _sortdataDetails[a].tanggal;
      var waktu = _sortdataDetails[a].waktu;
      var pengirim = _sortdataDetails[a].pengirim;
      var harga = _sortdataDetails[a].harga;
      array_laporan_detail.add(array_report_detail(
          id_order, id_pemesanan, alamat, tanggal, waktu, pengirim, harga));
    }
  }

  void _printDocument(day) {
    pra_array();
    pra_laporan();
    Printing.layoutPdf(onLayout: (pageFormat) {
      final doc = pw.Document();
      const tableHeaders = [
        'id pemesanan',
        'Alamat',
      ];
      doc.addPage(pw.MultiPage(
          build: (pw.Context context) => <pw.Widget>[
                pw.Header(
                    level: 0,
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Text('Laporan', textScaleFactor: 2),
                        ])),
                pw.Paragraph(
                    text:
                        'Pada bulan $namaBulan, berikut adalah rincian detail laporan khusus bulan secara detail'),
                pw.Paragraph(text: '${catatan.text}'),
                pw.Header(level: 1, text: 'Rangkuman bulan $namaBulan'),
                pw.Paragraph(text: 'Jumlah Pesanan Masuk : ${widget.JmlOrder}'),
                pw.Paragraph(
                    text: 'Jumlah Pendapatan Masuk : ${widget.Pendapatan}'),
                pw.Paragraph(
                    text: 'Pegawai Terbaik : ${widget.PegawaiTerbaik}'),
                pw.Header(
                    level: 1, child: pw.Text('Pegawai', textScaleFactor: 2)),
                pw.Column(children: <pw.Widget>[
                  pw.Table(
                      children: array_laporan
                          .map((item) => pw.TableRow(children: [
                                pw.Text(item.id.toString()),
                                pw.Text(item.nama.toString()),
                                pw.Text(item.absensi.toString()),
                                pw.Text(item.gaji.toString()),
                                pw.Text(item.jmlkirim.toString()),
                              ]))
                          .toList())
                ]),
                pw.Header(
                    level: 1, child: pw.Text('Detail', textScaleFactor: 2)),
                pw.Column(children: <pw.Widget>[
                  pw.Table(
                      children: array_laporan_detail
                          .map((item) => pw.TableRow(children: [
                                pw.Text(item.id.toString()),
                                pw.Text(item.alamat.toString()),
                                pw.Text(item.tanggal.toString()),
                                pw.Text(item.waktu.toString()),
                                pw.Text(item.pengirim.toString()),
                                pw.Text(item.harga.toString()),
                              ]))
                          .toList())
                ]),
              ]));
      return doc.save();
    });
  }

  @override
  void _bulan() {
    if (widget.month == 'Jan') {
      bulan = '01';
      namaBulan = 'Januari';
    } else if (widget.month == 'Feb') {
      bulan = '02';
      namaBulan = 'Febuari';
    } else if (widget.month == 'Mar') {
      bulan = '03';
      namaBulan = 'Maret';
    } else if (widget.month == 'Apr') {
      bulan = '04';
      namaBulan = 'April';
    } else if (widget.month == 'Mei') {
      bulan = '05';
      namaBulan = 'Mei';
    } else if (widget.month == 'Jun') {
      bulan = '06';
      namaBulan = 'Juni';
    } else if (widget.month == 'Jul') {
      bulan = '07';
      namaBulan = 'Juli';
    } else if (widget.month == 'Aug') {
      bulan = '08';
      namaBulan = 'Agustus';
    } else if (widget.month == 'Sep') {
      bulan = '09';
      namaBulan = 'September';
    } else if (widget.month == 'Okt') {
      bulan = '10';
      namaBulan = 'Oktober';
    } else if (widget.month == 'Nov') {
      bulan = '11';
      namaBulan = 'November';
    } else if (widget.month == 'Des') {
      bulan = '12';
      namaBulan = 'Desember';
    }
  }

  void initState() {
    super.initState();
    _bulan();
    getPegawai();
    getPegawaiDetail();
    getBarang();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          decoration: BoxDecoration(color: Color(0xffffff)),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                padding: EdgeInsets.only(bottom: 20, top: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(76, 177, 247, 1),
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 40.0, right: 40.0, bottom: 20),
                        child: Text('Laporan Bulan $namaBulan',
                            style: TextStyle(fontSize: 40))),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                padding: EdgeInsets.only(bottom: 20, top: 10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(76, 177, 247, 1),
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 40),
                      alignment: Alignment(-1.0, -1.0),
                      child: Text(
                        'Laporan',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      padding: const EdgeInsets.only(left: 40),
                      alignment: Alignment(-1.0, -1.0),
                      child: TextField(
                        controller: catatan,
                        maxLines: 6,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Colors.lightBlueAccent,
                  onPressed: () => _printDocument(widget.month),
                  child: const Text('Cetak Laporan',
                      style: TextStyle(fontSize: 20)),
                ),
              )
            ],
          )),
    );
  }
}

class DataPegawai {
  String id_pegawai;
  String Nama;
  String Bonus_Barang;
  String Bonus_Absen;

  DataPegawai(
      {this.id_pegawai, this.Nama, this.Bonus_Barang, this.Bonus_Absen});
  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        id_pegawai: json['id_pegawai'],
        Nama: json['Nama'],
        Bonus_Barang: json['Bonus_Barang'],
        Bonus_Absen: json['Bonus_Absen']);
  }
}

class DataPegawaiDetail {
  String id_pegawai;
  String id_pemesanan;
  String Nama;
  String Alamat;
  String Tanggal;

  String Harga;
  String Bonus_Barang;
  String Bonus_Absen;

  DataPegawaiDetail(
      {this.id_pegawai,
      this.id_pemesanan,
      this.Nama,
      this.Alamat,
      this.Tanggal,
      this.Harga,
      this.Bonus_Barang,
      this.Bonus_Absen});
  factory DataPegawaiDetail.fromJson(Map<String, dynamic> json) {
    return DataPegawaiDetail(
      id_pegawai: json['id_pegawai'],
      id_pemesanan: json['id_pemesanan'],
      Nama: json['pengantar'],
      Alamat: json['ALamat'],
      Tanggal: json['Tanggal'],
      Harga: json['Harga'],
    );
  }
}

class DataBarang {
  String id_pegawai;
  String Nama;
  String Jumlah;
  String Tanggal;

  DataBarang({this.id_pegawai, this.Nama, this.Jumlah, this.Tanggal});
  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_pegawai: json['id_pegawai'],
        Nama: json['Nama'],
        Jumlah: json['Jumlah'],
        Tanggal: json['Tanggal']);
  }
}

class array_report {
  String id;
  String nama;
  String gaji;
  String absensi;
  String jmlkirim;
  array_report(this.id, this.nama, this.gaji, this.absensi, this.jmlkirim);
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'gaji': gaji,
        'absensi': absensi,
        'jmlkirim': jmlkirim
      };
}

class DataSaw {
  String id_order;
  String id;
  String alamat;
  String tanggal;
  String waktu;
  String pengirim;
  String harga;

  DataSaw(
      {this.id_order,
      this.id,
      this.alamat,
      this.tanggal,
      this.waktu,
      this.pengirim,
      this.harga});
  factory DataSaw.fromJson(Map<String, dynamic> json) {
    return DataSaw(
        id_order: json['id_order'],
        id: json['id_pemesanan'],
        alamat: json['ALamat'],
        tanggal: json['Tanggal'],
        waktu: json['Waktu'],
        pengirim: json['pengantar'],
        harga: json['harga']);
  }
}

class array_report_detail {
  String id_order;
  String id;
  String alamat;
  String tanggal;
  String waktu;
  String pengirim;
  String harga;
  array_report_detail(this.id_order, this.id, this.alamat, this.tanggal,
      this.waktu, this.pengirim, this.harga);
  Map<String, dynamic> toJson() => {
        'id_order': id,
        'id': id,
        'alamat': alamat,
        'tanggal': tanggal,
        'waktu': waktu,
        'pengirim': pengirim,
        'harga': harga
      };
}
