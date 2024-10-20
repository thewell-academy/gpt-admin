import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/users/add_user_dialog.dart';
import 'package:thewell_gpt_admin/page/users/user_item.dart';
import 'package:http/http.dart' as http;
import 'package:thewell_gpt_admin/util/util.dart';

class Users extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  int currentPage = 0;
  List<UserItem> users = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Mock function to fetch user data
  Future<void> _fetchUsers() async {
    setState(() => isLoading = true);
    // Replace this mock data with actual API call

    final response = await http.get(
      Uri.parse("$serverUrl/admin/get/users")
    );
    print(response.body);


    users = List.generate(
      100,
          (index) =>
          UserItem(
            id: 'user_$index',
            name: 'User $index',
            email: 'user$index@example.com',
          ),
    );
    setState(() => isLoading = false);
  }

  void _addUser() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AddUsersDialog()
    );
  }

  void _searchUsers() {
    // Implement your search logic here
    String query = searchController.text;
    print("Searching for users with query: $query");
  }

  void _deleteUser(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("사용자 삭제"),
          content: Text("사용자를 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  users.removeWhere((user) => user.id == id);
                });
                Navigator.of(context).pop();
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void _showUserDetails(UserItem user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${user.name} 비밀번호"),
          content: Text("12345678"),
          actions: [
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
    @override
    Widget build(BuildContext context) {
      int startIndex = currentPage * 20;
      int endIndex = (startIndex + 20 < users.length) ? startIndex + 20 : users
          .length;
      List<UserItem> paginatedUsers = users.sublist(startIndex, endIndex);

      return Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: '사용자 이름 검색...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _searchUsers,
                      child: Text("검색"),
                    ),
                    SizedBox(width: 30),
                    IconButton(
                      icon: Icon(Icons.refresh_outlined),
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green)
                      ),
                    ),
                    SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: _addUser,
                      child: Text("학생 추가하기"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      ),

                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage = currentPage > 0 ? currentPage - 1 : currentPage;
                        });
                      },
                      child: Text("이전 페이지"),
                    ),
                    SizedBox(width: 50),  // Space between button and text
                    Text("Page ${currentPage + 1} of ${(users.length / 20).ceil()}"),
                    SizedBox(width: 50),  // Space between text and next button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage = (currentPage + 1) * 20 < users.length ? currentPage + 1 : currentPage;
                        });
                      },
                      child: Text("다음 페이지"),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: paginatedUsers.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(Text(user.name)),
                        DataCell(Text(user.id)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () => _showUserDetails(user),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteUser(user.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage = currentPage > 0 ? currentPage - 1 : currentPage;
                        });
                      },
                      child: Text("이전 페이지"),
                    ),
                    SizedBox(width: 50),  // Space between button and text
                    Text("Page ${currentPage + 1} of ${(users.length / 20).ceil()}"),
                    SizedBox(width: 50),  // Space between text and next button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentPage = (currentPage + 1) * 20 < users.length ? currentPage + 1 : currentPage;
                        });
                      },
                      child: Text("다음 페이지"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }