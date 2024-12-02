// 질문 모델
class AnswerOptionInfoModel {
  int questionNumber = 0;
  int questionScore = 0;
  String questionText = '';
  String option1 = '';
  String option2 = '';
  String option3 = '';
  String option4 = '';
  String option5 = '';
  int answer = 0;
  String memo = '';

  AnswerOptionInfoModel({
    required this.questionNumber,
    required this.questionScore,
    required this.questionText,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.option5,
    required this.answer,
    required this.memo
});

  Map<String, dynamic> toJson() {
    return {
      'questionNumber': questionNumber,
      'questionScore': questionScore,
      'questionText': questionText,
      'options': [option1, option2, option3, option4, option5],
      'selectedAnswer': answer,
      'memo': memo,
    };
  }

  bool isValid() {

    if (option1.isNotEmpty && option2.isNotEmpty && option3.isNotEmpty && option4.isNotEmpty && option5.isNotEmpty && answer > 0) {
      return true;
    } else {
      return false;
    }
  }

}