import '../question_model/answer_option_info_model.dart';
import '../question_model/question_model.dart';


class QuestionDataHandler {

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
      int questionOrder,
      String selectedQuestionNumber,
      String selectedScore,
      List<String> abcOptionList,
      String selectedQuestionText,
      List<String> optionList,
      String selectedAnswer,
      String memo,
      bool answerOptionNotExists,
      ) {

    final questionNumber = int.tryParse(selectedQuestionNumber) ?? 0;
    final questionScore = int.tryParse(selectedScore) ?? 0;
    final answer = int.tryParse(selectedAnswer) ?? 0;

    if (answerOptionNotExists) {

      questionModel.answerOptionInfoList
          .removeWhere((item) => item.questionOrder == questionOrder);

      questionModel.answerOptionInfoList.add(
        AnswerOptionInfoModel(
          questionOrder: questionOrder,
          questionNumber: questionNumber,
          questionScore: questionScore,
          abcOptionList: [],
          questionText: selectedQuestionText,
          option1: "",
          option2: "",
          option3: "",
          option4: "",
          option5: "",
          answer: answer, // Represent "no answer"
          memo: memo,
        ),
      );

      // Stop further processing since no valid answers are needed
      return;
    }

    // Create the AnswerOptionInfoModel
    final answerOptionInfoModel = AnswerOptionInfoModel(
      questionOrder: questionOrder,
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
      memo: memo,
    );

    // Validate the model
    if (answerOptionInfoModel.isValid()) {
      // Remove old data and add the new model if valid
      questionModel.answerOptionInfoList
          .removeWhere((item) => item.questionOrder == questionOrder);
      questionModel.answerOptionInfoList.add(answerOptionInfoModel);
    } else {
      // Handle invalid data gracefully
      print("AnswerOptionInfoModel is invalid. Skipping update.");
      // Optionally, leave old data in place or provide user feedback
    }
  }
}