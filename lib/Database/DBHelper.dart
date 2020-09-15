import 'package:path_provider/path_provider.dart';
import 'package:safety/Database/password.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:io' as io;
import 'dart:async';

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'SafetyData');
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE password("
        "id INTEGER PRIMARY KEY, "
        "title TEXT, "
        "pass TEXT, "
        "name TEXT, "
        "link TEXT, "
        "sortDate TEXT)");
    print('DB Created');
  }

  Future<int> savePass(Password password) async {
    var dbClient = await db;
    int res = await dbClient.insert("password", password.toMap());
    print('data inserted');
    return res;
  }

  Future<List<Password>> getPass() async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery("SELECT * FROM password ORDER BY sortDate DESC");
    List<Password> passdata = List();
    for (int i = 0; i < list.length; i++) {
      var pass = Password(list[i]["title"], list[i]["pass"], list[i]["name"],
          list[i]["link"], list[i]["sortDate"]);
      pass.setPassId(list[i]["id"]);
      passdata.add(pass);
    }

    return passdata;
  }

  Future<bool> updatePass(Password password) async {
    var dbClient = await db;
    int res = await dbClient.update("password", password.toMap(),
        where: "id=?", whereArgs: <int>[password.id]);
    return res > 0 ? true : false;
  }

  Future<int> deletePass(Password password) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM password WHERE id= ?", [password.id]);
    return res;
  }
}