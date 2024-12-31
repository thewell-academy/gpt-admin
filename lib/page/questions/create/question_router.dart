import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/create/question_model/question_router_state.dart';
import 'package:thewell_gpt_admin/page/questions/create/util/question_data_handler.dart';

import 'question_model/question_model.dart';
import 'question_options/english/english_question_option1.dart';
import 'question_options/english/english_question_option2.dart';
import 'question_options/english/english_question_option3.dart';
import 'question_options/english/english_question_option5.dart';
import 'question_options/english/english_question_option6.dart';



// Widget for each question page
class QuestionRouter extends StatefulWidget {
  final QuestionRouterState pageState;
  // final List<String> questionTypes;
  final Function onDelete;

  const QuestionRouter({
    required Key key,
    required this.pageState,
    // required this.questionTypes,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<QuestionRouter> createState() => _QuestionPageStateWidget();
}

class _QuestionPageStateWidget extends State<QuestionRouter> {
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

    String lastSelectedType = selectedType.split(" > ").last;

    List<String> questionType1List = ["글의 목적", "글의 분위기 / 심경", "대의 파악", "함의 추론", "도표 이해", "내용 일치 / 불일치", "실용문 일치 / 불일치", "어법성 판단", "단어 쓰임 판단", "빈칸 추론", "무관한 문장"];
    List<String> questionType2List = ["글의 순서"];
    List<String> questionType3List = ["주어진 문장 넣기"];
    List<String> questionType4List = ["요약문 완성"];
    List<String> questionType5List = ["기본 장문 독해"];
    List<String> questionType6List = ["복합 문단 독해"];


    if (questionType1List.contains(lastSelectedType)) {
      return EnglishQuestionType1(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete()
      );
    } else if (questionType2List.contains(lastSelectedType)) {
      return EnglishQuestionType2(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete()
      );
    } else if (questionType3List.contains(lastSelectedType)) {
      return EnglishQuestionType3(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete()
      );
    } else if (questionType4List.contains(lastSelectedType)) {
      return EnglishQuestionType3(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete()
      );
    } else if (questionType5List.contains(lastSelectedType)) {
      return EnglishQuestionType5(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete()
      );
    } else if (questionType6List.contains(lastSelectedType)) {
      return EnglishQuestionType6(
          key: ValueKey(widget.pageState),
          questionModel: _questionModel,
          onDelete: () => widget.onDelete()
      );
    }
    else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
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