import 'dart:html';

import '../question_model/answer_option_info_model.dart';
import '../question_model/default_question_info_model.dart';
import '../question_model/question_model.dart';

class QuestionDataHandler {

  static void updateQuestionType(
      QuestionModel questionModel,
      String questionType
      ) {
    questionModel.type = questionType;
  }

  // 유형, 배점, 시험 연월, 문제 텍스트 등
  static void updateDefaultQuestionInfo(
      QuestionModel questionModel,
      String exam,
      String examYear,
      String examMonth,
      String grade,
      String filePath
      ) {
    questionModel.defaultQuestionInfo.exam = exam;
    questionModel.defaultQuestionInfo.examYear = int.tryParse(examYear) ?? 0;
    questionModel.defaultQuestionInfo.examMonth = int.tryParse(examMonth) ?? 0;
    questionModel.defaultQuestionInfo.filePath = filePath;
  }

  static void updateHTMLRenderedText(
      QuestionModel questionModel,
      String note,
      String htmlText,
      ) {
    questionModel.questionContentTextMap[note] = htmlText;
  }

  static void updateAnswerOptionsInfo(
      QuestionModel questionModel,
      String selectedQuestionNumber,
      String selectedScore,
      String selectedQuestionText,
      String option1,
      String option2,
      String option3,
      String option4,
      String option5,
      String answer,
      String memo,
      ) {
    AnswerOptionInfoModel answerOptionInfoModel = AnswerOptionInfoModel(
      questionNumber: int.parse(selectedQuestionNumber)?? 0,
      questionScore: int.parse(selectedScore),
      questionText: selectedQuestionText,
      option1: option1,
      option2: option2,
      option3: option3,
      option4: option4,
      option5: option5,
      answer: int.parse(answer),
      memo: memo
    );
    questionModel.answerOptionInfoList.add(answerOptionInfoModel);
  }
}