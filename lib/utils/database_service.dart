import 'dart:async';
import 'package:path/path.dart';
import 'package:pricesense/model/cities.dart';
import 'package:pricesense/model/food_item_dbmodel.dart';
import 'package:pricesense/model/macroeconomics_model.dart';
import 'package:pricesense/model/markets.dart';
import 'package:pricesense/model/online_store_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pricesense/model/food_item_model.dart';
import 'package:pricesense/model/enery_model.dart';

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
    await db.execute(
      'CREATE TABLE city(id TEXT PRIMARY KEY, name TEXT)',
    );
    await db.execute(
      'CREATE TABLE macroeconomics('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'officialUsdExchangeRate INTEGER, '
      'monetaryPolicyRate INTEGER, '
      'minimumDiscountRate INTEGER, '
      'interbankCallRate INTEGER, '
      'treasuryBillRate INTEGER, '
      'savingsDepositRate INTEGER, '
      'primeLendingRate INTEGER, '
      'marketCapitalization INTEGER, '
      'allShareIndex INTEGER, '
      'turnOverRatio INTEGER, '
      'valueShareTraded INTEGER, '
      'totalListingStocks INTEGER'
      ')',
    );
    await db.execute(
      'CREATE TABLE onlinestore ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'store TEXT,'
      'foodItem TEXT,'
      'price INTEGER,'
      'brand TEXT,'
      'measurement TEXT'
      ')',
    );
    await db.execute(
      'CREATE TABLE energy ('
      'city TEXT PRIMARY KEY,'
      'unofficialusdexchangerate INTEGER,'
      'pricepetrolindependent INTEGER,'
      'pricepetrolnnpc INTEGER,'
      'pricedieselindependent INTEGER,'
      'pricedieselnnpc INTEGER'
      ')',
    );
  }

  Future<void> insertEnergy(EnergyModel energy) async {
    final db = await database;
    await db.insert(
      'energy',
      energy.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EnergyModel>> getEnergy() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('energy');
    return List.generate(maps.length, (i) {
      return EnergyModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteEnergy(String city) async {
    final db = await database;
    await db.delete(
      'energy',
      where: 'city = ?',
      whereArgs: [city],
    );
  }

  Future<void> insertOnlinestore(OnlineStoreModel onlineStore) async {
    final db = await database;
    await db.insert('onlinestore', onlineStore.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<OnlineStoreModel>> getOnlinestore() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('onlinestore');
    return List.generate(maps.length, (i) {
      return OnlineStoreModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteOnlinestore(int id) async {
    final db = await database;
    await db.delete(
      'onlinestore',
      where: 'id = ?',
      whereArgs: [id],
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
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM surveys'));
    return count ?? 0;
  }

  Future<int> getCoordinatorCount() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM energy'));
    return count ?? 0;
  }

  Future<void> deleteSurvey(int? id) async {
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
      List<Market> markets =
          marketMaps.map((marketMap) => Market.fromMap(marketMap)).toList();
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
    await db.delete('city');
  }

  Future<void> insertCityData(cityData city) async {
    final db = await database;
    await db.insert(
      'city',
      {'id': city.id, 'name': city.name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<cityData>> getCity() async {
    final db = await database;
    final List<Map<String, dynamic>> cityMap = await db.query('city');
    return List.generate(cityMap.length, (i) {
      return cityData(
        id: cityMap[i]['_id'],
        name: cityMap[i]['name'],
      );
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'CREATE TABLE macroeconomics('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'officialUsdExchangeRate INTEGER, '
        'monetaryPolicyRate INTEGER, '
        'minimumDiscountRate INTEGER, '
        'interbankCallRate INTEGER, '
        'treasuryBillRate INTEGER, '
        'savingsDepositRate INTEGER, '
        'primeLendingRate INTEGER, '
        'marketCapitalization INTEGER, '
        'allShareIndex INTEGER, '
        'turnOverRatio INTEGER, '
        'valueShareTraded INTEGER, '
        'totalListingStocks INTEGER'
        ')',
      );
    }
  }

  // Macroeconomics CRUD operations
  Future<void> insertMacroeconomics(MacroeconomicsModel model) async {
    final db = await database;
    await db.insert(
      'macroeconomics',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MacroeconomicsModel>> getMacroeconomics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('macroeconomics');
    return List.generate(maps.length, (i) {
      return MacroeconomicsModel.fromMap(maps[i]);
    });
  }

  Future<void> deleteMacroeconomics(int id) async {
    final db = await database;
    await db.delete(
      'macroeconomics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
