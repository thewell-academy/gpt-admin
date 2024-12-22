import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../util/util.dart';

class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late String userId = "";
  late String password = "";

  bool _emptyIdField = false;
  bool _emptyPasswordField = false;

  bool _showSpinner = false;

  String emailText = '관리자 아이디를 입력해주세요.';
  String passwordText = '관리자 비밀번호를 입력해주세요.';

  String welcomeText = '\n로그인을 해주세요.';

  Future<void> _saveLoginInfo(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString("userId", userId);
  }

  void _showLoginFailedDialog(int statusCode) {

    String dialogText;
    switch (statusCode) {
      case 401:
        dialogText = "아이디 또는 비밀번호가 일치하지 않습니다.";
        break;
      default:
        dialogText = "서버 오류가 발생했습니다. code: $statusCode";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인 오류'),
          content: const Text('아이디 또는 비밀번호를 다시 확인해주세요.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _switchToMainPage() {
    Navigator.pushReplacementNamed(context, MyHomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Enable resizing when the keyboard appears
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ModalProgressHUD(
          inAsyncCall: _showSpinner,
          color: Colors.blueAccent,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: screenWidth * 0.5, // Limit the width to 50% of the screen
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Left-align content
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  children: [
                    const Text(
                      '더웰 관리자 페이지',
                      style: TextStyle(fontSize: 50.0),
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          welcomeText,
                          style: const TextStyle(fontSize: 30.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            userId = value;
                          },
                          decoration: InputDecoration(
                            hintText: '관리자 아이디를 입력하세요.',
                            labelText: '아이디',
                            errorText: _emptyIdField
                                ? '아이디를 입력해주세요.'
                                : null,
                            labelStyle: _emptyIdField
                                ? const TextStyle(color: Colors.red)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                            hintText: '관리자 비밀번호를 입력하세요.',
                            labelText: '비밀번호',
                            errorText: _emptyPasswordField
                                ? '비밀번호를 입력해주세요.'
                                : null,
                            labelStyle: _emptyPasswordField
                                ? const TextStyle(color: Colors.red)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (userId.isEmpty) {
                          setState(() {
                            _emptyIdField = true;
                          });
                        } else {
                          setState(() {
                            _emptyIdField = false;
                          });
                        }

                        if (password.isEmpty) {
                          setState(() {
                            _emptyPasswordField = true;
                          });
                        } else {
                          setState(() {
                            _emptyPasswordField = false;
                          });
                        }

                        if (userId.isNotEmpty && password.isNotEmpty) {
                          setState(() {
                            _showSpinner = true;
                          });

                          final url = "$serverUrl/auth/login";

                          final response = await http.post(
                            Uri.parse(url),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, String>{
                              'id': userId,
                              'password': password,
                            }),
                          );

                          if (response.statusCode == 200) {
                            _saveLoginInfo(userId);
                            _switchToMainPage();
                          } else {
                            _showLoginFailedDialog(response.statusCode);
                            setState(() {
                              userId = "";
                              password = "";
                            });
                          }
                          setState(() {
                            _showSpinner = false;
                          });
                        }
                      },
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
