import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../question_model/question_model.dart';

class DefaultQuestionPostfix extends StatefulWidget {

  final QuestionModel questionModel;
  final VoidCallback onDelete; // Callback for deletion

  const DefaultQuestionPostfix({
    Key? key,
    required this.questionModel,
    required this.onDelete,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _DefaultQuestionPostfixState();
}

class _DefaultQuestionPostfixState extends State<DefaultQuestionPostfix> {

  // Controllers to hold the text input for each option
  final List<TextEditingController> _optionControllers = List.generate(
    5,
        (index) => TextEditingController(),
  );
  final List<String> _options = List.filled(5, '');

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: widget.onDelete,
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // Red color to indicate a delete action
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          child: const Text(
            " - 문제 삭제",
            style: TextStyle(
                fontSize: 16, color: Colors.white
            ),
          ),
        ),
        const SizedBox(height: 16), // Add spacing before the horizontal line
        const Divider(
          thickness: 1, // Thickness of the line
          color: Colors.white, // Color of the line
          height: 1, // Space around the line
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}