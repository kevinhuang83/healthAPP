import 'package:family_health_manager/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'edit_record_page.dart';
import 'delete_record_page.dart';

String record = '';

class RecordPage extends StatefulWidget {
  final String userId;
  RecordPage({required this.userId});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  List<Map<String, dynamic>> records = [];
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  void _fetchRecords() async {
    DatabaseReference recordsRef = databaseReference.child(widget.userId).child(
        'records');
    Set<String> processedRecordIds = Set<String>();
    recordsRef.onValue.listen((event) {
      // 使用 event.snapshot 取得資料快照
      var data = event.snapshot.value as Map;
      if (data != null) {
        data.forEach((key, value) {
          // 檢查是否為已處理過的紀錄
          if (!processedRecordIds.contains(key)) {
            setState(() {
              records.add({
                'id': key,
                'bloodSugar': value['bloodSugar'],
                'bloodPressure': value['bloodPressure'],
                'bmi': value['bmi'],
              });
            });
            // 將已處理的紀錄識別碼加入 Set
            processedRecordIds.add(key);
          }
        });
      } else {
        print('找不到資料');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('紀錄'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(userId: widget.userId)),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('血糖: ${records[index]['bloodSugar']}'),
                Text('血壓: ${records[index]['bloodPressure']}'),
                Text('BMI: ${records[index]['bmi']}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    var updatedRecord = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditRecordPage(
                          record: records[index], userId: widget.userId)),
                    );
                    if (updatedRecord != null) {
                      setState(() {
                        records[index] = updatedRecord;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    bool shouldDelete = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteRecordPage(
                          userId: widget.userId,
                          recordId: records[index]['id'],
                        ),
                      ),
                    );
                    if (shouldDelete == true) {
                      setState(() {
                        records.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('紀錄刪除成功')),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addRecord();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addRecord() async {
    // Show dialog to add new record
    Map<String, dynamic>? newRecord = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddRecordDialog();
      },
    );

    if (newRecord != null) {
      try {
        // Get current timestamp as record ID
        DatabaseReference userRef = databaseReference.child(widget.userId).child('records').push();
        String? recordId = userRef.key; // 获取生成的唯一ID

        await userRef.set({
          'bloodSugar': newRecord['bloodSugar'],
          'bloodPressure': newRecord['bloodPressure'],
          'bmi': newRecord['bmi'],
        });
        newRecord['id'] = recordId;
        print(newRecord['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('紀錄新增成功')),
        );
      } catch (e) {
        print('Failed to add record: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('紀錄新增失敗')),
        );
      }
    }
  }
}

class AddRecordDialog extends StatefulWidget {
  @override
  _AddRecordDialogState createState() => _AddRecordDialogState();
}

class _AddRecordDialogState extends State<AddRecordDialog> {
  final TextEditingController bloodSugarController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('新增紀錄'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Map<String, dynamic> newRecord = {
              'bloodSugar': bloodSugarController.text,
              'bloodPressure': bloodPressureController.text,
              'bmi': bmiController.text,
            };
            Navigator.of(context).pop(newRecord);
          },
          child: Text('新增'),
        ),
      ],
    );
  }
}
