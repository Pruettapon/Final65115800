import 'package:flutter/material.dart';
import 'web/database_helper.dart';

class PlantDetailPage extends StatelessWidget {
  final Map<String, dynamic> plant;

  PlantDetailPage({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant['plantName']),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchPlantDetails(plant['plantID']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          }

          final plantDetails = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(plant['plantImage'], fit: BoxFit.cover),
                SizedBox(height: 20),
                Text(
                  'ชื่อพรรณไม้: ${plant['plantName']}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'ชื่อทางวิทยาศาสตร์: ${plant['plantScientific']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),

                // แสดงข้อมูลส่วนประกอบพืช
                Text(
                  'ใช้ส่วนประกอบ: ${plantDetails['components'].isNotEmpty ? plantDetails['components'].join(', ') : 'ไม่มีข้อมูล'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),

                // แสดงข้อมูลประเภทการใช้ที่ดิน
                Text(
                  'ใช้ประโยชน์ด้าน: ${plantDetails['landUses'].isNotEmpty ? plantDetails['landUses'].join(', ') : 'ไม่มีข้อมูล'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchPlantDetails(int plantId) async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    var components = await dbHelper.queryPlantComponentsByLandUseId(plantId);
    var landUses = await dbHelper.queryLandUsesByPlantId(plantId);

    return {
      'components': components.map((comp) => comp['componentName']).toList(),
      'landUses': landUses.map((landUse) => landUse['LandUseTypeName']).toList(),
    };
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบข้อมูลพืชนี้หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องยืนยัน
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.instance.deletePlant(plant['plantID']);
                Navigator.of(context).pop(); // ปิดกล่องยืนยัน
                Navigator.of(context).pop(); // กลับไปยังหน้าหลัก
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }
}
