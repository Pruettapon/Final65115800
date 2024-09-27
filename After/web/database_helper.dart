import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "PlantDatabase.db";
  static final _databaseVersion = 1;

  static final tablePlant = 'Plant';
  static final tablePlantComponent = 'PlantComponent';
  static final tableLandUseType = 'LandUseType';
  static final tableLandUse = 'LandUse';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tablePlant (
        plantID INTEGER PRIMARY KEY,
        plantName TEXT NOT NULL,
        plantScientific TEXT,
        plantImage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePlantComponent (
        componentID INTEGER PRIMARY KEY,
        componentName TEXT NOT NULL,
        componentIcon TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableLandUseType (
        LandUseTypeID INTEGER PRIMARY KEY,
        LandUseTypeName TEXT NOT NULL,
        LandUseTypeDescription TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableLandUse (
        LandUseID INTEGER PRIMARY KEY,
        plantID INTEGER NOT NULL,
        componentID INTEGER NOT NULL,
        LandUseTypeID INTEGER NOT NULL,
        LandUseDescription TEXT,
        FOREIGN KEY (plantID) REFERENCES $tablePlant (plantID),
        FOREIGN KEY (componentID) REFERENCES $tablePlantComponent (componentID),
        FOREIGN KEY (LandUseTypeID) REFERENCES $tableLandUseType (LandUseTypeID)
      )
    ''');
  }
  // ฟังก์ชันสำหรับเพิ่มข้อมูลเบื้องต้น
  Future<void> insertInitialData() async {
    await insertInitialPlants();
    await insertInitialPlantComponents();
    await insertInitialLandUseTypes();
    await insertInitialLandUses();
  }

  Future<void> insertInitialPlants() async {
    final existingPlants = await queryAllPlants();
    List<int> existingPlantIds = existingPlants.map((e) => e['plantID'] as int).toList();

    if (!existingPlantIds.contains(1001)) {
      await insertPlant({
        'plantID': 1001,
        'plantName': 'Mango',
        'plantScientific': 'Mangifera indica',
        'plantImage': 'https://befreshcorp.net/wp-content/uploads/2017/07/product-packshot-mango.jpg'
      });
    }

    if (!existingPlantIds.contains(1002)) {
      await insertPlant({
        'plantID': 1002,
        'plantName': 'Neem',
        'plantScientific': 'Azadirachta indica',
        'plantImage': 'https://m.media-amazon.com/images/I/61EmPulWbdL._AC_UF1000,1000_QL80_.jpg'
      });
    }

    if (!existingPlantIds.contains(1003)) {
      await insertPlant({
        'plantID': 1003,
        'plantName': 'Bamboo',
        'plantScientific': 'Bambusa vulgaris',
        'plantImage':'https://img.freepik.com/premium-photo/bamboo-is-plant-that-is-used-chinese-culture_826801-757.jpg'
      });
    }

    if (!existingPlantIds.contains(1004)) {
      await insertPlant({
        'plantID': 1004,
        'plantName': 'Ginger',
        'plantScientific': 'Zingiber officinale',
        'plantImage': 'https://media-cldnry.s-nbcnews.com/image/upload/t_social_share_1024x768_scale,f_auto,q_auto:best/newscms/2016_29/1144225/ginger-002-tease-today-160719.JPG'
      });
    }
  }

  Future<void> insertInitialPlantComponents() async {
    final existingComponents = await queryAllComponents();
    List<int> existingComponentIds = existingComponents.map((e) => e['componentID'] as int).toList();

    if (!existingComponentIds.contains(1101)) {
      await insertPlantComponent({
        'componentID': 1101,
        'componentName': 'Leaf',
        'componentIcon': 'https://cdn-icons-png.flaticon.com/512/4218/4218664.png'
      });
    }

    if (!existingComponentIds.contains(1102)) {
      await insertPlantComponent({
        'componentID': 1102,
        'componentName': 'Flower',
        'componentIcon': 'https://cdn-icons-png.flaticon.com/512/740/740909.png'
      });
    }

    if (!existingComponentIds.contains(1103)) {
      await insertPlantComponent({
        'componentID': 1103,
        'componentName': 'Fruit',
        'componentIcon': 'https://cdn-icons-png.flaticon.com/512/3082/3082005.png'
      });
    }

    if (!existingComponentIds.contains(1104)) {
      await insertPlantComponent({
        'componentID': 1104,
        'componentName': 'Stem',
        'componentIcon': 'https://static.vecteezy.com/system/resources/previews/014/364/978/non_2x/forest-tree-icon-cartoon-style-vector.jpg'
      });
    }

    if (!existingComponentIds.contains(1105)) {
      await insertPlantComponent({
        'componentID': 1105,
        'componentName': 'Root',
        'componentIcon': 'https://cdn-icons-png.flaticon.com/512/3239/3239326.png'
      });
    }
  }

  Future<void> insertInitialLandUseTypes() async {
    final existingLandUseTypes = await queryAllLandUseTypes();
    List<int> existingLandUseTypeIds = existingLandUseTypes.map((e) => e['LandUseTypeID'] as int).toList();

    if (!existingLandUseTypeIds.contains(1301)) {
      await insertLandUseType({
        'LandUseTypeID': 1301,
        'LandUseTypeName': 'Food',
        'LandUseTypeDescription': 'Used as food or ingredients'
      });
    }

    if (!existingLandUseTypeIds.contains(1302)) {
      await insertLandUseType({
        'LandUseTypeID': 1302,
        'LandUseTypeName': 'Medicine',
        'LandUseTypeDescription': 'Used for medicinal purposes'
      });
    }

    if (!existingLandUseTypeIds.contains(1303)) {
      await insertLandUseType({
        'LandUseTypeID': 1303,
        'LandUseTypeName': 'Insecticide',
        'LandUseTypeDescription': 'Used to repel insects'
      });
    }

    if (!existingLandUseTypeIds.contains(1304)) {
      await insertLandUseType({
        'LandUseTypeID': 1304,
        'LandUseTypeName': 'Construction',
        'LandUseTypeDescription': 'Used in building materials'
      });
    }

    if (!existingLandUseTypeIds.contains(1305)) {
      await insertLandUseType({
        'LandUseTypeID': 1305,
        'LandUseTypeName': 'Culture',
        'LandUseTypeDescription': 'Used in traditional practices'
      });
    }
  }

  Future<void> insertInitialLandUses() async {
    final existingLandUses = await queryAllLandUses();
    List<int> existingLandUseIds = existingLandUses.map((e) => e['LandUseID'] as int).toList();

    if (!existingLandUseIds.contains(2001)) {
      await insertLandUse({
        'LandUseID': 2001,
        'plantID': 1001,
        'componentID': 1103,
        'LandUseTypeID': 1301,
        'LandUseDescription': 'Mango fruit is eaten fresh or dried'
      });
    }

    if (!existingLandUseIds.contains(2002)) {
      await insertLandUse({
        'LandUseID': 2002,
        'plantID': 1002,
        'componentID': 1101,
        'LandUseTypeID': 1302,
        'LandUseDescription': 'Neem leaves are used to treat skin infections'
      });
    }

    if (!existingLandUseIds.contains(2003)) {
      await insertLandUse({
        'LandUseID': 2003,
        'plantID': 1003,
        'componentID': 1104,
        'LandUseTypeID': 1304,
        'LandUseDescription': 'Bamboo stems are used in building houses'
      });
    }

    if (!existingLandUseIds.contains(2004)) {
      await insertLandUse({
        'LandUseID': 2004,
        'plantID': 1004,
        'componentID': 1105,
        'LandUseTypeID': 1302,
        'LandUseDescription': 'Ginger roots are used for digestive issues'
      });
    }
  }



  // ฟังก์ชัน insert สำหรับแต่ละตาราง
  Future<int> insertPlant(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tablePlant, row);
  }

  Future<int> insertPlantComponent(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tablePlantComponent, row);
  }

  Future<int> insertLandUseType(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableLandUseType, row);
  }

  Future<int> insertLandUse(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableLandUse, row);
  }

  Future<List<Map<String, dynamic>>> queryAllPlants() async {
    Database db = await instance.database;
    return await db.query(tablePlant);
  }

  Future<List<Map<String, dynamic>>> queryAllComponents() async {
    Database db = await instance.database;
    return await db.query(tablePlantComponent);
  }

  Future<List<Map<String, dynamic>>> queryAllLandUses() async {
    Database db = await instance.database;
    return await db.query(tableLandUse);
  }

  Future<List<Map<String, dynamic>>> queryAllLandUseTypes() async {
    Database db = await instance.database;
    return await db.query(tableLandUseType);
  }

  // ฟังก์ชัน queryPlantComponents: ดึงชิ้นส่วนพืชที่เกี่ยวข้องกับ plantID
  Future<List<Map<String, dynamic>>> queryPlantComponents(int plantID) async {
    final db = await database;
    return await db.query(
      tablePlantComponent,
      where: 'componentID IN (SELECT componentID FROM LandUse WHERE plantID = ?)',
      whereArgs: [plantID],
    );
  }

  // ฟังก์ชัน queryPlantUses: ดึงการใช้ประโยชน์ของพืชที่เกี่ยวข้องกับ plantID
  Future<List<Map<String, dynamic>>> queryPlantUses(int plantID) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT LandUseType.LandUseTypeName, LandUse.LandUseDescription 
      FROM LandUse
      JOIN LandUseType ON LandUse.LandUseTypeID = LandUseType.LandUseTypeID
      WHERE LandUse.plantID = ?
    ''', [plantID]);
  }

  // ฟังก์ชัน queryPlantUsesAndComponents: ดึงข้อมูลการใช้ประโยชน์และชิ้นส่วนพืช
  Future<List<Map<String, dynamic>>> queryPlantUsesAndComponents(int plantID) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT LandUseType.LandUseTypeName, LandUse.LandUseDescription, 
             PlantComponent.componentName, PlantComponent.componentIcon
      FROM LandUse
      JOIN LandUseType ON LandUse.LandUseTypeID = LandUseType.LandUseTypeID
      JOIN PlantComponent ON LandUse.componentID = PlantComponent.componentID
      WHERE LandUse.plantID = ?
    ''', [plantID]);
  }
  Future<List<Map<String, dynamic>>> queryPlantsByComponent(int componentID) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT Plant.plantName, Plant.plantScientific, Plant.plantImage, LandUse.LandUseDescription
    FROM Plant
    JOIN LandUse ON Plant.plantID = LandUse.plantID
    WHERE LandUse.componentID = ?
  ''', [componentID]);
  }
// ใน DatabaseHelper

  Future<Map<String, dynamic>> queryPlantById(int plantID) async {
    final db = await database;
    final result = await db.query('Plant', where: 'plantID = ?', whereArgs: [plantID]);
    return result.first;
  }

  Future<Map<String, dynamic>> queryComponentById(int componentID) async {
    final db = await database;
    final result = await db.query('PlantComponent', where: 'componentID = ?', whereArgs: [componentID]);
    return result.first;
  }

}
