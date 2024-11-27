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
      String questionNumber,
      String questionScore,
      String questionText,
      ) {
    questionModel.defaultQuestionInfo.exam = exam;
    questionModel.defaultQuestionInfo.examYear = int.tryParse(examYear) ?? 0;
    questionModel.defaultQuestionInfo.examMonth = int.tryParse(examMonth) ?? 0;
    questionModel.defaultQuestionInfo.questionNumber = int.tryParse(questionNumber) ?? 0;
    questionModel.defaultQuestionInfo.questionScore = int.tryParse(questionScore)?? 0;
    questionModel.defaultQuestionInfo.questionText = questionText;
  }

  static void updateHTMLRenderedText(
      QuestionModel questionModel,
      String note,
      String htmlText,
      ) {
    questionModel.additionalData[note] = htmlText;
  }

  static void updateAnswerOptionsInfo(
      QuestionModel questionModel,
      String option1,
      String option2,
      String option3,
      String option4,
      String option5,
      String answer,
      String memo,
      ) {
    questionModel.answerOptionInfo.option1 = option1;
    questionModel.answerOptionInfo.option2 = option2;
    questionModel.answerOptionInfo.option3 = option3;
    questionModel.answerOptionInfo.option4 = option4;
    questionModel.answerOptionInfo.option5 = option5;
    questionModel.answerOptionInfo.answer = int.tryParse(answer)?? 0;
    questionModel.answerOptionInfo.memo = memo;
  }
}