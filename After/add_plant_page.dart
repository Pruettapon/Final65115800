import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'web/database_helper.dart';

class AddPlantPage extends StatefulWidget {
  final Database database;

  AddPlantPage({required this.database});

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantScientificController = TextEditingController();
  final TextEditingController _plantImageURLController = TextEditingController();
  final TextEditingController _landUseDescriptionController = TextEditingController();
  final TextEditingController _landUseTypeDescriptionController = TextEditingController();
  final TextEditingController _componentController = TextEditingController();
  final TextEditingController _landUseTypeController = TextEditingController();

  @override
  void dispose() {
    _plantNameController.dispose();
    _plantScientificController.dispose();
    _plantImageURLController.dispose();
    _landUseDescriptionController.dispose();
    _landUseTypeDescriptionController.dispose();
    _componentController.dispose();
    _landUseTypeController.dispose();
    super.dispose();
  }

  Future<void> _addPlant() async {
    final plantName = _plantNameController.text;
    final plantScientific = _plantScientificController.text;
    final plantImageURL = _plantImageURLController.text;
    final selectedComponent = _componentController.text;
    final selectedLandUseType = _landUseTypeController.text;

    if (plantName.isEmpty || plantScientific.isEmpty || plantImageURL.isEmpty || selectedComponent.isEmpty || selectedLandUseType.isEmpty) {
      _showErrorDialog('Please fill all the fields');
      return;
    }

    int plantID = await DatabaseHelper.instance.insertPlant({
      'plantName': plantName,
      'plantScientific': plantScientific,
      'plantImage': plantImageURL,
    });

    if (plantID > 0) {
      int componentID = await DatabaseHelper.instance.insertPlantComponent({
        'componentName': selectedComponent,
        'componentIcon': 'default_icon.png',
      });

      if (componentID > 0) {
        await DatabaseHelper.instance.insertLandUse({
          'LandUseDescription': _landUseDescriptionController.text,
          'LandUseTypeDescription': selectedLandUseType,
          'plantID': plantID,
          'componentID': componentID,
        });

        _clearInputs();
        _showSuccessDialog('Plant added successfully'); // เรียกใช้ฟังก์ชันแสดงแจ้งเตือน
      } else {
        _showErrorDialog('Failed to add component.');
      }
    } else {
      _showErrorDialog('Failed to add plant. Please try again.');
    }
  }

  void _clearInputs() {
    _plantNameController.clear();
    _plantScientificController.clear();
    _plantImageURLController.clear();
    _landUseDescriptionController.clear();
    _landUseTypeDescriptionController.clear();
    _componentController.clear();
    _landUseTypeController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องแจ้งเตือน
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Plant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _plantNameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            TextField(
              controller: _plantScientificController,
              decoration: InputDecoration(labelText: 'Scientific Name'),
            ),
            TextField(
              controller: _plantImageURLController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _componentController,
              decoration: InputDecoration(labelText: 'Enter Component'),
            ),
            TextField(
              controller: _landUseTypeController,
              decoration: InputDecoration(labelText: 'Enter Land Use Type'),
            ),
            TextField(
              controller: _landUseDescriptionController,
              decoration: InputDecoration(labelText: 'Land Use Description'),
            ),
            TextField(
              controller: _landUseTypeDescriptionController,
              decoration: InputDecoration(labelText: 'Land Use Type Description'),
            ),
            ElevatedButton(
              onPressed: _addPlant,
              child: Text('Add Plant'),
            ),
          ],
        ),
      ),
    );
  }
}
