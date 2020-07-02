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

import 'order_selesai.dart';

class Penjualan{
  final String day;
  final int sold;

  Penjualan(this.day,this.sold);
}

class Laporan extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LaporanRondo();
  }

}

class LaporanRondo extends State<Laporan> {
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


  int hargasiulA = 0;
  int hargasiulB = 0;
  int hargaaqua = 0;
  int hargavit = 0;
  int hargagaskcl = 0;
  int hargagasbsr = 0;
  int hargavitgls = 0;
  int hargaaquagls = 0;

  int hrgsiulA = 0;
  int hrgsiulB = 0;
  int hrgaqua = 0;
  int hrgvit = 0;
  int hrggaskcl = 0;
  int hrggasbsr = 0;
  int hrgvitgls = 0;
  int hrgaquagls = 0;

  int siulA = 0;
  int siulB = 0;
  int aqua = 0;
  int vit = 0;
  int gaskcl = 0;
  int gasbsr = 0;
  int vitgls = 0;
  int aquagls = 0;


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
  List<String> FebSaw  = [];
  List<String> MarSaw  = [];
  List<String> AprSaw  = [];
  List<String> MeiSaw  = [];
  List<String> JunSaw = [];
  List<String> JulSaw  = [];
  List<String> AugSaw  = [];
  List<String> SepSaw  = [];
  List<String> OktSaw  = [];
  List<String> NovSaw  = [];
  List<String> DesSaw  = [];

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

  void _printDocument(day) {
    Printing.layoutPdf(
      onLayout: (pageFormat) {
        final doc = pw.Document();

        doc.addPage(
          pw.MultiPage(
            build: (pw.Context context) => <pw.Widget>[
              pw.Header(
                  level: 0,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Text('Report', textScaleFactor: 2),
                      ])),
              pw.Header(level: 1, text: '$day'),
              pw.Paragraph(
                text: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
              ),
              pw.Paragraph(
                text: 'Jumlah Pesanan Masuk         : $jml_odr'
              ),
              pw.Paragraph(
                text: 'Jumlah Pendapatan Masuk      : $total_pendapatan'
              ),
              pw.Paragraph(
                text: 'Pegawai Terbaik      : $Hasilpegawaiofthemonth'
              ),
              pw.Row(
                children: <pw.Widget>[

                ]
              )
            ]
          )
        );

        return doc.save();
      },
    );
  }

  void _onSelectionChanged(charts.SelectionModel model) {
    hargasiulA = 0;
    hargasiulB = 0;
    hargaaqua = 0;
    hargavit = 0;
    hargagaskcl = 0;
    hargagasbsr = 0;
    hargavitgls = 0;
    hargaaquagls = 0;

    siulA = 0;
    siulB = 0;
    aqua = 0;
    vit = 0;
    gaskcl = 0;
    gasbsr = 0;
    vitgls = 0;
    aquagls = 0;

    final selectedDatum = model.selectedDatum;

    var day;
    final measures = <String, num>{};

    int kalkulasi = 0;
    int hasilsaw;

    List total = [];
    List barang = [];
    List pegawai = [];
    List <int> order = [];
    List <int> absen = [];
    List AbsensiSelected = [];
    List NormalisasiAbsen = [];
    List NormalisasiOrder = [];
    List saw = [];


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
        jml_odr = Jan.length;
        barang = Jan_;
        total = _Jan;
        pegawai = JanSaw;
        AbsensiSelected = JanAbs;
      } else if (_day == 'Feb'){
        jml_odr = Feb.length;
        barang = Feb_;
        total = _Feb;
        pegawai = FebSaw;
        AbsensiSelected = FebAbs;
      } else if (_day == 'Mar'){
        jml_odr = Mar.length;
        barang = Mar_;
        total = _Mar;
        pegawai = MarSaw;
        AbsensiSelected = MarAbs;
      } else if (_day == 'Apr'){
        jml_odr = Apr.length;
        barang = Apr_;
        total = _Apr;
        pegawai = AprSaw;
        AbsensiSelected = AprAbs;
      } else if (_day == 'Mei'){
        jml_odr = Mei.length;
        barang = Mei_;
        total = _Mei;
        pegawai = MeiSaw;
        AbsensiSelected = MeiAbs;
      } else if (_day == 'Jun'){
        jml_odr = Jun.length;
        barang = Jun_;
        total = _Jun;
        pegawai = JunSaw;
        AbsensiSelected = JunAbs;
      } else if (_day == 'Jul'){
        jml_odr = Jul.length;
        barang = Jul_;
        total = _Jul;
        pegawai = JulSaw;
        AbsensiSelected = JulAbs;
      } else if (_day == 'Aug'){
        jml_odr = Aug.length;
        barang = Aug_;
        total = _Aug;
        pegawai = AugSaw;
        AbsensiSelected = AugAbs;
      } else if (_day == 'Sep'){
        jml_odr = Sep.length;
        barang = Sep_;
        total = _Sep;
        pegawai = SepSaw;
        AbsensiSelected = SepAbs;
      } else if (_day == 'Okt'){
        jml_odr = Okt.length;
        barang = Okt_;
        total = _Okt;
        pegawai = OktSaw;
        AbsensiSelected = OktAbs;
      } else if (_day == 'Nov'){
        jml_odr = Nov.length;
        barang = Nov_;
        total = _Nov;
        pegawai = NovSaw;
        AbsensiSelected = NovAbs;
      } else if (_day == 'Des') {
        jml_odr = Des.length;
        barang = Des_;
        total = _Des;
        pegawai = DesSaw;
        AbsensiSelected = DesAbs;
      }

      var barang_total = barang.length;
      var length_total = total.length;
      var length_pegawai = pegawai.length;
      var length_dataPegawai = _datapegawai.length;

      for(int i = 0;i < barang_total;i++){
        if(barang[i] == 'SiulA'){
          siulA = siulA + 1;
        } else if (barang[i] == 'SiulB'){
          siulB = siulB + 1;
        } else if (barang[i] == 'Aqua'){
          aqua = aqua + 1;
        } else if (barang[i] == 'Vit'){
          vit = vit + 1;
        } else if (barang[i] == 'Gas_kcl'){
          gaskcl = gaskcl + 1;
        } else if (barang[i] == 'Gas_bsr'){
          gasbsr = gasbsr + 1;
        } else if (barang[i] == 'Aqua_gls'){
          aquagls = aquagls + 1;
        } else if (barang[i] == 'Vit_gls') {
          vitgls = vitgls + 1;
        }
      }

      for(int x = 0;x < _datapegawai.length;x++){
        int abssementara = 0;
        for(int y = 0;y < AbsensiSelected.length;y++){
          if (AbsensiSelected[y] == _datapegawai[x].id_pegawai){
            abssementara = abssementara + 1;
          }
        }
        absen.add(abssementara);
      }

      for(int j = 0;j < length_dataPegawai;j++){
        int sawsementara = 0;
        for(int k = 0; k < length_pegawai;k++){
          if (pegawai[k] == _datapegawai[j].Nama){
            sawsementara = sawsementara + 1;
          }
        }
        order.add(sawsementara);
      }

      int nilaimaxabsen = absen.reduce(max);
      int nilaimaxorder = order.reduce(max);

      for(int a = 0;a < absen.length;a++){
        double normalisasiabsen = 0;
        normalisasiabsen = absen[a] / nilaimaxabsen;
        NormalisasiAbsen.add(normalisasiabsen.toStringAsFixed(2));
      }

      for(int a = 0;a < order.length;a++){
        double normalisasiorder = 0;
        normalisasiorder = order[a] / nilaimaxorder;
        NormalisasiOrder.add(normalisasiorder.toStringAsFixed(2));
      }

      for(int a = 0;a < _datapegawai.length;a++){
        double t1 = parameterabsen * double.parse(NormalisasiAbsen[a]);
        double t2 = parameterorder * double.parse(NormalisasiOrder[a]);
        double total = t1 + t2;
        String hasil = total.toStringAsFixed(2);
        saw.add(double.parse(hasil));
      }

      double sawmax = saw.reduce((value, element) => value > element? value: element);

      for(int a = 0;a < saw.length;a++){
        if(sawmax == saw[a]){
          hasilsaw = (a + 1);
        }
      }


      for(int b = 0;b < _datapegawai.length;b++){
        if(hasilsaw.toString() == _datapegawai[b].id_pegawai){
          pegawaiofthemonth = _datapegawai[b].Nama;
        }
      }

      if(jml_odr == 0){
        Hasilpegawaiofthemonth = 'Tidak Ada';
      } else {
        Hasilpegawaiofthemonth = pegawaiofthemonth;
      }

      hargasiulA = hrgsiulA * siulA;
      hargasiulB = hrgsiulB * siulB;
      hargaaqua = hrgaqua * aqua;
      hargavit = hrgvit * vit;
      hargagaskcl = hrggaskcl * gaskcl;
      hargagasbsr = hrggasbsr * gasbsr;
      hargaaquagls = hrgaquagls * aquagls;
      hargavitgls = hrgvitgls * vitgls;

      for(int i = 0;i < length_total;i++){
        kalkulasi = kalkulasi + int.parse(total[i]);
      }

      final oCcy = new NumberFormat.currency(locale: 'id');

      total_pendapatan = oCcy.format(kalkulasi);
    });
  }

  Future<List<DataPenjualan>> getPenjualan() async {
    final responseA = await http.get("http://timothy.buzz/juljol/get_pemesanan_detail_only_selesai.php");
    final responseJsonA= json.decode(responseA.body);

    final responseB = await http.get("http://timothy.buzz/juljol/get_pemesanan_only_selesai.php");
    final responseJsonB= json.decode(responseB.body);

    final responseC = await http.get("http://timothy.buzz/juljol/get_barang.php");
    final responseJsonC= json.decode(responseC.body);

    final responseD = await http.get("http://timothy.buzz/juljol/get_pemesanan_detail_join_pemesanan_id_order.php");
    final responseJsonD= json.decode(responseD.body);

    final responseE = await http.get("http://timothy.buzz/juljol/get_pegawai.php");
    final responseJsonE= json.decode(responseE.body);


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
      for (int i = 0;i < l;i++){
        var bulan = _datapenjualankeseluruhan[i].Tanggal;
        var _bulan = bulan.substring(5,7);
        if (_bulan == '01'){
          _Jan.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '02'){
          _Feb.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '03'){
          _Mar.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '04'){
          _Apr.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '05'){
          _Mei.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '06'){
          _Jun.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '07'){
          _Jul.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '08'){
          _Aug.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '09'){
          _Sep.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '10'){
          _Okt.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '11'){
          _Nov.add(_datapenjualankeseluruhan[i].Total);
        } else if (_bulan == '12'){
          _Des.add(_datapenjualankeseluruhan[i].Total);
        }
      }

      var p = _datapenjualan.length;
      for (int i = 0;i < p;i++){
        var bulan = _datapenjualan[i].Tanggal;
        var _bulan = bulan.substring(5,7);
        if (_bulan == '01'){
          Jan.add(_datapenjualan[i].id_pemesanan);
          Jan_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '02'){
          Feb.add(_datapenjualan[i].id_pemesanan);
          Feb_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '03'){
          Mar.add(_datapenjualan[i].id_pemesanan);
          Mar_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '04'){
          Apr.add(_datapenjualan[i].id_pemesanan);
          Apr_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '05'){
          Mei.add(_datapenjualan[i].id_pemesanan);
          Mei_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '06'){
          Jun.add(_datapenjualan[i].id_pemesanan);
          Jun_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '07'){
          Jul.add(_datapenjualan[i].id_pemesanan);
          Jul_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '08'){
          Aug.add(_datapenjualan[i].id_pemesanan);
          Aug_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '09'){
          Sep.add(_datapenjualan[i].id_pemesanan);
          Sep_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '10'){
          Okt.add(_datapenjualan[i].id_pemesanan);
          Okt_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '11'){
          Nov.add(_datapenjualan[i].id_pemesanan);
          Nov_.add(_datapenjualan[i].Barang);
        } else if (_bulan == '12'){
          Des.add(_datapenjualan[i].id_pemesanan);
          Des_.add(_datapenjualan[i].Barang);
        }
      }

      var o = _dataBarang.length;
      for(int i = 0;i < o;i++){
        if (_dataBarang[i].id_barang == 'siulA'){
          hrgsiulA = int.parse(_dataBarang[i].Harga);
        } else if (_dataBarang[i].id_barang == 'siulB'){
          hrgsiulB = int.parse(_dataBarang[i].Harga);
        } else if (_dataBarang[i].id_barang == 'aqua'){
          hrgaqua = int.parse(_dataBarang[i].Harga);
        } else if (_dataBarang[i].id_barang == 'vit'){
          hrgvit = int.parse(_dataBarang[i].Harga);
        } else if (_dataBarang[i].id_barang == 'gas_kcl'){
          hrggaskcl = int.parse(_dataBarang[i].Harga);
        } else if (_dataBarang[i].id_barang == 'gas_bsr'){
          hrggasbsr = int.parse(_dataBarang[i].Harga);
        } else if (_dataBarang[i].id_barang == 'vit_gls'){
          hrgvitgls = int.parse(_dataBarang[i].Harga);
        } else if (_dataBarang[i].id_barang == 'aqua_gls'){
          hrgaquagls = int.parse(_dataBarang[i].Harga);
        }
      }

      var a = _dataSaw.length;
      for (int i = 0;i < a;i++){
        var bulan = _dataSaw[i].Tanggal;
        var _bulan = bulan.substring(5,7);
        if (_bulan == '01'){
          JanSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '02'){
          FebSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '03'){
          MarSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '04'){
          AprSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '05'){
          MeiSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '06'){
          JunSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '07'){
          JulSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '08'){
          AugSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '09'){
          SepSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '10'){
          OktSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '11'){
          NovSaw.add(_dataSaw[i].pengantar);
        } else if (_bulan == '12'){
          DesSaw.add(_dataSaw[i].pengantar);
        }
      }

      var t = _datapegawai.length;
      var y = _datapenjualan.length;
      for(int i = 0;i < t;i++){
        List absensatuan = [];
        for(int j = 0;j < y;j++){
          if(_datapegawai[i].id_pegawai == _datapenjualan[j].id_pegawai){
            absensatuan.add(_datapenjualan[j].Tanggal);
          }
        }
        absensatuan = absensatuan.toSet().toList();
        for(int k = 0;k < absensatuan.length;k++){
          abseninsert.add(Absensi(_datapegawai[i].id_pegawai,_datapegawai[i].Nama,absensatuan[k]));
        }
      }

      for(int a = 0;a < abseninsert.length;a++){
        var bulan = abseninsert[a].Tanggal;
        var _bulan = bulan.substring(5,7);
        if (_bulan == '01'){
          JanAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '02'){
          FebAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '03'){
          MarAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '04'){
          AprAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '05'){
          MeiAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '06'){
          JunAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '07'){
          JulAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '08'){
          AugAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '09'){
          SepAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '10'){
          OktAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '11'){
          NovAbs.add(abseninsert[a].id_pegawai);
        } else if (_bulan == '12'){
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

    });
  }

  int _currentIndex=0;


  TextEditingController controller = new TextEditingController();
  String filter;

  void initState(){
    super.initState();
    getPenjualan();
  }



  @override
  Widget build(BuildContext context) {
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
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.orangeAccent,
                expandedHeight: 70,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('Laporan',
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 40),
                            alignment: Alignment(-1.0,-1.0),
                            child: Text(
                              'Grafik Order',
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
                        ],
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
                        Container(
                          padding: const EdgeInsets.only(left: 60),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            'Order',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          padding: const EdgeInsets.only(left: 60),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            '$jml_odr',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 60),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            'Pendapatan',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          padding: const EdgeInsets.only(left: 60),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            '$total_pendapatan',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 60),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            'Pegawai Terbaik',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20,bottom: 20),
                          padding: const EdgeInsets.only(left: 60),
                          alignment: Alignment(-1.0,-1.0),
                          child: Text(
                            '$Hasilpegawaiofthemonth',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, left: 20.0, right: 20.0, bottom: 80.0),
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Barang')),
                              DataColumn(label: Text('Terjual')),
                              DataColumn(label: Text('Pendapatan'))
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text('Isi Ulang 5500')),
                                DataCell(Text('$siulA')),
                                DataCell(Text('$hargasiulA')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Isi Ulang 6000')),
                                DataCell(Text('$siulB')),
                                DataCell(Text('$hargasiulB')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Aqua')),
                                DataCell(Text('$aqua')),
                                DataCell(Text('$hargaaqua')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Vit')),
                                DataCell(Text('$vit')),
                                DataCell(Text('$hargavit')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Gas Kecil')),
                                DataCell(Text('$gaskcl')),
                                DataCell(Text('$hargagaskcl')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Gas Besar')),
                                DataCell(Text('$gasbsr')),
                                DataCell(Text('$hargagasbsr')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Vit Gelas')),
                                DataCell(Text('$vitgls')),
                                DataCell(Text('$hargavitgls')),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Aqua Gelas')),
                                DataCell(Text('$aquagls')),
                                DataCell(Text('$hargaaquagls')),
                              ])
                            ]
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
                                    'More',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20,bottom: 20),
                                  padding: const EdgeInsets.only(left: 60, right: 60),
                                  alignment: Alignment(-1.0,-1.0),
                                  child: new SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        color: Colors.orangeAccent,
                                        onPressed: (){
                                          if(_day == "Bulan"){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: new Text("Anda belum memilih data"),
                                                  content: new Text("Mohon untuk memeriksa apakah bar pada list bulan sudah di pilih"),
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
                                          } else {
                                            Navigator.push(context, MaterialPageRoute(builder: (
                                                context) => order_selesai(month: _day)));
                                          }
                                        },
                                        child: const Text(
                                            'Detail Order',
                                            style: TextStyle(fontSize: 20)
                                        ),
                                      )
                                  )
                                ),
                                Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.only(left: 60, right: 60),
                                    alignment: Alignment(-1.0,-1.0),
                                    child: new SizedBox(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15)
                                          ),
                                          color: Colors.orangeAccent,
                                          onPressed: () => _printDocument(_day),
                                          child: const Text(
                                              'Cetak Laporan',
                                              style: TextStyle(fontSize: 20)
                                          ),
                                        )
                                    )
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ]
                ),
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

  DataPenjualan({
    this.id_order,
    this.id_pemesanan,
    this.id_pegawai,
    this.Tanggal,
    this.pengantar,
    this.Total,
    this.Jumlah,
    this.Barang
  });

  factory DataPenjualan.fromJson(Map<String, dynamic> json) {
    return DataPenjualan(
      id_order: json['id_order'],
      id_pegawai: json['id_pegawai'],
      id_pemesanan: json['id_pemesanan'],
      Tanggal: json['Tanggal'],
      pengantar: json['pengantar'],
      Total: json['Total'],
      Barang: json['Barang']
    );
  }
}

class DataPenjualanKeseluruhan {
  String id_order;
  String pengantar;
  String Total;
  String Tanggal;


  DataPenjualanKeseluruhan({
    this.id_order,
    this.pengantar,
    this.Total,
    this.Tanggal
  });

  factory DataPenjualanKeseluruhan.fromJson(Map<String, dynamic> json) {
    return DataPenjualanKeseluruhan(
        id_order: json['id_order'],
        pengantar: json['pengantar'],
        Tanggal: json['Tanggal'],
        Total: json['Total']
    );
  }
}

class DataBarang {
  String id_barang;
  String Nama;
  String Harga;


  DataBarang({
    this.id_barang,
    this.Nama,
    this.Harga,
  });

  factory DataBarang.fromJson(Map<String, dynamic> json) {
    return DataBarang(
        id_barang: json['id_barang'],
        Nama: json['Nama'],
        Harga: json['Harga']
    );
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
        pengantar: json['pengantar']
    );
  }
}

class DataPegawai {
  String id_pegawai;
  String Nama;


  DataPegawai({
    this.id_pegawai,
    this.Nama
  });

  factory DataPegawai.fromJson(Map<String, dynamic> json) {
    return DataPegawai(
        id_pegawai: json['id_pegawai'],
        Nama: json['Nama']
    );
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

  Absensi(this.id_pegawai,this.Nama,this.Tanggal);

  String toString() {
    return '{ ${this.id_pegawai}, ${this.Nama}, ${this.Tanggal} }';
  }
}