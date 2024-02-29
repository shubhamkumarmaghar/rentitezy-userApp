/*
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import '../utils/const/app_urls.dart';
import 'fav_model.dart'; */

/*
class DbHelper {
  static const _databaseName = "favmodel_database.db";
  static const _databaseVersion = 1;
  static const table = 'favmodel';
  static const userId = 'userId';
  static const count = 'count';
  static const proID = 'proID';

  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE FavModel(id INTEGER PRIMARY KEY,proID TEST,userId TEST, ownerId TEXT, relationShip TEXT, name TEXT, type TEXT, plots TEXT, floor TEXT, facility TEXT,amenities TEXT,address TEXT,area TEXT, city TEXT, latlng TEXT, photo TEXT, video TEXT, description TEXT,price TEXT,ownerPhone TEXT,createdOn TEXT)',
    );
  }

  Future<HashMap?> getFavIdsMap(String userID) async {
    Database db = await instance.database;
    HashMap hashMap = HashMap<String, String>();
    var result = await db.query(
      table,
      where: 'userId = ?',
      whereArgs: [userID],
    );

    if (result.isNotEmpty) {
      for (var element in result) {
        hashMap[element['proID'].toString()] = element['count'].toString();
      }
    }
    return hashMap;
  }

  Future<void> insertFav(FavModel favModel) async {
    Database db = await instance.database;
    var removed = favModel.toMap();
    removed.remove("id");
    var i = await db.insert(table, removed);
    if (kDebugMode) {
      print(i);
    }
  }

  Future<List<FavModel>> favModels() async {
    Database db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return FavModel(
          id: maps[i]['id'],
          proID: maps[i]['proID'],
          userId: maps[i]['userId'],
          ownerId: maps[i]['ownerId'],
          relationShip: maps[i]['relationShip'],
          name: maps[i]['name'],
          type: maps[i]['type'],
          plots: maps[i]['plots'],
          floor: maps[i]['floor'],
          facility: maps[i]['facility'],
          amenities: maps[i]['amenities'],
          address: maps[i]['address'],
          area: maps[i]['area'],
          city: maps[i]['city'],
          latlng: maps[i]['latlng'],
          photo: maps[i]['photo'],
          video: maps[i]['video'],
          description: maps[i]['description'],
          price: maps[i]['price'],
          ownerPhone: AppUrls.phone,
          images: [],
          amenitiesList: [],
          createdOn: maps[i]['createdOn']);
    });
  }

  Future<int> getFavCount(String userId) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db
            .rawQuery("SELECT COUNT(*) FROM $table where userId ='$userId'")) ??
        0;
  }

  Future<List<int>?> getFavIds(String userID) async {
    Database db = await instance.database;

    var result = await db.query(
      table,
      where: 'userId = ?',
      whereArgs: [userID],
    );

    if (result.isNotEmpty) {
      return List.generate(result.length, (i) {
        return int.parse(result[i]['proID'].toString());
      });
    } else {
      return [];
    }
  }

  Future<bool> updateUserIds(String userId) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {DbHelper.userId: userId};
    await db.update(
      table,
      row,
      where: 'userId = ?',
      whereArgs: ["guest"],
    );
    return true;
  }

  Future<HashMap> getFavIdVsCountMap(String userID, bool isFav) async {
    Database db = await instance.database;
    HashMap hashMap = HashMap<String, FavModel>();
    var result = await db.query(
      table,
      where: 'userId = ?',
      whereArgs: [userID],
    );

    if (result.isNotEmpty) {
      for (var element in result) {
        FavModel favModel = FavModel(
          id: int.parse(element['id'].toString()),
          proID: element['proID'].toString(),
          userId: element['userId'].toString(),
          ownerId: element['ownerId'].toString(),
          relationShip: element['relationShip'].toString(),
          name: element['name'].toString(),
          type: element['type'].toString(),
          plots: element['plots'].toString(),
          floor: element['floor'].toString(),
          facility: element['facility'].toString(),
          amenities: element['amenities'].toString(),
          address: element['address'].toString(),
          area: element['area'].toString(),
          city: element['city'].toString(),
          latlng: element['latlng'].toString(),
          photo: element['photo'].toString(),
          video: element['video'].toString(),
          description: element['description'].toString(),
          price: element['price'].toString(),
          ownerPhone: element['ownerPhone'].toString(),
          images: [],
          amenitiesList: [],
          createdOn: element['createdOn'].toString(),
        );
        if (isFav) {
          hashMap["${element['proID']}-${element['proID']}"] = favModel;
        } else {
          hashMap[element['proID'].toString()] = favModel;
        }
      }
    }
    return hashMap;
  }

  Future<FavModel?> getFavItem(String proid, String userID) async {
    Database db = await instance.database;

    var result = await db.query(
      table,
      where: 'proID = ? AND userId = ?',
      whereArgs: [proid, userID],
    );

    if (result.isNotEmpty) {
      Map<String, dynamic> resultVal = result.first;
      FavModel favModel = FavModel(
        id: resultVal['id'],
        proID: resultVal['proID'].toString(),
        userId: resultVal['userId'].toString(),
        ownerId: resultVal['ownerId'].toString(),
        relationShip: resultVal['relationShip'].toString(),
        name: resultVal['name'],
        type: resultVal['type'],
        plots: resultVal['plots'],
        floor: resultVal['floor'],
        facility: resultVal['facility'],
        amenities: resultVal['amenities'],
        address: resultVal['address'],
        area: resultVal['area'],
        city: resultVal['city'],
        latlng: resultVal['latlng'],
        photo: resultVal['photo'],
        video: resultVal['video'],
        description: resultVal['description'],
        price: resultVal['price'],
        ownerPhone: AppUrls.phone,
        images: [],
        amenitiesList: [],
        createdOn: resultVal['createdOn'],
      );

      return favModel;
    }
    return null;
  }

  Future<bool> isInFav(String userID, String proid) async {
    Database db = await instance.database;
    int size = Sqflite.firstIntValue(await db.rawQuery(
            "SELECT COUNT(*) FROM $table where $proID = '$proid' AND $userId = '$userID'")) ??
        0;
    return size > 0;
  }

  Future<int> favCount(String proid, String userID) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
            "SELECT COUNT(*) FROM $table where $proID = '$proid' AND $userId = '$userID'")) ??
        0;
  }

  Future<void> updateFav(FavModel favModel) async {
    Database db = await instance.database;
    var removed = favModel.toMap();
    removed.remove("id");
    await db.update(
      table,
      removed,
      where: 'proID = ? AND userId = ?',
      whereArgs: [favModel.id, favModel.userId],
    );
  }

  Future<void> updateFavCount(String userid, String productId, String count,
      String proid, String price, String singlePrice) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      "count": count,
      "price": price,
      "singlePrice": singlePrice
    };
    await db.update(
      table,
      row,
      where: 'proID = ? AND userId = ? AND proID = ?',
      whereArgs: [productId, userid, proid],
    );
  }

  Future<void> deleteFav(String proid, String userId) async {
    Database db = await instance.database;
    await db.delete(
      table,
      where: 'proID = ? AND userId = ?',
      whereArgs: [proid, userId],
    );
  }

  Future<void> deleteFavAll(String userId) async {
    Database db = await instance.database;
    await db.delete(
      table,
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
*/