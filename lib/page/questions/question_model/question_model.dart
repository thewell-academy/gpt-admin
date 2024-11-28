import 'dart:convert';

import 'package:thewell_gpt_admin/page/questions/question_model/default_question_info_model.dart';
import 'answer_option_info_model.dart';

class QuestionModel {
  final String subject;
  DefaultQuestionInfoModel defaultQuestionInfo;
  Map<String, dynamic> questionContentTextMap;
  AnswerOptionInfoModel answerOptionInfo;
  String type;

  QuestionModel({
    required this.subject,
    required this.defaultQuestionInfo,
    required this.answerOptionInfo,
    this.type = '',
    Map<String, dynamic>? questionContentTextMap, // Use nullable for custom initialization
  }) : questionContentTextMap = questionContentTextMap ?? {};

  // Convert to JSON-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'defaultQuestionInfo': defaultQuestionInfo.toJson(),
      'questionContentTextMap': questionContentTextMap,
      'answerOptionInfo': answerOptionInfo.toJson(),
      'type': type,
    };
  }

  // Override toString to print JSON
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  bool isValid() {

    if (subject.isNotEmpty && defaultQuestionInfo.isValid() && questionContentTextMap.isNotEmpty && answerOptionInfo.isValid() && type.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}