import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Import sqflite
import 'web/database_helper.dart'; // Update this to your project structure
import 'homepage.dart';
import 'searh_page.dart';
import 'add_plant_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Database? database;

  // Initialize the database and handle potential errors
  try {
    database = await DatabaseHelper.instance.database;
  } catch (e) {
    print('Database initialization error: $e');
    return; // Exit if the database cannot be initialized
  }

  runApp(MyApp(database: database!)); // Use non-null assertion
}

class MyApp extends StatelessWidget {
  final Database database;

  MyApp({required this.database}); // Use named parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Database App',
      theme: ThemeData(
        primarySwatch: Colors.teal, // เปลี่ยนสีหลักของแอปพลิเคชันเป็นสี teal
         // สี accent สำหรับ UI อื่นๆ
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[700], // สีของ AppBar
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.teal[900], // สีของ Bottom Navigation Bar
          selectedItemColor: Colors.amber,   // สีของไอเทมที่ถูกเลือก
          unselectedItemColor: Colors.white70, // สีของไอเทมที่ยังไม่ถูกเลือก
        ),
      ),
      home: HomePage(database: database), // Pass the database instance here
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/search':
            return MaterialPageRoute(
              builder: (context) => SearchPage(database: database),
            );
          case '/addPlant':
            return MaterialPageRoute(
              builder: (context) => AddPlantPage(database: database),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => HomePage(database: database), // Default route
            );
        }
      },
    );
  }
}
