import 'dart:async';
import 'package:path/path.dart';
import 'package:pricesense/model/food_item_dbmodel.dart';
import 'package:pricesense/model/markets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pricesense/model/food_item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'collections.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE foodItems(id TEXT PRIMARY KEY, name TEXT, brand TEXT, measurement TEXT)',
    );
   await db.execute(
    'CREATE TABLE surveys('
    'id INTEGER PRIMARY KEY AUTOINCREMENT, '
    'marketid TEXT, '
    'foodId TEXT, '
    'distributionType TEXT, '
    'brand TEXT, '
    'measurement TEXT, '
    'userId TEXT, '
    'price INTEGER, '
    'foodname TEXT, '
    'shoprent INTEGER, '
    'taxandLevies INTEGER, ' 
    'location TEXT' 
    ')',
  );
  await db.execute(
      'CREATE TABLE cities(id TEXT PRIMARY KEY, name TEXT)',
    );
    await db.execute(
      'CREATE TABLE markets(id TEXT PRIMARY KEY, name TEXT, cityId TEXT)',
    );
  }

  // FoodItem CRUD operations
  Future<void> insertFoodItem(FoodItem item) async {
    final db = await database;
    await db.insert(
      'foodItems',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodItem>> getFoodItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('foodItems');
    return List.generate(maps.length, (i) {
      return FoodItem.fromMap(maps[i]);
    });
  }

  Future<void> deleteFoodItems() async {
    final db = await database;
    await db.delete('foodItems');
  }

  // Survey CRUD operations
  Future<void> insertSurvey(FoodItemDbModel survey) async {
    final db = await database;
    await db.insert(
      'surveys',
      survey.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodItemDbModel>> getSurveys() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('surveys');
    return List.generate(maps.length, (i) {
      return FoodItemDbModel(
       id: maps[i]['id'],
        marketid: maps[i]['marketid'],
        foodId: maps[i]['foodId'],
        distributionType: maps[i]['distributionType'],
        brand: maps[i]['brand'],
        measurement: maps[i]['measurement'],
        userId: maps[i]['userId'],
        price: maps[i]['price'],
        location: maps[i]['location'],
        foodname: maps[i]['foodname'],
        shoprent: maps[i]['shoprent'],
        taxandLevies: maps[i]['taxandLevies'],
      );
    });
  }

  Future<int> getSurveyCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM surveys'));
    return count ?? 0;
  }

  Future<void> deleteSurvey( int? id) async {
    final db = await database;
    await db.delete(
      'surveys',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
   Future<void> insertCity(City city) async {
    final db = await database;
    await db.insert(
      'cities',
      {'id': city.id, 'name': city.name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (var market in city.markets) {
      await insertMarket(market, city.id);
    }
  }

  Future<List<City>> getCities() async {
    final db = await database;
    final List<Map<String, dynamic>> cityMaps = await db.query('cities');
    List<City> cities = [];
    for (var cityMap in cityMaps) {
      final List<Map<String, dynamic>> marketMaps = await db.query(
        'markets',
        where: 'cityId = ?',
        whereArgs: [cityMap['id']],
      );
      List<Market> markets = marketMaps.map((marketMap) => Market.fromMap(marketMap)).toList();
      cities.add(City(
        id: cityMap['id'],
        name: cityMap['name'],
        markets: markets,
      ));
    }
    return cities;
  }

  Future<void> insertMarket(Market market, String cityId) async {
    final db = await database;
    await db.insert(
      'markets',
      {'id': market.id, 'name': market.name, 'cityId': cityId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCities() async {
    final db = await database;
    await db.delete('cities');
    await db.delete('markets');
  }
}

