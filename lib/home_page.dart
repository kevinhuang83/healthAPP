import 'package:flutter/material.dart';
import 'main.dart';
import 'record.dart';
class HomePage extends StatefulWidget {
  final String userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => RecordPage(userId: widget.userId!)),
            (Route<dynamic> route) => false,
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('健康管理系統'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('你好, ${widget.userId}')),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 記錄按鈕的處理邏輯
                    _onItemTapped(0);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                  ),
                  child: Icon(Icons.article, size: 48),
                ),
                SizedBox(height: 8),
                Text('紀錄'),
              ],
            ),
            SizedBox(height: 24), // 按鈕之間的距離
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 登出按鈕的處理邏輯
                    _onItemTapped(1);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                  ),
                  child: Icon(Icons.logout, size: 48),
                ),
                SizedBox(height: 8),
                Text('登出'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}