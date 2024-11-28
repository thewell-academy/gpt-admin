import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../question_model/question_model.dart';
import '../../util/latex_input_renderer.dart';
import '../../util/question_data_handler.dart';
import '../common/default_question_answer_info.dart';
import '../common/default_question_type_info.dart';

// English Question Option Widget for "글의 목적 / 글의 분위기 / 대의 파악 / 함의 추론 / 도표 이해 / 내용 일치"
class EnglishQuestionType2 extends StatefulWidget {

  final QuestionModel questionModel;
  final VoidCallback onDelete;
  const EnglishQuestionType2({
    required Key key,
    required this.questionModel,
    required this.onDelete,

  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnglishQuestionType2State();
}

class _EnglishQuestionType2State extends State<EnglishQuestionType2> {
  String? questionText; // Holds the text input by the user

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the content
      child: SingleChildScrollView( // Make the content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultQuestionTypeInfo(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateDefaultQuestionInfo,
            ),

            SizedBox(height: 16),

            MarkdownInputAndRender(
              title: '첫 지문',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateHTMLRenderedText,
            ),
            SizedBox(height: 16),

            MarkdownInputAndRender(
              title: '지문 A',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateHTMLRenderedText,
            ),
            SizedBox(height: 16),

            MarkdownInputAndRender(
              title: '지문 B',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateHTMLRenderedText,
            ),
            SizedBox(height: 16),

            MarkdownInputAndRender(
              title: '지문 C',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateHTMLRenderedText,
            ),
            SizedBox(height: 16),

            MarkdownInputAndRender(
              title: '지문 원본 (정답이 추가된, 완벽한 지문을 적어주세요)',
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateHTMLRenderedText,
            ),

            SizedBox(height: 16),

            DefaultQuestionAnswerOptionInfo(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateAnswerOptionsInfo,
              onDelete: widget.onDelete,
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}