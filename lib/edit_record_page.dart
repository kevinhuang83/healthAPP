import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditRecordPage extends StatefulWidget {
  final Map<String, dynamic> record;
  final String userId;

  EditRecordPage({required this.record, required this.userId});

  @override
  _EditRecordPageState createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  TextEditingController bloodSugarController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController bmiController = TextEditingController();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    bloodSugarController.text = widget.record['bloodSugar'];
    bloodPressureController.text = widget.record['bloodPressure'];
    bmiController.text = widget.record['bmi'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('編輯紀錄'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: bloodSugarController,
            decoration: InputDecoration(labelText: '血糖'),
          ),
          TextField(
            controller: bloodPressureController,
            decoration: InputDecoration(labelText: '血壓'),
          ),
          TextField(
            controller: bmiController,
            decoration: InputDecoration(labelText: 'BMI'),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  _updateRecord();
                },
                child: Text('更新'),
              ),
              SizedBox(width: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 返回上一页（RecordPage）
                },
                child: Text(
                  '取消',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateRecord() async {
    try {
      DatabaseReference userRef = databaseReference
          .child(widget.userId)
          .child('records')
          .child(widget.record['id']); // 使用传递过来的记录ID
      await userRef.update({
        'bloodSugar': bloodSugarController.text,
        'bloodPressure': bloodPressureController.text,
        'bmi': bmiController.text,
      });

      // 返回更新后的记录到上一页
      Map<String, dynamic> updatedRecord = {
        'id': widget.record['id'],
        'bloodSugar': bloodSugarController.text,
        'bloodPressure': bloodPressureController.text,
        'bmi': bmiController.text,
      };
      Navigator.pop(context, updatedRecord);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('紀錄更新成功')),
      );

    } catch (e) {
      print('Failed to update record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('紀錄更新失敗')),
      );
    }
  }
}
