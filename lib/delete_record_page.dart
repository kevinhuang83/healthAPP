import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeleteRecordPage extends StatelessWidget {
  final String userId;
  final String recordId;

  DeleteRecordPage({required this.userId, required this.recordId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('刪除紀錄'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('您確定要刪除這條紀錄嗎？'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _deleteRecord(context);
              },
              child: Text('刪除'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteRecord(BuildContext context) async {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child(userId)
          .child('records')
          .child(recordId);

      await userRef.remove();

      Navigator.pop(context, true); // 返回上一页，并传递删除成功的标志
    } catch (e) {
      print('Failed to delete record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('紀錄刪除失敗')),
      );
    }
  }
}
