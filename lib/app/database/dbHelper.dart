import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:weddingcheck/app/model/listItem.dart';
import 'package:weddingcheck/app/model/users.dart';
// Update this path to where your ListItem model is located

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'weddingcheck.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        usrId INTEGER PRIMARY KEY AUTOINCREMENT,
        usrName TEXT UNIQUE,
        usrPassword TEXT
      );
    ''');

    // Create list table
    await db.execute('''
      CREATE TABLE list (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        alamat TEXT NOT NULL,
        kota TEXT NOT NULL,
        kecamatan TEXT NOT NULL,
        keluarga TEXT,
        gambar TEXT NOT NULL,
        keterangan TEXT NOT NULL DEFAULT 'belum hadir' CHECK(keterangan IN ('hadir', 'belum hadir'))
      );
    ''');
  }

  // User-related operations
  Future<bool> login(Users user) async {
    final db = await database;
    var result = await db.rawQuery(
      "SELECT * FROM users WHERE usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'",
    );

    return result.isNotEmpty;
  }

  Future<int> register(Users user) async {
    final db = await database;
    return db.insert('users', user.toMap());
  }

  Future<Users?> getUsers(String usrName) async {
    final db = await database;
    var res =
        await db.query("users", where: "usrName = ?", whereArgs: [usrName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  // List-related operations
  Future<int> insertListItem(ListItem listItem) async {
    final db = await database;
    return db.insert('list', listItem.toMap());
  }

  // List-related operations
  Future<List<ListItem>> readListItem({String query = ''}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (query.isEmpty) {
      maps = await db.query('list');
    } else {
      maps = await db.query(
        'list',
        where: 'nama LIKE ? OR alamat LIKE ? OR keluarga LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
      );
    }
    return List.generate(maps.length, (i) {
      return ListItem.fromMap(maps[i]);
    });
  }

  Future<int> updateListItem(ListItem listItem) async {
    final db = await database;
    return db.update(
      'list',
      listItem.toMap(),
      where: 'id = ?',
      whereArgs: [listItem.id],
    );
  }

  Future<int> deleteListItem(int id) async {
    final db = await database;
    return db.delete(
      'list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllListItems() async {
    final db = await database;
    await db.delete('list'); // Deletes all rows in the 'list' table
  }
}
