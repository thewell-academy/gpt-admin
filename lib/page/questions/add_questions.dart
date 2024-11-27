import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/question_model/answer_option_info_model.dart';
import 'package:thewell_gpt_admin/page/questions/question_model/default_question_info_model.dart';
import 'package:thewell_gpt_admin/page/questions/question_model/question_model.dart';
import 'package:thewell_gpt_admin/page/questions/question_router.dart';
import 'package:thewell_gpt_admin/page/questions/util/question_types.dart';

class AddQuestionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestionPage> {
  String? _selectedSubject; // State variable for selected subject
  final List<QuestionPageState> _questionPages = []; // List of question page states

  final _questionTypes = questionTypes;

  void _addQuestionPage() {
    setState(() {
      if (_selectedSubject != null) {
        _questionPages.add(QuestionPageState(
          selectedSubject: _selectedSubject!,
          questionModel: QuestionModel(
              subject: _selectedSubject!,
            defaultQuestionInfo: DefaultQuestionInfoModel(),
            answerOptionInfo: AnswerOptionInfoModel(),
          ),
          selectedQuestionType: null,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the left
            children: [
              // Dropdown for subject selection
              DropdownButton<String>(
                value: _selectedSubject,
                hint: const Text("과목 선택"),
                items: _questionTypes.keys
                    .map((subject) => DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                    _questionPages.clear(); // Clear existing question pages
                  });
                },
              ),
              const SizedBox(height: 16),

              // Render each question page dynamically
              if (_selectedSubject != null)
                ..._questionPages.map(
                      (pageState) => QuestionPage(
                    key: ValueKey(pageState),
                    pageState: pageState,
                    questionTypes: _questionTypes[_selectedSubject!]!,
                  ),
                ),

              // "문제 추가" Button
              if (_selectedSubject != null)
                Align(
                  alignment: Alignment.centerLeft, // Moves the button to the left
                  child:
                  ElevatedButton(
                    child: const Text("+ 문제 추가"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent, // Red color to indicate a delete action
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    onPressed: _addQuestionPage,
                  ),

                ),

              const SizedBox(height: 16),

              // Save button displayed only at the bottom
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Save logic
                    for (var page in _questionPages) {
                      // print("Subject: ${page.selectedSubject}, Question Type: ${page.selectedQuestionType} Question Data: ${page.questionModel}");
                      print(page.questionModel);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("저장하기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}