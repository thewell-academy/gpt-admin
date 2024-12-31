import 'dart:convert';
import 'answer_option_info_model.dart';
import 'default_question_info_model.dart';

class QuestionModel {
  final String subject;
  DefaultQuestionInfoModel defaultQuestionInfo;
  Map<String, dynamic> questionContentTextMap;
  List<AnswerOptionInfoModel> answerOptionInfoList;

  QuestionModel({
    required this.subject,
    required this.defaultQuestionInfo,
    required this.answerOptionInfoList,
    Map<String, dynamic>? questionContentTextMap, // Use nullable for custom initialization
  }) : questionContentTextMap = questionContentTextMap ?? {};

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'defaultQuestionInfo': defaultQuestionInfo.toJson(),
      'questionContentTextMap': questionContentTextMap,
      'answerOptionInfoList': answerOptionInfoList.map((e) => e.toJson()).toList(),
    };
  }

  // Override toString to print JSON
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  bool isValid() {

    if (subject.isNotEmpty && defaultQuestionInfo.isValid() && questionContentTextMap.isNotEmpty
        && !answerOptionInfoList.map((e) => e.isValid()).contains(false)) {
      return true;
    } else {
      return false;
    }
  }
}