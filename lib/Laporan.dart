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
import './main.dart';
import 'package:jiffy/jiffy.dart';
import 'order_selesai.dart';

class Penjualan {
  final String day;
  final int sold;
  Penjualan(this.day, this.sold);
}

class Laporan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LaporanRondo();
  }
}

class LaporanRondo extends State<Laporan> {
  var year = Jiffy().format("yyyy");
  var bulan = Jiffy().format("MM");
  var _bulan;
  String _day = 'Bulan';
  String _pendapatan = '0';
  int jml_odr = 0;
  int tot_pendapatan_keseluruhan = 0;
  String total_pendapatan = '0';
  double parameterorder = 0.80;
  double parameterabsen = 0.20;
  String pegawaiofthemonth = 'Tidak Ada';
  String Hasilpegawaiofthemonth = 'Tidak Ada';

  List<DataPenjualan> _datapenjualan = [];
  List<DataPenjualanKeseluruhan> _datapenjualankeseluruhan = [];
  List<DataBarang> _dataBarang = [];
  List<DataSaw> _dataSaw = [];
  List<DataPegawai> _datapegawai = [];
  List<Absensi> abseninsert = [];
  List<String> dataBrg = [];
  List<encode_barang> hargaBrg = [];
  List<encode_barang_terjual> databrgtjl = [];
  List<encode_hasil_akhir> dataAkhir = [];

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
  List<String> JanSaw = [];
  List<String> FebSaw = [];
  List<String> MarSaw = [];
  List<String> AprSaw = [];
  List<String> MeiSaw = [];
  List<String> JunSaw = [];
  List<String> JulSaw = [];
  List<String> AugSaw = [];
  List<String> SepSaw = [];
  List<String> OktSaw = [];
  List<String> NovSaw = [];
  List<String> DesSaw = [];
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
  List<encode_barang_terjual> bJan = [];
  List<encode_barang_terjual> bFeb = [];
  List<encode_barang_terjual> bMar = [];
  List<encode_barang_terjual> bApr = [];
  List<encode_barang_terjual> bMei = [];
  List<encode_barang_terjual> bJun = [];
  List<encode_barang_terjual> bJul = [];
  List<encode_barang_terjual> bAug = [];
  List<encode_barang_terjual> bSep = [];
  List<encode_barang_terjual> bOkt = [];
  List<encode_barang_terjual> bNov = [];
  List<encode_barang_terjual> bDes = [];
  List<String> JanAbs = [];
  List<String> FebAbs = [];
  List<String> MarAbs = [];
  List<String> AprAbs = [];
  List<String> MeiAbs = [];
  List<String> JunAbs = [];
  List<String> JulAbs = [];
  List<String> AugAbs = [];
  List<String> SepAbs = [];
  List<String> OktAbs = [];
  List<String> NovAbs = [];
  List<String> DesAbs = [];

  void _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    var day;
    final measures = <String, num>{};
    int kalkulasi = 0;
    int hasilsaw;
    List total = [];
    List barang = [];
    List pegawai = [];
    List<int> order = [];
    List<int> absen = [];
    List<String> dataHrg = [];
    List AbsensiSelected = [];
    List NormalisasiAbsen = [];
    List NormalisasiOrder = [];
    List saw = [];
    List<encode_hasil_akhir> dataAkhir = [];

    if (selectedDatum.isNotEmpty) {
      day = selectedDatum.first.datum.day;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.sold;
      });
    }
// Request a build.
    setState(() {
      List<encode_barang_terjual> Jumlah = [];
      int g = 0;
      _day = day;
      measures?.forEach((String series, num value) {
        _pendapatan = value.toString();
      });

      if (_day == 'Jan') {
        jml_odr = Jan.length;
        total = _Jan;
        pegawai = JanSaw;
        AbsensiSelected = JanAbs;
        Jumlah = bJan;
      } else if (_day == 'Feb') {
        jml_odr = Feb.length;
        total = _Feb;
        pegawai = FebSaw;
        AbsensiSelected = FebAbs;
        Jumlah = bFeb;
      } else if (_day == 'Mar') {
        jml_odr = Mar.length;
        total = _Mar;
        pegawai = MarSaw;
        AbsensiSelected = MarAbs;
        Jumlah = bMar;
      } else if (_day == 'Apr') {
        jml_odr = Apr.length;
        total = _Apr;
        pegawai = AprSaw;
        AbsensiSelected = AprAbs;
        Jumlah = bApr;
      } else if (_day == 'Mei') {
        jml_odr = Mei.length;
        total = _Mei;
        pegawai = MeiSaw;
        AbsensiSelected = MeiAbs;
        Jumlah = bMei;
      } else if (_day == 'Jun') {
        jml_odr = Jun.length;
        total = _Jun;
        pegawai = JunSaw;
        AbsensiSelected = JunAbs;
        Jumlah = bJun;
      } else if (_day == 'Jul') {
        jml_odr = Jul.length;
        total = _Jul;
        pegawai = JulSaw;
        AbsensiSelected = JulAbs;
        Jumlah = bJul;
      } else if (_day == 'Aug') {
        jml_odr = Aug.length;
        total = _Aug;
        pegawai = AugSaw;
        AbsensiSelected = AugAbs;
        Jumlah = bAug;
      } else if (_day == 'Sep') {
        jml_odr = Sep.length;
        total = _Sep;
        pegawai = SepSaw;
        AbsensiSelected = SepAbs;
        Jumlah = bSep;
      } else if (_day == 'Okt') {
        jml_odr = Okt.length;
        total = _Okt;
        pegawai = OktSaw;
        AbsensiSelected = OktAbs;
        Jumlah = bOkt;
      } else if (_day == 'Nov') {
        jml_odr = Nov.length;
        total = _Nov;
        pegawai = NovSaw;
        AbsensiSelected = NovAbs;
        Jumlah = bNov;
      } else if (_day == 'Des') {
        jml_odr = Des.length;
        total = _Des;
        pegawai = DesSaw;
        AbsensiSelected = DesAbs;
        Jumlah = bDes;
      }
      var length_total = total.length;
      var length_pegawai = pegawai.length;
      var length_dataPegawai = _datapegawai.length;

      for (int i = 0; i < Jumlah.length; i++) {
        int terj = 0;
        int tot_terj = 0;
        for (int j = 0; j < _dataBarang.length; j++) {
          if (Jumlah[i].id_barang == _dataBarang[j].id_barang) {
            terj = int.parse(Jumlah[i].Jumlah);
            tot_terj = tot_terj + terj;
            for (int k = 0; k < dataBrg.length; k++) {
              if (Jumlah[i].id_barang == hargaBrg[k].id_barang) {
                int _k = k + 1;
                if (dataBrg[k] == "0") {
                  dataBrg.replaceRange(k, _k, [tot_terj.toString()]);
                } else {
                  int hasil = tot_terj + int.parse(dataBrg[k]);
                  dataBrg.replaceRange(k, _k, [hasil.toString()]);
                }
              }
            }
          }
        }
      }
      for (int x = 0; x < _datapegawai.length; x++) {
        int abssementara = 0;
        for (int y = 0; y < AbsensiSelected.length; y++) {
          if (AbsensiSelected[y] == _datapegawai[x].id_pegawai) {
            abssementara = abssementara + 1;
          }
        }
        absen.add(abssementara);
      }
      for (int j = 0; j < length_dataPegawai; j++) {
        int sawsementara = 0;
        for (int k = 0; k < length_pegawai; k++) {
          if (pegawai[k] == _datapegawai[j].Nama) {
            sawsementara = sawsementara + 1;
          }
        }
        order.add(sawsementara);
      }
      int nilaimaxabsen = absen.reduce(max);
      int nilaimaxorder = order.reduce(max);
      for (int a = 0; a < absen.length; a++) {
        double normalisasiabsen = 0;
        normalisasiabsen = absen[a] / nilaimaxabsen;
        NormalisasiAbsen.add(normalisasiabsen.toStringAsFixed(2));
      }
      for (int a = 0; a < order.length; a++) {
        double normalisasiorder = 0;
        normalisasiorder = order[a] / nilaimaxorder;
        NormalisasiOrder.add(normalisasiorder.toStringAsFixed(2));
      }
      for (int a = 0; a < _datapegawai.length; a++) {
        double t1 = parameterabsen * double.parse(NormalisasiAbsen[a]);
        double t2 = parameterorder * double.parse(NormalisasiOrder[a]);
        double total = t1 + t2;
        String hasil = total.toStringAsFixed(2);
        saw.add(double.parse(hasil));
      }
      double sawmax =
          saw.reduce((value, element) => value > element ? value : element);
      for (int a = 0; a < saw.length; a++) {
        if (sawmax == saw[a]) {
          hasilsaw = (a + 1);
        }
      }

      for (int b = 0; b < _datapegawai.length; b++) {
        if (hasilsaw.toString() == _datapegawai[b].id_pegawai) {
          pegawaiofthemonth = _datapegawai[b].Nama;
        }
      }
      if (jml_odr == 0) {
        Hasilpegawaiofthemonth = 'Tidak Ada';
      } else {
        Hasilpegawaiofthemonth = pegawaiofthemonth;
      }

      for (int v = 0; v < dataBrg.length; v++) {
        if (dataBrg[v] == "0") {
          dataHrg.add("0");
        } else {
          int hasil = int.parse(dataBrg[v]) * int.parse(hargaBrg[v].Harga);
          dataHrg.add(hasil.toString());
        }
      }
      for (int z = 0; z < hargaBrg.length; z++) {
        var nama = hargaBrg[z].Nama;
        var jumlah = dataBrg[z];
        var harga = dataHrg[z];
        dataAkhir
            .add(encode_hasil_akhir(Nama: nama, jumlah: jumlah, Harga: harga));
      }
      for (int i = 0; i < length_total; i++) {
        kalkulasi = kalkulasi + int.parse(total[i]);
      }

      final oCcy = new NumberFormat.currency(locale: 'id');
      total_pendapatan = oCcy.format(kalkulasi);
    });
  }

  Future<List<DataPenjualan>> getPenjualan() async {
    final responseA = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_detail_only_selesai.php");
    final responseJsonA = json.decode(responseA.body);
    final responseB = await http
        .get("http://timothy.buzz/juljol/get_pemesanan_only_selesai.php");
    final responseJsonB = json.decode(responseB.body);
    final responseC =
        await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonC = json.decode(responseC.body);
    final responseD = await http.get(
        "http://timothy.buzz/juljol/get_pemesanan_detail_join_pemesanan_id_order.php");
    final responseJsonD = json.decode(responseD.body);
    final responseE =
        await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJsonE = json.decode(responseE.body);

    setState(() {
      for (Map DataA in responseJsonA) {
        _datapenjualan.add(DataPenjualan.fromJson(DataA));
      }
      for (Map DataB in responseJsonB) {
        _datapenjualankeseluruhan.add(DataPenjualanKeseluruhan.fromJson(DataB));
      }
      for (Map Data in responseJsonC) {
        _dataBarang.add(DataBarang.fromJson(Data));
      }
      for (Map Data in responseJsonD) {
        _dataSaw.add(DataSaw.fromJson(Data));
      }
      for (Map Data in responseJsonE) {
        _datapegawai.add(DataPegawai.fromJson(Data));
      }
      var l = _datapenjualankeseluruhan.length;
      for (int i = 0; i < l; i++) {
        var bulan = _datapenjualankeseluruhan[i].Tanggal;
        var _bulan = bulan.substring(5, 7);
        if (_bulan == '01') {
          _Jan.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '02') {
          _Feb.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '03') {
          _Mar.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '04') {
          _Apr.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '05') {
          _Mei.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '06') {
          _Jun.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '07') {
          _Jul.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '08') {
          _Aug.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '09') {
          _Sep.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '10') {
          _Okt.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '11') {
          _Nov.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '12') {
          _Des.add(_datapenjualankeseluruhan[i].Total);
        }
      }
      var p = _datapenjualan.length;
      for (int i = 0; i < p; i++) {
        var bulan = _datapenjualan[i].Tanggal;
        var _bulan = bulan.substring(5, 7);
        if (_bulan == '01') {
          Jan.add(_datapenjualan[i].id_pemesanan);
          bJan.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '02') {
          Feb.add(_datapenjualan[i].id_pemesanan);
          bFeb.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '03') {
          Mar.add(_datapenjualan[i].id_pemesanan);
          bMar.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '04') {
          Apr.add(_datapenjualan[i].id_pemesanan);
          bApr.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '05') {
          Mei.add(_datapenjualan[i].id_pemesanan);
          bMei.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '06') {
          Jun.add(_datapenjualan[i].id_pemesanan);
          bJun.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '07') {
          Jul.add(_datapenjualan[i].id_pemesanan);
          bJul.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '08') {
          Aug.add(_datapenjualan[i].id_pemesanan);
          bAug.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '09') {
          Sep.add(_datapenjualan[i].id_pemesanan);
          bSep.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '10') {
          Okt.add(_datapenjualan[i].id_pemesanan);
          bOkt.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '11') {
          Nov.add(_datapenjualan[i].id_pemesanan);
          bNov.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        } else if (_bulan == '12') {
          Des.add(_datapenjualan[i].id_pemesanan);
          bDes.add(encode_barang_terjual(
              id_barang: _datapenjualan[i].Barang,
              Jumlah: _datapenjualan[i].Jumlah));
        }
      }
      var o = _dataBarang.length;
      for (int i = 0; i < o; i++) {
        var id_Barang = _dataBarang[i].id_barang;
        var nama = _dataBarang[i].Nama;
        var harga = _dataBarang[i].Harga;
        var jumlah = _dataBarang[i].nilai_awal;
        dataBrg.add(jumlah);
        hargaBrg.add(encode_barang(
            id_barang: id_Barang, Nama: nama, Harga: harga, jumlah: jumlah));
      }
      var a = _dataSaw.length;
      for (int i = 0; i < a; i++) {
        var bulan = _dataSaw[i].Tanggal;
        var _bulan = bulan.substring(5, 7);
        if (_bulan == '01') {
          JanSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '02') {
          FebSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '03') {
          MarSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '04') {
          AprSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '05') {
          MeiSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '06') {
          JunSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '07') {
          JulSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '08') {
          AugSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '09') {
          SepSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '10') {
          OktSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '11') {
          NovSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '12') {
          DesSaw.add(_dataSaw[i].pengantar);
        }
      }
      var t = _datapegawai.length;
      var y = _datapenjualan.length;
      for (int i = 0; i < t; i++) {
        List absensatuan = [];
        for (int j = 0; j < y; j++) {
          if (_datapegawai[i].id_pegawai == _datapenjualan[j].id_pegawai) {
            absensatuan.add(_datapenjualan[j].Tanggal);
          }
        }
        absensatuan = absensatuan.toSet().toList();
        for (int k = 0; k < absensatuan.length; k++) {
          abseninsert.add(Absensi(_datapegawai[i].id_pegawai,
              _datapegawai[i].Nama, absensatuan[k]));
        }
      }
      for (int a = 0; a < abseninsert.length; a++) {
        var bulan = abseninsert[a].Tanggal;
        var _bulan = bulan.substring(5, 7);
        if (_bulan == '01') {
          JanAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '02') {
          FebAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '03') {
          MarAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '04') {
          AprAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '05') {
          MeiAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '06') {
          JunAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '07') {
          JulAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '08') {
          AugAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '09') {
          SepAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '10') {
          OktAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '11') {
          NovAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '12') {
          DesAbs.add(abseninsert[a].id_pegawai);
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
      print(Jul);
    });
  }

  int _currentIndex = 0;

  TextEditingController controller = new TextEditingController();
  String filter;
  void initState() {
    super.initState();
    getPenjualan();
  }

  void _showpilerror() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Anda belum memilih data"),
          content: new Text(
              "Mohon untuk memeriksa apakah bar pada list bulan sudah di pilih"),
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

  void validasireset() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
// return object of type Dialog
        return AlertDialog(
          title: new Text("Peringatan"),
          content: new Text(
              "Apakah anda akan yakin akan menghapus data pada bulan $_day ?"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Hapus"),
              onPressed: () {
                if (_day == 'Jan') {
                  _bulan = '01';
                } else if (_day == 'Feb') {
                  _bulan = '02';
                } else if (_day == 'Mar') {
                  _bulan = '03';
                } else if (_day == 'Apr') {
                  _bulan = '04';
                } else if (_day == 'Mei') {
                  _bulan = '05';
                } else if (_day == 'Jun') {
                  _bulan = '06';
                } else if (_day == 'Jul') {
                  _bulan = '07';
                } else if (_day == 'Aug') {
                  _bulan = '08';
                } else if (_day == 'Sep') {
                  _bulan = '09';
                } else if (_day == 'Okt') {
                  _bulan = '10';
                } else if (_day == 'Nov') {
                  _bulan = '11';
                } else if (_day == 'Des') {
                  _bulan = '12';
                }
                for (int a = 0; a < _datapenjualan.length; a++) {
                  var tahun = _datapenjualan[a].Tanggal;
                  var _bulanpil = tahun.substring(5, 7);
                  if (_bulanpil == _bulan) {
                    var id_order = _datapenjualan[a].id_order;
                    var id_pemesanan = _datapenjualan[a].id_pemesanan;
                    var url =
                        "http://timothy.buzz/juljol/reset_laporan_per_bulan.php";
                    http.post(url, body: {
                      "id_order": id_order,
                      "id_pemesanan": id_pemesanan,
                    });
                  }
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => new GridLayoutRondo()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var databulanan = [
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

    var seriesbulanan = [
      charts.Series(
          domainFn: (Penjualan penjualan, _) => penjualan.day,
          measureFn: (Penjualan penjualan, _) => penjualan.sold,
          id: 'Penjualan',
          data: databulanan)
    ];
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(43, 40, 35, 1),
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color.fromRGBO(187, 111, 51, 1),
                  expandedHeight: 70,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      'Laporan',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(
                          top: 40.0, left: 10.0, right: 10.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(187, 111, 51, 1),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 40, left: 40),
                            alignment: Alignment(-1.0, -1.0),
                            child: Text(
                              'Grafik Order',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            alignment: Alignment(-1.0, -1.0),
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
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          margin: const EdgeInsets.only(
                              top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(187, 111, 51, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                child: Text(
                                  '$_day',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 60),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  'Order',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                padding: const EdgeInsets.only(left: 60),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  '$jml_odr',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 60),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  'Pendapatan',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                padding: const EdgeInsets.only(left: 60),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  '$total_pendapatan',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 60),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  'Pegawai Terbaik',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                padding: const EdgeInsets.only(left: 60),
                                alignment: Alignment(-1.0, -1.0),
                                child: Text(
                                  '$Hasilpegawaiofthemonth',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(top: 20),
                            margin: const EdgeInsets.only(
                                top: 40.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(187, 111, 51, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 40),
                                  alignment: Alignment(-1.0, -1.0),
                                  child: Text(
                                    'More',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    padding: const EdgeInsets.only(
                                        left: 60, right: 60),
                                    alignment: Alignment(-1.0, -1.0),
                                    child: new SizedBox(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: Colors.orangeAccent,
                                          onPressed: () {
                                            if (_day == "Bulan") {
                                              _showpilerror();
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          order_selesai(
                                                              month: _day)));
                                            }
                                          },
                                          child: const Text('Detail Order',
                                              style: TextStyle(fontSize: 20)),
                                        ))),
                                Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.only(
                                        left: 60, right: 60),
                                    alignment: Alignment(-1.0, -1.0),
                                    child: new SizedBox(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: Colors.orangeAccent,
                                          onPressed: () {
                                            if (_day == "Bulan") {
                                              _showpilerror();
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => pdf(
                                                            month: _day,
                                                            JmlOrder: jml_odr
                                                                .toString(),
                                                            Pendapatan:
                                                                total_pendapatan,
                                                            PegawaiTerbaik:
                                                                Hasilpegawaiofthemonth,
                                                          )));
                                            }
                                          },
                                          child: const Text('Cetak Laporan',
                                              style: TextStyle(fontSize: 20)),
                                        ))),
                                Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.only(
                                        left: 60, right: 60),
                                    alignment: Alignment(-1.0, -1.0),
                                    child: new SizedBox(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: Colors.red,
                                          onPressed: () {
                                            if (_day == "Bulan") {
                                              _showpilerror();
                                            } else {
                                              validasireset();
                                            }
                                          },
                                          child: const Text('Reset Bulan',
                                              style: TextStyle(fontSize: 20)),
                                        ))),
                              ],
                            )),
                      ],
                    ),
                  ]),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DataPenjualan {
  String id_order;
  String id_pemesanan;
  String id_pegawai;
  String Tanggal;
  String pengantar;
  String Total;
  String Jumlah;
  String Barang;
  DataPenjualan(
      {this.id_order,
      this.id_pemesanan,
      this.id_pegawai,
      this.Tanggal,
      this.pengantar,
      this.Total,
      this.Jumlah,
      this.Barang});
  factory DataPenjualan.fromJson(Map<String, dynamic> json) {
    return DataPenjualan(
        id_order: json['id_order'],
        id_pegawai: json['id_pegawai'],
        id_pemesanan: json['id_pemesanan'],
        Tanggal: json['Tanggal'],
        pengantar: json['pengantar'],
        Total: json['Total'],
        Jumlah: json['Jumlah'],
        Barang: json['id_Barang']);
  }
}

class DataPenjualanKeseluruhan {
  String id_order;
  String pengantar;
  String Total;
  String Tanggal;

  DataPenjualanKeseluruhan(
      {this.id_order, this.pengantar, this.Total, this.Tanggal});
  factory DataPenjualanKeseluruhan.fromJson(Map<String, dynamic> json) {
    return DataPenjualanKeseluruhan(
        id_order: json['id_order'],
        pengantar: json['pengantar'],
        Tanggal: json['Tanggal'],
        Total: json['Total']);
  }
}

class DataBarang {
  String id_barang;
  String Nama;
  String Harga;
  String nilai_awal;

  DataBarang({this.id_barang, this.Nama, this.Harga, this.nilai_awal});
  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga'],
        nilai_awal: json['nilai_awal']);
  }
}

class DataSaw {
  String id_pemesanan;
  String Tanggal;
  String pengantar;

  DataSaw({
    this.id_pemesanan,
    this.Tanggal,
    this.pengantar,
  });
  factory DataSaw.fromJson(Map<String, dynamic> json) {
    return DataSaw(
        id_pemesanan: json['id_pemesanan'],
        Tanggal: json['Tanggal'],
        pengantar: json['pengantar']);
  }
}

class DataPegawai {
  String id_pegawai;
  String Nama;

  DataPegawai({this.id_pegawai, this.Nama});
  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(id_pegawai: json['id_pegawai'], Nama: json['Nama']);
  }
}

class Saw {
  String Nama;
  int Absen;
  int Jml_data;
  Saw(this.Nama, this.Absen, this.Jml_data);
  @override
  String toString() {
    return '{ ${this.Nama}, ${this.Absen} , ${this.Jml_data}}';
  }
}

class Absensi {
  String id_pegawai;
  String Nama;
  String Tanggal;
  Absensi(this.id_pegawai, this.Nama, this.Tanggal);
  String toString() {
    return '{ ${this.id_pegawai}, ${this.Nama}, ${this.Tanggal} }';
  }
}

class encode_barang {
  String id_barang;
  String Nama;
  String Harga;
  String jumlah;

  encode_barang({
    this.id_barang,
    this.Nama,
    this.Harga,
    this.jumlah,
  });
  Map<String, dynamic> toJson() => {
        'id_Barang': id_barang,
        'Nama': Nama,
        'Harga': Harga,
        'Jumlah': jumlah,
      };
}

class encode_barang_laporan {
  String id_barang;
  String Terjual;
  String Nama;
  String Harga;

  encode_barang_laporan({
    this.id_barang,
    this.Terjual,
    this.Nama,
    this.Harga,
  });
  Map<String, dynamic> toJson() => {
        'id_Barang': id_barang,
        'Terjual': Terjual,
        'Nama': Nama,
        'Harga': Harga
      };
}

class encode_barang_terjual {
  String id_barang;
  String Jumlah;

  encode_barang_terjual({
    this.id_barang,
    this.Jumlah,
  });
  Map<String, dynamic> toJson() => {
        'id_Barang': id_barang,
        'Jumlah': Jumlah,
      };
}

class encode_hasil_akhir {
  String Nama;
  String Harga;
  String jumlah;

  encode_hasil_akhir({
    this.Nama,
    this.Harga,
    this.jumlah,
  });
  Map<String, dynamic> toJson() => {
        'Nama': Nama,
        'Harga': Harga,
        'Jumlah': jumlah,
      };
}
