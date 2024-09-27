import 'package:flutter/material.dart';
import 'web/database_helper.dart';

class LandUsePage extends StatefulWidget {
  const LandUsePage({Key? key}) : super(key: key);

  @override
  _LandUsePageState createState() => _LandUsePageState();
}

class _LandUsePageState extends State<LandUsePage> {
  late Future<List<Map<String, dynamic>>> _landUseList;

  @override
  void initState() {
    super.initState();
    _landUseList = DatabaseHelper.instance.queryAllLandUses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การใช้ประโยชน์ของพืช'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _landUseList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูลการใช้ประโยชน์'));
          }

          final landUses = snapshot.data!;
          return ListView.builder(
            itemCount: landUses.length,
            itemBuilder: (context, index) {
              final landUse = landUses[index];

              return FutureBuilder<Map<String, dynamic>>(
                future: _getLandUseDetails(landUse),
                builder: (context, landUseSnapshot) {
                  if (landUseSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (landUseSnapshot.hasError) {
                    return const Center(child: Text('เกิดข้อผิดพลาด'));
                  } else if (!landUseSnapshot.hasData) {
                    return const Center(child: Text('ไม่มีข้อมูลการใช้ประโยชน์'));
                  }

                  final landUseDetails = landUseSnapshot.data!;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(
                        landUseDetails['plantImage'], // รูปภาพพืชจาก URL
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // ใช้รูปภาพจาก assets หากโหลด URL ไม่สำเร็จ
                          return Image.asset(
                            'assets/images/bamboo.jpg', // รูปภาพสำรองจาก assets
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      title: Text(landUseDetails['plantName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('การใช้ประโยชน์: ${landUse['LandUseDescription']}'),
                          Text('ชิ้นส่วนที่ใช้: ${landUseDetails['componentName']}'),
                        ],
                      ),
                      trailing: Image.network(
                        landUseDetails['componentIcon'], // รูปภาพชิ้นส่วนพืชจาก URL
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // ใช้รูปภาพจาก assets หากโหลด URL ไม่สำเร็จ
                          return Image.asset(
                            'assets/icons/bamboo.jpg', // รูปภาพสำรองจาก assets
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // ฟังก์ชันสำหรับดึงรายละเอียดของพืชและชิ้นส่วนพืช
  Future<Map<String, dynamic>> _getLandUseDetails(Map<String, dynamic> landUse) async {
    final plant = await DatabaseHelper.instance.queryPlantById(landUse['plantID']);
    final component = await DatabaseHelper.instance.queryComponentById(landUse['componentID']);
    return {
      'plantName': plant['plantName'],
      'plantImage': plant['plantImage'],
      'componentName': component['componentName'],
      'componentIcon': component['componentIcon'],
    };
  }
}
