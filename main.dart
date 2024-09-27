import 'package:flutter/material.dart';
import 'plant_page.dart';
import 'plant_component_page.dart';
import 'land_use_type_page.dart';
import 'land_use_page.dart'; // นำเข้า LandUsePage

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอพเรียนรู้พืช',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แอพเรียนรู้พืช'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.nature, color: Colors.green, size: 30),
                title: Text(
                  'ข้อมูลพืชทั้งหมด',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.category, color: Colors.green, size: 30),
                title: Text(
                  'ประเภทการใช้ประโยชน์ของพืช',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LandUseTypePage()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.grass, color: Colors.green, size: 30),
                title: Text(
                  'ชิ้นส่วนของพืช',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlantComponentPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // ปุ่มใหม่ที่เพิ่มสำหรับ LandUsePage
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.local_florist, color: Colors.green, size: 30),
                title: Text(
                  'การใช้ประโยชน์ของพืช',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LandUsePage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
