import 'package:flutter/material.dart';
import 'web/database_helper.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  _PlantPageState createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  late Future<List<Map<String, dynamic>>> _plantList;

  @override
  void initState() {
    super.initState();
    _plantList = DatabaseHelper.instance.queryAllPlants();
  }

  // ฟังก์ชันดึงข้อมูลการใช้ประโยชน์และชิ้นส่วนพืช
  Future<List<Map<String, dynamic>>> getPlantUsesAndComponents(int plantID) async {
    return await DatabaseHelper.instance.queryPlantUsesAndComponents(plantID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลพรรณไม้และการใช้ประโยชน์'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _plantList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูลพรรณไม้'));
          }

          final plants = snapshot.data!;
          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: getPlantUsesAndComponents(plant['plantID']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Column(
                      children: [
                        Container(
                          width: 400,
                          height: 300,
                          child: Image.asset(
                            'assets/images/bamboo.jpg', // ใช้รูปภาพจาก assets เพื่อตรวจสอบปัญหา
                            fit: BoxFit.contain, // แสดงภาพทั้งหมดโดยคงอัตราส่วน
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plant['plantName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          plant['plantScientific'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const Text('ไม่มีข้อมูลการใช้ประโยชน์'),
                      ],
                    );
                  }

                  final uses = snapshot.data!;
                  final landUseTypeNames = uses.map((use) => use['LandUseTypeName']).join(', ');

                  return ExpansionTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          child: Image.network(
                            plant['plantImage'], // URL ของรูปภาพ
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/bamboo.jpg',
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plant['plantName'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          plant['plantScientific'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text('ประเภทการใช้ประโยชน์: $landUseTypeNames'), // แสดง LandUseType ในหน้าแรก
                      ],
                    ),
                    // เมื่อกดเข้าไปจะแสดง PlantComponent และ LandUse
                    children: uses.map((use) {
                      return ListTile(
                        leading: Image.network(
                          use['componentIcon'], // แสดงไอคอนของชิ้นส่วนพืช
                          width: 64, // ขนาดของไอคอน 64x64
                          height: 64,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/icons/default_icon.png', // รูปภาพสำรองหากโหลดไม่ได้
                              width: 64,
                              height: 64,
                            );
                          },
                        ),
                        title: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'ชิ้นส่วนที่ใช้: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, // เน้นตัวหนา
                                ),
                              ),
                              TextSpan(
                                text: use['componentName'], // ชื่อชิ้นส่วนพืช
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text('การใช้ประโยชน์: ${use['LandUseDescription']}'), // แสดงการใช้ประโยชน์
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
