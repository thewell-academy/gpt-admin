import 'package:thewell_gpt_admin/page/questions/create/question_model/question_model.dart';

class QuestionRouterState {
  int questionId;
  String selectedSubject;
  QuestionModel questionModel;
  String? selectedQuestionType;

  QuestionRouterState({
    required this.questionId,
    required this.selectedSubject,
    required this.questionModel,
    this.selectedQuestionType,
  });

  Map<String, dynamic> toJson() {
    return {
      "questionId": questionId,
      "subject": selectedSubject,
      "questionModel": questionModel.toJson(),
      "questionType": selectedQuestionType?? ""
    };
  }
}