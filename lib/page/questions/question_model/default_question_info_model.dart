import 'dart:typed_data';

class DefaultQuestionInfoModel {
  String exam;
  int examYear;
  int examMonth;
  int questionNumber;
  int questionScore;
  String questionText;
  String filePath;
  Uint8List? selectedFileBytes;

  DefaultQuestionInfoModel({
    this.exam = '',
    this.examYear = 0,
    this.examMonth = 0,
    this.questionNumber = 0,
    this.questionScore = 0,
    this.questionText = '',
    this.filePath = '',
    this.selectedFileBytes
  });

  Map<String, dynamic> toJson() {
    return {
      'exam': exam,
      'examYear': examYear,
      'examMonth': examMonth,
      'questionNumber': questionNumber,
      'questionScore': questionScore,
      'questionText': questionText,
      'filePath': filePath
    };
  }

  bool isValid() {

    bool valid1 = (exam == "수능");
    bool valid2 = (exam != "수능" && examMonth > 0);

    if (
    exam.isNotEmpty && examYear > 0
        && (valid1 || valid2)
        && questionNumber > 0 && questionScore > 0 && questionText.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}