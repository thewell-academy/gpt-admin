import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../question_model/question_model.dart';

// 문제 번호, 배점, 보기 옵션, 정답 입력
class DefaultQuestionInputField extends StatefulWidget {

  final QuestionModel questionModel;
  // util/question_data_handler.dart -> updateDefaultQuestionInfo()
  final Function(QuestionModel, String, String, String, String, String, String, String, String, String, String) onUpdate;

  const DefaultQuestionInputField({
    Key? key,
    required this.questionModel,
    required this.onUpdate,
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _DefaultQuestionInputFieldState();
}

class _DefaultQuestionInputFieldState extends State<DefaultQuestionInputField> {

  String? _selectedQuestionNumber;
  String? _selectedScore; // Declare in the state class
  String? _selectedQuestionText;

  String? _selectedAnswer; // Declare in the state class
  String _memo = '';

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

  void _updateParent() {
    widget.onUpdate(
        widget.questionModel,
        _selectedQuestionNumber?? '',
        _selectedScore?? '',
        _selectedQuestionText?? '',
        _options[0],
        _options[1],
        _options[2],
        _options[3],
        _options[4],
        _selectedAnswer?? '',
        _memo
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "문제 번호",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16,),
        Container(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number, // Ensure the keyboard is numeric
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allow digits only
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedQuestionNumber = value;
              });
              _updateParent();
            },
          ),
        ),
        SizedBox(height: 16,),
        Text(
          "배점",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16,),
        Container(
          width: 100, // Adjust the width to fit the dropdown
          child: DropdownButton<String>(
            value: _selectedScore, // Bind to a state variable
            hint: const Text("Select"), // Placeholder text
            items: ['2', '3', '4'] // Values for the dropdown
                .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value.toString()),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedScore = value.toString();
              });
              _updateParent();
            },
            isExpanded: true, // Optional: Make it take the full width
          ),
        ),
        SizedBox(height: 16,),
        Text(
          "문제",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16,),
        Container(
          child: TextField(
            // keyboardType: TextInputType.number, // Ensure the keyboard is numeric
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.digitsOnly, // Allow digits only
            // ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedQuestionText = value;
              });
              _updateParent();
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "정답 선택지",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16), // Add spacing between options
        Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "보기 ${index + 1}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // Add spacing before TextField
                  TextField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Add border around TextField
                      hintText: "보기 ${index + 1} 적기",
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: (value) {
                      setState(() {
                        _options[index] = value;
                      });
                      _updateParent();
                    },
                  ),
                  const SizedBox(height: 16), // Add spacing between options
                ],

              );
            }),
          ),
        ),

        Text(
          "정답",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 100, // Adjust the width to fit the dropdown
          child: DropdownButton<String>(
            value: _selectedAnswer, // Bind to a state variable
            hint: const Text("Select"), // Placeholder text
            items: ['1','2', '3', '4','5'] // Values for the dropdown
                .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value.toString()),
            ))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedAnswer = newValue; // Update the state with the selected value
              });
              _updateParent();
            },
            isExpanded: true, // Optional: Make it take the full width
          ),
        ),
        const SizedBox(height: 16), // Add spacing between options
        const Text(
          "메모",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16), // Add spacing between options
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(), // Add border around TextField
            hintText: "단어 힌트 등 메모 적기",
          ),
          style: const TextStyle(fontSize: 14),
          onChanged: (value) {
            setState(() {
              _memo = value;
            });
            _updateParent();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}