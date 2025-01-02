import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/export/export_questions.dart';

import 'create/create_questions.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    final double contentWidth = MediaQuery.of(context).size.width * 0.6;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
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
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              indicatorWeight: 3,
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: contentWidth,
            child: const TabBarView(
              children: [
                ExportQuestionPage(),
                CreateQuestionPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}