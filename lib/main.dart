import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thewell_gpt_admin/page/dashboard/dashboard.dart';
import 'package:thewell_gpt_admin/page/questions/questions_main.dart';
import 'package:thewell_gpt_admin/page/settings/settings.dart';
import 'package:thewell_gpt_admin/page/users/users.dart';
import 'package:thewell_gpt_admin/util/server_config.dart';
import 'package:thewell_gpt_admin/util/util.dart';

import 'auth/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final directory = await getApplicationDocumentsDirectory();
    print("Documents directory: ${directory.path}");
  } catch (e) {
    print("Error accessing documents directory: $e");
  }
  bool isLoggedIn = await checkLoginStatus();
  print("Backend Server Listening: $gptServerUrl");
  runApp(MyApp(isLoggedIn: isLoggedIn,));
}

Future<bool> checkLoginStatus() async {
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

  String _appTitle = "더웰 앱 관리자 페이지";
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
        LoginPage.id: (context) => const LoginPage(),
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
        return const DashBoard();
      case 'Users':
        return const Users();
      case 'Settings':
        return const Setting();
      case 'Questions':
        return const Questions();
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                _selectPage('Dashboard');
              },
              child: const Text("대시보드"),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                _selectPage('Users');
              },
              child: const Text("앱 사용자 관리"),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                _selectPage('Questions');
              },
              child: const Text("문제 은행"),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () {
                _selectPage('Settings');
              },
              child: const Text("설정"),
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
