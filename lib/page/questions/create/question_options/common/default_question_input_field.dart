import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thewell_gpt_admin/page/questions/create/question_options/common/text_input_field_and_renderer.dart';

import '../../question_model/question_model.dart';

class DefaultQuestionInputField extends StatefulWidget {

  final QuestionModel questionModel;
  final Function(QuestionModel, int,  String, String, List<String>, String, List<String>, String, String, bool) onUpdate;
  final double questionTextFieldHeight;
  final int questionOrder;

  const DefaultQuestionInputField({
    super.key,
    required this.questionModel,
    required this.onUpdate,
    required this.questionTextFieldHeight,
    required this.questionOrder,
  });

  @override
  State<StatefulWidget> createState() => _DefaultQuestionInputFieldState();
}

class _DefaultQuestionInputFieldState extends State<DefaultQuestionInputField> {

  String? _selectedQuestionNumber;
  String? _selectedScore;
  String _selectedQuestionText = "";

  String? _selectedAnswer; // Declare in the state class
  String _memo = '';

  bool? isShortAnswer = false;
  String shortAnswer = "주관식";

  bool? answerOptionNotExists = false;
  String answerOptionNotExistsString = "정답 선택지 없음";

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
    _abcControllers.add(TextEditingController());
    for (var controller in _abcControllers) {
      controller.addListener(_updateAbcOptionList);
    }
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
      abcOptionList
        ..clear()
        ..addAll(_abcControllers.map((controller) => controller.text).where((text) => text.isNotEmpty));
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    for (var controller in _optionControllers) {
      controller.dispose();
    }

    for (var controller in _abcControllers) {
      controller.removeListener(_updateAbcOptionList);
      controller.dispose();
    }

    super.dispose();
  }

  void _updateParent() {
    widget.onUpdate(
      widget.questionModel,
      widget.questionOrder,
      _selectedQuestionNumber?? '',
      _selectedScore?? '',
      abcOptionList,
      _selectedQuestionText?? '',
      _options,
      _selectedAnswer?? '',
      _memo,
      answerOptionNotExists ?? false,
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
          width: 100,
          child: DropdownButton<String>(
            value: _selectedScore,
            hint: const Text("Select"),
            items: ['2', '3', '4']
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
            isExpanded: true,
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
                  "보기 있음 (a b c, 가 나 다, 조건 등)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (abcOptionExists)
              Column(
                children: [
                  ..._abcControllers.map((controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextInputFieldAndRenderer(
                              questionModel: widget.questionModel,
                              title: "보기 내용",
                              onUpdate: (String text) {
                                setState(() {
                                  controller.text = text; // Update the TextEditingController
                                });
                                _updateAbcOptionList(); // Update the abcOptionList
                              },
                              height: 150,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
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
        TextInputFieldAndRenderer(
          title: "문제",
          questionModel: widget.questionModel,
          onUpdate: (String updatedData) {
            setState(() {
              _selectedQuestionText = updatedData;
            });
            _updateParent();
            },
          height: widget.questionTextFieldHeight,
        ),
        Row(
          children: [
            const Text(
              "정답 선택지",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Checkbox(
                value: answerOptionNotExists,
                onChanged: (value) {
                  setState(() {
                    answerOptionNotExists = value;
                    _updateParent();
                  });
                }
            ),
            Text(answerOptionNotExistsString),
          ],
        ),
        const SizedBox(height: 16),
        if (answerOptionNotExists != null && !answerOptionNotExists!)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInputFieldAndRenderer(
                      questionModel: widget.questionModel,
                      title: "정답 ${index + 1}",
                      onUpdate: (String value) {
                        setState(() {
                          _options[index] = value;
                        });
                        _updateParent();
                      },
                      height: 150,
                  )
                ],

              );
            }),
          ),
        ),

        const Text(
          "정답",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            if (isShortAnswer != true)
              SizedBox(
                width: 150,
                child: DropdownButton<String>(
                  value: _selectedAnswer,
                  hint: const Text("답안 고르기"),
                  items: ['1','2', '3', '4','5']
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.toString()),
                  ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAnswer = newValue;
                    });
                    _updateParent();
                  },
                  isExpanded: true,
                ),
              ),
            if (isShortAnswer == true)
                  SizedBox(
                    width: 150,
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
                          _selectedAnswer = value;
                        });
                        _updateParent();
                      },
                    ),
                  ),
            Checkbox(
                value: isShortAnswer,
                onChanged: (value) {
                  setState(() {
                    isShortAnswer = value;
                  });
                }
            ),
            Text(shortAnswer),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "메모",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
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