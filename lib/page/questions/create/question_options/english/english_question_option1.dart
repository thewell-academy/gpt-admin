import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/create/question_options/common/default_content_text_input_field.dart';
import '../../question_model/question_model.dart';
import '../../util/question_data_handler.dart';
import '../common/default_answer_postfix.dart';
import '../common/default_question_input_field.dart';
import '../common/default_question_prefix.dart';

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

            DefaultContentTextInputField(
                questionModel: widget.questionModel,
                title: "문제 지문",
                onUpdate: QuestionDataHandler.updateDeltaTextForContentTextMap,
                questionTextFieldHeight: 500
            ),

            DefaultContentTextInputField(
                questionModel: widget.questionModel,
                title: "지문 원본 (정답이 추가된, 완벽한 지문을 적어주세요)",
                onUpdate: QuestionDataHandler.updateDeltaTextForContentTextMap,
                questionTextFieldHeight: 500
            ),

            DefaultQuestionInputField(
              questionModel: widget.questionModel,
              onUpdate: QuestionDataHandler.updateAnswerOptionsInfo,
              questionTextFieldHeight: 150,
              questionOrder: 0,
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