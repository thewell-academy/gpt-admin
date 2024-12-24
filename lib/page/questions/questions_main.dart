import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/add_questions.dart';
import 'package:thewell_gpt_admin/page/questions/create_questions.dart';

class Questions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    // Calculate 60% of the screen width
    final double contentWidth = MediaQuery.of(context).size.width * 0.6;

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(49), // Adjust the height of the AppBar
          child: AppBar(
            automaticallyImplyLeading: false, // Removes back button if present
            toolbarHeight: 0, // Set the AppBar title area height to 0
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: "문제 만들기"),
                Tab(text: "문제 데이터 추가하기"),
              ],
              isScrollable: false,
              indicatorColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ), // Text style for selected tabs
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ), // Text style for unselected tabs
              indicatorWeight: 3, // Thickness of the tab indicator
              labelPadding: EdgeInsets.symmetric(horizontal: 20), // Adjust the padding between tabs
            ),
          ),
        ),
        body: Center(
          child: Container(
            width: contentWidth, // Restrict the TabBarView to 60% of screen width
            child: TabBarView(
              children: [
                CreateQuestionPdfPage(), // Replace with your actual Menu1 content widget
                AddQuestionPage(), // Replace with your actual Menu2 content widget
              ],
            ),
          ),
        ),
      ),
    );
  }
}