import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final Function(String) onLoginSuccess;

  LoginPage({required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginMessage = '';

  void login() {
    String inputId = idController.text;
    String inputPassword = passwordController.text;

    // Check if the user ID and password match in the database
    database.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        Object? values = databaseEvent.snapshot.value;
        Map<dynamic, dynamic> userData = values as Map<dynamic, dynamic>;
        bool userFound = false;

        userData.forEach((key, value) {
          if (key == inputId && value['password'] == inputPassword) {
            userFound = true;
          }
        });

        if (userFound) {
          widget.onLoginSuccess(inputId);
          print(inputId);
        } else {
          setState(() {
            loginMessage = 'ID或密碼有誤';
          });
        }
      } else {
        setState(() {
          loginMessage = '查無使用者資料';
        });
      }
    }).catchError((error) {
      setState(() {
        loginMessage = 'Failed to read data: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登入系統'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: '密碼'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('送出'),
            ),
            SizedBox(height: 20),
            Text(loginMessage),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('註冊系統'),
            ),
          ],
        ),
      ),
    );
  }
}
