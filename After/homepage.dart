import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'web/database_helper.dart'; // Import DatabaseHelper สำหรับการดึงข้อมูล
import 'PlantDetailPage.dart'; // นำเข้า PlantDetailPage

class HomePage extends StatelessWidget {
  final Database database; // เพิ่มแอตทริบิวต์ Database
  final DatabaseHelper databaseHelper = DatabaseHelper.instance; // สร้าง instance ของ DatabaseHelper

  HomePage({Key? key, required this.database}) : super(key: key); // ปรับปรุง constructor

  // ดึงข้อมูลพรรณไม้รวมถึงส่วนประกอบและการใช้ประโยชน์
  Future<List<Map<String, dynamic>>> _fetchPlants() async {
    try {
      return await databaseHelper.queryAllPlants(); // ใช้ฟังก์ชันจาก DatabaseHelper
    } catch (e) {
      print("Error fetching plants: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Plants',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal[700], // เปลี่ยนสี AppBar เป็น teal
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( // ดึงข้อมูลพืช
        future: _fetchPlants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No plants found.'));
          }

          final plants = snapshot.data!;

          return ListView.separated(
            itemCount: plants.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey), // สีของ Divider
            itemBuilder: (context, index) {
              final plant = plants[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 5, // เพิ่มเงาให้การ์ดดูเด่นขึ้น
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // ทำมุมการ์ดให้โค้งมน
                ),
                child: ListTile(
                  leading: _buildPlantImage(plant['plantImage']),
                  title: Text(
                    plant['plantName'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // เปลี่ยนสไตล์ของชื่อพืช
                  ),
                  subtitle: Text('Scientific Name: ${plant['plantScientific']}'),
                  onTap: () {
                    // เมื่อกดที่รายการพืชให้ไปยังหน้ารายละเอียด
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailPage(plant: plant), // ส่งข้อมูลพืชไปยังหน้ารายละเอียด
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.teal[800], // เปลี่ยนสีพื้นหลังของ BottomNavigationBar
        selectedItemColor: Colors.amber, // เปลี่ยนสีไอคอนเมื่อถูกเลือกเป็นสีเหลือง
        unselectedItemColor: Colors.white70, // เปลี่ยนสีไอคอนที่ไม่ได้เลือก
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.eco), // เปลี่ยนไอคอนเป็นรูปใบไม้
            label: 'All Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), // เปลี่ยนไอคอนเป็นเครื่องหมายบวก
            label: 'Add Plant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded), // เปลี่ยนไอคอนเป็นแว่นขยายโค้งมน
            label: 'Search',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break; // หน้า home "All Plants" (หน้าปัจจุบัน)
            case 1:
              Navigator.pushNamed(context, '/addPlant', arguments: database);
              break;
            case 2:
              Navigator.pushNamed(context, '/search', arguments: database);
              break;
          }
        },
      ),
    );
  }

  // สร้างฟังก์ชันสำหรับการแสดงภาพพรรณไม้
  Widget _buildPlantImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Icon(Icons.local_florist, size: 50, color: Colors.grey);
    }
    return Image.network(
      imagePath, // ใช้ URL ของรูปภาพ
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }
}
