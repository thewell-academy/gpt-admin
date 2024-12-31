import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../question_model/question_model.dart';
import '../../util/latex_input_renderer.dart';
import '../../util/question_data_handler.dart';
import '../common/default_answer_postfix.dart';
import '../common/default_question_input_field.dart';
import '../common/default_question_prefix.dart';

class ScienceQuestionType1 extends StatefulWidget {

  final QuestionModel questionModel;
  final VoidCallback onDelete;

  const ScienceQuestionType1({
    required Key key,
    required this.questionModel,
    required this.onDelete,

  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScienceQuestionType1State();
}

class _ScienceQuestionType1State extends State<ScienceQuestionType1> {
  String? questionText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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

            DefaultQuestionInputField(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateAnswerOptionsInfo,
            ),

            DefaultQuestionPostfix(
              questionModel: widget.questionModel,
              onDelete: widget.onDelete,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}