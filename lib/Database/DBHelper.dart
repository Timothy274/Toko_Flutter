import 'dart:async';
import 'dart:io' as io;
import 'package:juljol/Model/OdrMsk.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  final String TABLE_NAME = "OdrMsk";
  static Database db_instance;

  Future<Database> get db async{
    if(db_instance == null)
        db_instance = await initDB();
    return db_instance;
  }

  initDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"juljol.db");
    var db = await openDatabase(path,version: 1,onCreate: onCreateFunc);
    return db;
  }

  void onCreateFunc(Database db, int version) async {
    await db.execute('CREATE TABLE $TABLE_NAME(id STRING PRIMARY KEY,alamat STRING,pegawai STRING,catatan STRING,siul INT,aqua INT,vit INT,gaskcl INT,gasbsr INT,vitgls INT,aquagls INT)');
  }

  Future<List<OdrMsk>> getOdrMsk() async{
    var koneksi_db = await db;
    List<Map> list = await koneksi_db.rawQuery('SELECT * FROM $TABLE_NAME');
    List<OdrMsk> odrmsks = new List();
    for(int i = 0;i< list.length;i++)
      {
        OdrMsk odrmsk = new OdrMsk();
        odrmsk.id = list[i]['id'];
        odrmsk.alamat = list[i]['alamat'];
        odrmsk.pegawai = list[i]['pegawai'];
        odrmsk.catatan = list[i]['catatan'];
        odrmsk.siul = list[i]['siul'];
        odrmsk.aqua = list[i]['aqua'];
        odrmsk.vit = list[i]['vit'];
        odrmsk.gasbsr = list[i]['gasbsr'];
        odrmsk.gaskcl = list[i]['gaskcl'];
        odrmsk.aquagls = list[i]['aquagls'];
        odrmsk.vitgls = list[i]['vitgls'];

        odrmsks.add(odrmsk);
      }
    return odrmsks;
  }

  void  addNewOdrmsk(OdrMsk odrMsk) async{
    var db_connection = await db;
    String query = 'INSERT INTO $TABLE_NAME(id,alamat,pegawai,catatan,siul,aqua,vit,gasbsr,gaskcl,vitgls,aquagls) VALUES (\'${odrMsk.id}\',\'${odrMsk.alamat}\',\'${odrMsk.pegawai}\',\'${odrMsk.catatan}\',\'${odrMsk.siul}\',\'${odrMsk.aqua}\',\'${odrMsk.vit}\',\'${odrMsk.gasbsr}\',\'${odrMsk.gaskcl}\',\'${odrMsk.vitgls}\',\'${odrMsk.aquagls}\')';
    await db_connection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  void  updateOdrmsk(OdrMsk odrMsk) async{
    var db_connection = await db;
    String query = 'UPDATE $TABLE_NAME SET alamat=\'${odrMsk.alamat}\',pegawai=\'${odrMsk.pegawai}\',catatan=\'${odrMsk.catatan}\',siul=\'${odrMsk.siul}\',aqua=\'${odrMsk.aqua}\',vit=\'${odrMsk.vit}\',gasbsr=\'${odrMsk.gasbsr}\',gaskcl=\'${odrMsk.gaskcl}\',vitgls=\'${odrMsk.vitgls}\',aquagls=\'${odrMsk.aquagls}\' WHERE id=${odrMsk.id}';
    await db_connection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }

  void  deleteOdrmsk(OdrMsk odrMsk) async{
    var db_connection = await db;
    String query = 'DELETE FROM $TABLE_NAME WHERE id=${odrMsk.id}';
    await db_connection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }
}