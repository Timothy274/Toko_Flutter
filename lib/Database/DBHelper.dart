import 'dart:async';
import 'dart:io';
import 'package:juljol/Model/OdrMsk.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static DBHelper _dbHelper;
  static Database _database;

  DBHelper._createObject();

  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {

    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'barang.db';

    //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE barang (
        id_barang TEXT PRIMARY KEY,
        nama TEXT,
        harga TEXT,
        nilai_awal TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('barang', orderBy: 'nama');
    return mapList;
  }

//create databases
  Future<int> insert(barang object) async {
    Database db = await this.database;
    int count = await db.insert('barang', object.toMap());
    return count;
  }
//update databases
  Future<int> update(barang object) async {
    Database db = await this.database;
    int count = await db.update('barang', object.toMap(),
        where: 'id=?',
        whereArgs: [object.id_barang]);
    return count;
  }

  Future<List<barang>> getbaranglist() async {
    var contactMapList = await select();
    int count = contactMapList.length;
    List<barang> barangList = List<barang>();
    for (int i=0; i<count; i++) {
      barangList.add(barang.fromMap(contactMapList[i]));
    }
    return barangList;
  }
}