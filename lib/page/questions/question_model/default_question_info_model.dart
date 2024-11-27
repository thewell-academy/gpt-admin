// 질문 모델
class DefaultQuestionInfoModel {
  String exam = '';
  int examYear = 0;
  int examMonth = 0;
  int questionNumber = 0;
  int questionScore = 0;
  String questionText = '';

  // Default constructor with optional named parameters
  DefaultQuestionInfoModel({
    this.exam = '',
    this.examYear = 0,
    this.examMonth = 0,
    this.questionNumber = 0,
    this.questionScore = 0,
    this.questionText = '',
  });
}