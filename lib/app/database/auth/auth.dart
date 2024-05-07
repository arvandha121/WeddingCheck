import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import '../../json/model/users.dart';

class DatabaseHelper {
  final databaseName = "weddingcheck";
  final loginTable = "CREATE TABLE login()";

  // Create user table into our sqlite db
  String users =
      ("CREATE TABLE users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)");
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 1,
      onCreate: ((db, version) async {
        await db.execute(users);
      }),
    );
  }

  // Login Method
  Future<bool> login(Users user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
      "SELECT * FROM users WHERE usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'",
    );

    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Register Method
  Future<int> register(Users user) async {
    final Database db = await initDB();
    return db.insert('users', user.toMap());
  }

  // Users get current details
  Future<Users?> getUsers(String usrName) async {
    final Database db = await initDB();
    var res =
        await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }
}
