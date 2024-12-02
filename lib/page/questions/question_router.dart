import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/question_model/question_model.dart';
import 'package:thewell_gpt_admin/page/questions/question_options/english/english_question_option1.dart';
import 'package:thewell_gpt_admin/page/questions/question_options/english/english_question_option2.dart';
import 'package:thewell_gpt_admin/page/questions/question_options/english/english_question_option3.dart';
import 'package:thewell_gpt_admin/page/questions/question_options/english/english_question_option5.dart';
import 'package:thewell_gpt_admin/page/questions/question_options/english/english_question_option6.dart';
import 'package:thewell_gpt_admin/page/questions/util/question_types.dart';
import 'package:thewell_gpt_admin/page/questions/util/question_data_handler.dart';

class QuestionPageState {
  int questionId;
  String selectedSubject;
  QuestionModel questionModel;
  String? selectedQuestionType;

  QuestionPageState({
    required this.questionId,
    required this.selectedSubject,
    required this.questionModel,
    this.selectedQuestionType,
  });

  Map<String, dynamic> toJson() {
    return {
      "questionId": questionId,
      "subject": selectedSubject,
      "questionModel": questionModel.toJson(),
      "questionType": selectedQuestionType?? ""
    };
  }
}

// Widget for each question page
class QuestionPage extends StatefulWidget {
  final QuestionPageState pageState;
  final List<String> questionTypes;
  final Function(int) onDelete;

  QuestionPage({
    required Key key,
    required this.pageState,
    required this.questionTypes,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageStateWidget();
}

class _QuestionPageStateWidget extends State<QuestionPage> {
  late String? _selectedQuestionType;
  late String _selectedSubject;
  late QuestionModel _questionModel;

  @override
  void initState() {
    super.initState();
    _selectedQuestionType = widget.pageState.selectedQuestionType;
    _selectedSubject = widget.pageState.selectedSubject;
    _questionModel = widget.pageState.questionModel;
  }

  Widget _buildWidgetForEnglishQuestionType(String selectedType) {

    List<String> questionType1List = ["글의 목적", "글의 분위기", "대의 파악", "함의 추론", "도표 이해", "내용 일치", "어법 판단", "단어 쓰임 판단", "빈칸 추론", "무관한 문장"];
    List<String> questionType2List = ["글의 순서"];
    List<String> questionType3List = ["주어진 문장 넣기"];
    List<String> questionType4List = ["요약문 완성"];
    List<String> questionType5List = ["장문 문제1 (41~42)"];
    List<String> questionType6List = ["장문 문제2 (43~45)"];


    if (questionType1List.contains(selectedType)) { // 기본 문제
      return EnglishQuestionType1(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete(widget.pageState.questionId)
      );
    } else if (questionType2List.contains(selectedType)) { // 글의 순서
      return EnglishQuestionType2(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete(widget.pageState.questionId)
      );
    } else if (questionType3List.contains(selectedType)) { // 주어진 문장 넣기
      return EnglishQuestionType3(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete(widget.pageState.questionId)
      );
    } else if (questionType4List.contains(selectedType)) { // 요약문 완성
      return EnglishQuestionType3(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete(widget.pageState.questionId)
      );
    } else if (questionType5List.contains(selectedType)) { // 장문 문제1 (41 ~ 42)
      return EnglishQuestionType5(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete(widget.pageState.questionId)
      );
    } else if (questionType6List.contains(selectedType)) { // 장문 문제2 (43 ~ 45)
      return EnglishQuestionType6(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete(widget.pageState.questionId)
      );
    }
    else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "문제 유형 선택",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 16, // Horizontal space between items
          runSpacing: 8, // Vertical space between rows
          children: widget.questionTypes
              .map(
                (type) => Row(
              mainAxisSize: MainAxisSize.min, // Adjust size to fit content
              children: [
                Radio<String>(
                  value: type,
                  groupValue: _selectedQuestionType,
                  onChanged: (value) {
                    setState(() {
                      _selectedQuestionType = value;
                      widget.pageState.selectedQuestionType = value;
                    });
                    QuestionDataHandler.updateQuestionType(
                        _questionModel,
                        _selectedQuestionType?? ''
                    );
                  },
                ),
                Text(type), // Text label next to the radio button
              ],
            ),
          )
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildWidgetForSubject(),
      ],
    );
  }

  Widget _buildWidgetForSubject() {
    if (_selectedQuestionType == null) {
      return const SizedBox.shrink();
    }
    switch (_selectedSubject) {
      case "영어":
        return _buildWidgetForEnglishQuestionType(_selectedQuestionType!);
      default:
        return Text("Selected Type: $_selectedQuestionType");
    }
  }
}