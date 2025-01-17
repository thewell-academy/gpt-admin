import 'package:flutter/cupertino.dart';
import 'package:thewell_gpt_admin/page/questions/create/question_options/common/text_input_field_and_renderer.dart';

import '../../question_model/question_model.dart';

class DefaultContentTextInputField extends StatefulWidget {

  final QuestionModel questionModel;
  final String title;
  final Function(QuestionModel, String, String) onUpdate;
  final double questionTextFieldHeight;

  const DefaultContentTextInputField({
    super.key,
    required this.questionModel,
    required this.title,
    required this.onUpdate,
    required this.questionTextFieldHeight
  });

  @override
  State<StatefulWidget> createState() => _DefaultContentTextInputField();
}

class _DefaultContentTextInputField extends State<DefaultContentTextInputField> {

  String contentTextString = "";

  void _updateParent() {
    widget.onUpdate(
        widget.questionModel,
        widget.title,
        contentTextString
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextInputFieldAndRenderer(
      questionModel: widget.questionModel,
      title: widget.title,
      onUpdate: (String updatedData) {
        setState(() {
          contentTextString = updatedData;
        });
        _updateParent();
        },
      height: widget.questionTextFieldHeight,
    );
  }
}