import 'package:flutter/material.dart';
import 'web/database_helper.dart';
import 'PlantsByComponentPage.dart';

class PlantComponentPage extends StatefulWidget {
  const PlantComponentPage({Key? key}) : super(key: key);

  @override
  _PlantComponentPageState createState() => _PlantComponentPageState();
}

class _PlantComponentPageState extends State<PlantComponentPage> {
  late Future<List<Map<String, dynamic>>> _componentList;

  @override
  void initState() {
    super.initState();
    _componentList = DatabaseHelper.instance.queryAllComponents();
  }

  // ฟังก์ชันดึงรายการพืชที่ใช้ประโยชน์จากชิ้นส่วนพืช
  void _showPlantsUsingComponent(int componentID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantsByComponentPage(componentID: componentID),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ชิ้นส่วนของพืช'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _componentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูลชิ้นส่วนพืช'));
          }

          final components = snapshot.data!;
          return ListView.builder(
            itemCount: components.length,
            itemBuilder: (context, index) {
              final component = components[index];
              final iconUrl = component['componentIcon']; // ดึง URL จาก database

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Image.network(
                    iconUrl, // แสดงรูปจาก URL
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error); // แสดงไอคอนเมื่อโหลดรูปไม่ได้
                    },
                  ),
                  title: Text(
                    component['componentName'],
                    style: TextStyle(
                      fontSize: 18, // ปรับขนาดฟอนต์ให้ใหญ่ขึ้น
                      fontWeight: FontWeight.bold, // ทำให้ชื่อชิ้นส่วนพืชตัวหนา
                    ),
                  ),
                  onTap: () {
                    _showPlantsUsingComponent(component['componentID']);
                  }, // เมื่อคลิกที่ชิ้นส่วนพืช
                ),
              );
            },
          );
        },
      ),
    );
  }
}
