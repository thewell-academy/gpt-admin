import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../question_model/question_model.dart';
import '../common/default_content_text_input_field.dart';
import '../../util/question_data_handler.dart';
import '../common/default_answer_postfix.dart';
import '../common/default_question_input_field.dart';
import '../common/default_question_prefix.dart';

// English Question Option Widget for "글의 목적 / 글의 분위기 / 대의 파악 / 함의 추론 / 도표 이해 / 내용 일치"
class EnglishQuestionType6 extends StatefulWidget {

  final QuestionModel questionModel;
  final VoidCallback onDelete;
  const EnglishQuestionType6({
    required Key key,
    required this.questionModel,
    required this.onDelete,

  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnglishQuestionType6State();
}

class _EnglishQuestionType6State extends State<EnglishQuestionType6> {
  String? questionText; // Holds the text input by the user

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the content
      child: SingleChildScrollView( // Make the content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultQuestionPrefix(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateDefaultQuestionInfo,
            ),

            DefaultContentTextInputField(
              title: '지문 A',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateDeltaTextForContentTextMap,
              questionTextFieldHeight: 500,

            ),

            DefaultContentTextInputField(
              title: '지문 B',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateDeltaTextForContentTextMap,
              questionTextFieldHeight: 500,
            ),

            DefaultContentTextInputField(
              title: '지문 C',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateDeltaTextForContentTextMap,
              questionTextFieldHeight: 500,
            ),

            DefaultContentTextInputField(
              title: '지문 D',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateDeltaTextForContentTextMap,
              questionTextFieldHeight: 500,
            ),

            DefaultQuestionInputField(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateAnswerOptionsInfo,
              questionTextFieldHeight: 150,
            ),

            DefaultQuestionInputField(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateAnswerOptionsInfo,
              questionTextFieldHeight: 150,
            ),

            DefaultQuestionInputField(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateAnswerOptionsInfo,
              questionTextFieldHeight: 150,
            ),

            DefaultQuestionPostfix(
              questionModel: widget.questionModel,
              onDelete: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
}