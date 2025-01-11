import '../question_model/answer_option_info_model.dart';
import '../question_model/question_model.dart';


class QuestionDataHandler {

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

  static void updateDeltaTextForContentTextMap(
      QuestionModel questionModel,
      String title,
      String contentTextString,
      ) {
    questionModel.questionContentTextMap[title] = contentTextString;
  }

  static void updateAnswerOptionsInfo(
      QuestionModel questionModel,
      String selectedQuestionNumber,
      String selectedScore,
      List<String> abcOptionList,
      String selectedQuestionText,
      List<String> optionList,
      String selectedAnswer,
      String memo,
      ) {
    int questionNumber = int.tryParse(selectedQuestionNumber) ?? 0;
    int questionScore = int.tryParse(selectedScore) ?? 0;
    int answer = int.tryParse(selectedAnswer) ?? 0;
    AnswerOptionInfoModel answerOptionInfoModel = AnswerOptionInfoModel(
        questionNumber: questionNumber,
        questionScore: questionScore,
        abcOptionList: abcOptionList,
        questionText: selectedQuestionText,
        option1: optionList[0],
        option2: optionList[1],
        option3: optionList[2],
        option4: optionList[3],
        option5: optionList[4],
        answer: answer,
        memo: memo
    );

    if (answerOptionInfoModel.isValid()) {
      questionModel.answerOptionInfoList.add(answerOptionInfoModel);
    }
  }
}