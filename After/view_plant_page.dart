import 'package:flutter/material.dart';
import 'dart:io';

class ViewPlantPage extends StatelessWidget {
  final Map<String, dynamic> plant; // ข้อมูลพืชที่ต้องการแสดง

  ViewPlantPage({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant['name']), // แสดงชื่อพืชใน AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildImageSection(), // แสดงรูปภาพพืช
            SizedBox(height: 20),
            _buildDetailsSection(), // แสดงชื่อพืชและชื่อทางวิทยาศาสตร์
          ],
        ),
      ),
    );
  }

  // ส่วนสำหรับแสดงรูปภาพพืช
  Widget _buildImageSection() {
    return plant['image'] != null
        ? Image.file(File(plant['image'])) // แสดงรูปภาพจากไฟล์
        : Text('ไม่มีรูปภาพ'); // หากไม่มีรูปภาพ
  }

  // ส่วนสำหรับแสดงรายละเอียดพืช
  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('ชื่อพรรณไม้: ${plant['name']}', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text('ชื่อทางวิทยาศาสตร์: ${plant['scientificName']}', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
