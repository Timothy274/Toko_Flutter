class barang{
  String _nama, _harga, _nilai_awal, _id_barang;

  barang(this._nama, this._harga, this._id_barang, this._nilai_awal);

  barang.fromMap(Map<String, dynamic> map) {
    this._id_barang = map['id_barang'];
    this._nama = map['nama'];
    this._harga = map['harga'];
    this._nilai_awal = map['nilai_awal'];
  }

  // getter
  String get id_barang => _id_barang;
  String get nama => _nama;
  String get harga => _harga;
  String get nilai_awal => _nilai_awal;

  set id_barang(String value) {
    _id_barang = value;
  }

  set nama(String value) {
    _nama = value;
  }

  set harga(String value) {
    _harga = value;
  }

  set nilai_awal(String value) {
    _nilai_awal = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id_barang'] = this._id_barang;
    map['nama'] = _nama;
    map['harga'] = _harga;
    map['nilai_awal'] = _nilai_awal;
    return map;
  }
}