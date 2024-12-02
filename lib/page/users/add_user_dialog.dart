import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thewell_gpt_admin/util/util.dart';

class AddUsersDialog extends StatefulWidget {
  @override
  _AddUsersDialogState createState() => _AddUsersDialogState();
}

class _AddUsersDialogState extends State<AddUsersDialog> {
  List<Map<String, TextEditingController>> userControllers = [];
  List<bool> passwordMismatchError = [];
  List<bool> fieldNotFilledError = [];

  @override
  void initState() {
    super.initState();
    _addUserFields();
  }

  void _addUserFields() {
    setState(() {
      userControllers.add({
        "id": TextEditingController(),
        "name": TextEditingController(),
        "password": TextEditingController(),
        "retypePassword": TextEditingController(),
      });
      passwordMismatchError.add(false);
      fieldNotFilledError.add(false);
    });
  }

  void _removeUserFields(int index) {
    setState(() {
      userControllers.removeAt(index);
      passwordMismatchError.removeAt(index); // Remove error state for the user
      fieldNotFilledError.removeAt(index);
    });
  }

  bool _validatePasswords() {
    bool allMatch = true;
    for (int i = 0; i < userControllers.length; i++) {
      String password = userControllers[i]["password"]!.text;
      String retypePassword = userControllers[i]["retypePassword"]!.text;

      if (userControllers[i]['id']!.text.isEmpty ||
          userControllers[i]['name']!.text.isEmpty ||
          userControllers[i]["password"]!.text.isEmpty ||
          userControllers[i]["retypePassword"]!.text.isEmpty
      ){
        allMatch = false;
        fieldNotFilledError[i] = true;
      } else{
        fieldNotFilledError[i] = false;
      }

      if (password != retypePassword) {
        allMatch = false;
        passwordMismatchError[i] = true;
      } else {
        passwordMismatchError[i] = false;
      }
    }
    setState(() {}); // Update the UI to show error messages
    return allMatch;
  }

  void _submitData() async {
    if (!_validatePasswords()) {
      return; // Stop if there are password mismatches
    }

    // Collect user data and submit
    List<Map<String, String>> usersData = userControllers.map((user) {
      return {
        "id": user["id"]!.text,
        "name": user["name"]!.text,
        "password": user["password"]!.text,
      };
    }).toList();


    final response = await http.post(
      Uri.parse('$serverUrl/admin/add/users'),
      body: jsonEncode(usersData)
    );

    Navigator.of(context).pop();
  }

    @override
    Widget build(BuildContext context) {
      return AlertDialog(
        title: Text("사용자 추가하기"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: userControllers.map((controller) {
                  int index = userControllers.indexOf(controller);
                  return Column(
                    key: ValueKey(index),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("사용자 ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextField(
                        controller: controller["id"],
                        decoration: InputDecoration(labelText: "아이디"),
                      ),
                      TextField(
                        controller: controller["name"],
                        decoration: InputDecoration(labelText: "이름"),
                      ),
                      TextField(
                        controller: controller["password"],
                        decoration: InputDecoration(labelText: "비밀번호"),
                        obscureText: true,
                      ),
                      TextField(
                        controller: controller["retypePassword"],
                        decoration: InputDecoration(labelText: "비밀번호 재입력"),
                        obscureText: true,
                      ),
                      if (fieldNotFilledError[index])
                        const Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              "모든 값을 입력해주세요",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      if (!fieldNotFilledError[index] && passwordMismatchError[index])
                        const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            "비밀번호가 일치하지 않습니다.",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _removeUserFields(index),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _addUserFields,
                icon: const Icon(Icons.add),
                label: const Text("다른 사용자 추가하기"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("취소"),
          ),
          ElevatedButton(
            onPressed: () {
              _submitData();
            },
            child: const Text("추가"),
          ),
        ],
      );
    }
  }