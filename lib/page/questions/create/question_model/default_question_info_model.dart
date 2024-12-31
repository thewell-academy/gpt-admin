import 'dart:typed_data';

class DefaultQuestionInfoModel {
  String exam;
  int examYear;
  int examMonth = 0;
  String grade;
  String filePath;
  Uint8List? selectedFileBytes;

  DefaultQuestionInfoModel({
    this.exam = '',
    this.examYear = 0,
    this.examMonth = 0,
    this.grade = '',
    this.filePath = '',
    this.selectedFileBytes
  });

  Map<String, dynamic> toJson() {
    return {
      'exam': exam,
      'examYear': examYear,
      'examMonth': examMonth,
      'grade': grade,
      'filePath': filePath
    };
  }

  bool isValid() {

    print("$exam $examYear $examMonth");

    bool valid1 = (exam == "수능");
    bool valid2 = (exam != "수능" && examMonth > 0);
    print("default info ---");
    print(valid1);
    print(valid2);
    print("---");

    if (exam.isNotEmpty && examYear > 0
        && (valid1 || valid2)) {
      return true;
    } else {
      return false;
    }
  }
}