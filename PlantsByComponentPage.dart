import 'package:flutter/material.dart';
import 'web/database_helper.dart';

class PlantsByComponentPage extends StatelessWidget {
  final int componentID;

  const PlantsByComponentPage({Key? key, required this.componentID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('พืชที่ใช้ประโยชน์จากชิ้นส่วนนี้'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.queryPlantsByComponent(componentID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาด'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูลพืชที่ใช้ชิ้นส่วนนี้'));
          }

          final plants = snapshot.data!;
          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // รูปภาพพืชขนาดใหญ่ขึ้น
                    Image.network(
                      plant['plantImage'],
                      width: 150, // ขยายขนาดรูปภาพเป็น 150x150 px
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/bamboo.jpg',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    const SizedBox(height: 10), // เพิ่มระยะห่างระหว่างรูปภาพและข้อความ
                    // ข้อความพืช (ชื่อและการใช้ประโยชน์)
                    Text(
                      plant['plantName'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      plant['plantScientific'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      plant['LandUseDescription'],
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
