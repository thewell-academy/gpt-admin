import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thewell_gpt_admin/page/dashboard/dashboard.dart';
import 'package:thewell_gpt_admin/page/settings/settings.dart';
import 'package:thewell_gpt_admin/page/users/users.dart';
import 'package:thewell_gpt_admin/util/util.dart';

import 'auth/login.dart';
import 'config.dart';

Future<void> main() async {
  bool isLoggedIn = await checkLoginStatus();
  WidgetsFlutterBinding.ensureInitialized();
  Config.loadServerUrl();
  print('Server URL: ${Config.serverUrl}');
  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

Future<bool> checkLoginStatus() async {

  return false;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return ((prefs.getBool('isLoggedIn')?? false) && (prefs.getString("userId") != null)) ? true : false;
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.isLoggedIn
  });

  final bool isLoggedIn;

  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _appTitle = "더웰 GPT 관리자 페이지";
  Color _appBarColor = Colors.black87;

  @override
  void initState() {
    super.initState();
    serverHandShake(_updateServerStatus);
  }

  void _updateServerStatus(String title, Color color) {
    setState(() {
      _appTitle = title;
      _appBarColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      theme: ThemeData(
        primaryColor: _appBarColor,
        colorScheme: const ColorScheme.dark(),
      ),
      debugShowCheckedModeBanner: false,

      initialRoute: widget.isLoggedIn
          ? MyHomePage.id
          : LoginPage.id,

      routes: {
        LoginPage.id: (context) => LoginPage(),
        MyHomePage.id: (context) => MyHomePage(
          title: _appTitle,
          appBarColor: _appBarColor,
        )
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.appBarColor,
  });

  final String title;
  final Color appBarColor;
  static String id = '/MyHomePage';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _selectedPage = 'Dashboard';

  // This method updates the selected page and refreshes the content below the menu bar
  void _selectPage(String page) {
    setState(() {
      _selectedPage = page;
    });
  }

  Widget _buildPageContent() {
    switch (_selectedPage) {
      case 'Dashboard':
        return DashBoard();
      case 'Users':
        return Users();
      case 'Settings':
        return Setting();
      default:
        return const Center(
          child: Text(
            'Select a page from the menu above',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
      // Menu Bar
      Container(
      color: Colors.black87,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _selectPage('Dashboard');
              },
              child: Text("대시보드"),
            ),
            SizedBox(width: 20),
            TextButton(
              onPressed: () {
                _selectPage('Users');
              },
              child: Text("사용자 관리"),
            ),
            SizedBox(width: 20),
            TextButton(
              onPressed: () {
                _selectPage('Settings');
              },
              child: Text("설정"),
            ),
          ],
        ),
      ),
          Expanded(
            child: _buildPageContent() // Call the method to render the selected content
          ),
    ]
      )
    );
  }
}
