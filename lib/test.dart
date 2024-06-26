import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Call your function to add data
  await addDataToDatabase();
}

Future<void> addDataToDatabase() async {
  try {
    // 取得 Firebase Database 的根引用
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // 假设有一个变量userId，表示要添加数据的用户ID
    String userId = "userID";  // 替換成實際的使用者ID

    // 添加 password 資料
    await databaseReference.child('accounts').child(userId).child('password').set('user_password');

    // 新的 record 資料
    Map<String, dynamic> record1 = {
      'bloodSugar': 80,
      'bloodPressure': '120/80',
      'bmi': 23.5,
      'timestamp': ServerValue.timestamp,
    };

    Map<String, dynamic> record2 = {
      'bloodSugar': 85,
      'bloodPressure': '130/85',
      'bmi': 24.0,
      'timestamp': ServerValue.timestamp,
    };

    // 添加 record 子節點及其內容
    await databaseReference.child('accounts').child(userId).child('record').child('record_1').set(record1);
    await databaseReference.child('accounts').child(userId).child('record').child('record_2').set(record2);

    print('Data added successfully for user $userId');
  } catch (e) {
    print('Failed to add data: $e');
  }
}
