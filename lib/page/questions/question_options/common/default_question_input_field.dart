import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../question_model/question_model.dart';

// 문제 번호, 배점, 보기 옵션, 정답 입력
class DefaultQuestionInputField extends StatefulWidget {

  final QuestionModel questionModel;
  // util/question_data_handler.dart -> updateDefaultQuestionInfo()
  final Function(QuestionModel, String, String, List<String>, String, List<String>, String, String) onUpdate;

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

  bool abcOptionExists = false; // Default to false
  final List<String> abcOptionList = [];
  final List<TextEditingController> _abcControllers = [];

  @override
  void initState() {
    super.initState();
    _abcControllers.add(
        TextEditingController()
    );
  }

  void _addTextField() {
    setState(() {
      _abcControllers.add(
        TextEditingController()
      );
    });
  }

  void _removeLastTextField() {
    if (_abcControllers.isNotEmpty) {
      setState(() {
        _abcControllers.removeLast();
        abcOptionList.removeLast();
      });
    }
  }

  void _updateAbcOptionList() {
    setState(() {
      abcOptionList.removeWhere((element) => true);
      for (var element in _abcControllers) {
        String value = element.text;
        if (value.isNotEmpty) {
          abcOptionList.add(value);
        }
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    for (var controller in _optionControllers) {
      controller.dispose();
    }

    for (var entry in _abcControllers) {
      entry.dispose();
    }
    super.dispose();
  }

  void _updateParent() {
    widget.onUpdate(
        widget.questionModel,
        _selectedQuestionNumber?? '',
        _selectedScore?? '',
        abcOptionList,
        _selectedQuestionText?? '',
        _options,
        _selectedAnswer?? '',
        _memo
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "문제 번호",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16,),
        SizedBox(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedQuestionNumber = value.isNotEmpty ? value : null;
                _updateParent();
              });
            },
          ),
        ),
        const SizedBox(height: 16,),
        const Text(
          "배점",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16,),
        SizedBox(
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
        const SizedBox(height: 16,),
        Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: abcOptionExists,
                  onChanged: (value) {
                    setState(() {
                      abcOptionExists = value ?? false;
                    });
                  },
                ),
                const Text(
                  "보기 있음 (a b c, 가 나 다 등)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (abcOptionExists)
              Column(
                children: [
                  // List of TextFields
                  ..._abcControllers.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: entry,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '내용',
                              ),
                              onChanged: (text) {
                                _updateAbcOptionList();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  // Add and Remove buttons
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        ),
                        onPressed: _addTextField,
                        child: const Text("+ 보기 추가하기"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        ),
                        onPressed: _removeLastTextField,
                        child: const Text("보기 삭제하기"),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "문제",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16,),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _selectedQuestionText = value;
            });
            _updateParent();
          },
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
                      border: const OutlineInputBorder(), // Add border around TextField
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

        const Text(
          "정답",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
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