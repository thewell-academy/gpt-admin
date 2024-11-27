// 질문 모델
import 'package:thewell_gpt_admin/page/questions/question_model/default_question_info_model.dart';

import 'answer_option_info_model.dart';

class QuestionModel {
  final String subject;
  DefaultQuestionInfoModel defaultQuestionInfo;
  Map<String, dynamic> additionalData;
  AnswerOptionInfoModel answerOptionInfo;
  late final String type;

  QuestionModel({
    required this.subject,
    required this.defaultQuestionInfo,
    required this.answerOptionInfo,
    this.type = '',
    this.additionalData = const {}
  });
}