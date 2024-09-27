import 'package:flutter/material.dart';
import 'web/database_helper.dart';

class LandUseTypePage extends StatefulWidget {
  const LandUseTypePage({Key? key}) : super(key: key);

  @override
  _LandUseTypePageState createState() => _LandUseTypePageState();
}

class _LandUseTypePageState extends State<LandUseTypePage> {
  late Future<List<Map<String, dynamic>>> _landUseTypeList;

  @override
  void initState() {
    super.initState();
    _landUseTypeList = DatabaseHelper.instance.queryAllLandUseTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประเภทการใช้ประโยชน์ของพืช'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _landUseTypeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ไม่มีข้อมูลการใช้ประโยชน์'));
          }

          final landUseTypes = snapshot.data!;
          return ListView.builder(
            itemCount: landUseTypes.length,
            itemBuilder: (context, index) {
              final landUseType = landUseTypes[index];
              return ListTile(
                title: Text(landUseType['LandUseTypeName']),
                subtitle: Text(landUseType['LandUseTypeDescription']),
              );
            },
          );
        },
      ),
    );
  }
}
