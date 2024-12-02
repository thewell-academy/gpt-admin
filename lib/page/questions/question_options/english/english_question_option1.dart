import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/question_options/common/default_question_input_field.dart';
import '../../question_model/question_model.dart';
import '../../question_router.dart';
import '../../util/latex_input_renderer.dart';
import '../../util/question_data_handler.dart';
import '../common/default_answer_postfix.dart';
import '../common/default_question_prefix.dart';

// English Question Option Widget for "글의 목적 / 글의 분위기 / 대의 파악 / 함의 추론 / 도표 이해 / 내용 일치"
class EnglishQuestionType1 extends StatefulWidget {

  final QuestionModel questionModel;
  final VoidCallback onDelete;

  const EnglishQuestionType1({
    required Key key,
    required this.questionModel,
    required this.onDelete,

  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnglishQuestionType1State();
}

class _EnglishQuestionType1State extends State<EnglishQuestionType1> {
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

            MarkdownInputAndRender(
              title: '문제 지문',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateHTMLRenderedText,
            ),

            MarkdownInputAndRender(
              title: '지문 원본 (정답이 추가된, 완벽한 지문을 적어주세요)',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateHTMLRenderedText,
            ),

            DefaultQuestionInputField(
                questionModel: widget.questionModel,
                onUpdate: QuestionDataHandler.updateAnswerOptionsInfo,
            ),

            DefaultQuestionPostfix(
              questionModel: widget.questionModel,
              onDelete: widget.onDelete,
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}