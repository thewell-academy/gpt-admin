// 질문 모델
class AnswerOptionInfoModel {
  String option1 = '';
  String option2 = '';
  String option3 = '';
  String option4 = '';
  String option5 = '';
  int answer = 0;
  String memo = '';

  Map<String, dynamic> toJson() {
    return {
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