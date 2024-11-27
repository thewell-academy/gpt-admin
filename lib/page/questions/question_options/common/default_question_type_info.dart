import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thewell_gpt_admin/page/questions/question_model/question_model.dart';

import '../../util/question_types.dart';


class DefaultQuestionTypeInfo extends StatefulWidget {
  final QuestionModel questionModel;
  // util/question_data_handler.dart -> updateDefaultQuestionInfo()
  final Function(QuestionModel, String, String, String,String, String, String) onUpdate;

  DefaultQuestionTypeInfo({
    Key? key,
    required this.questionModel,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _DefaultQuestionTypeInfoState createState() => _DefaultQuestionTypeInfoState();
}

class _DefaultQuestionTypeInfoState extends State<DefaultQuestionTypeInfo> {
  String? _selectedExam; // Selected exam type (e.g., "수능" or "모의고사")
  String? _selectedYear; // Selected year or sub-item
  String? _selectedMonth;
  String? _selectedQuestionNumber;
  String? _selectedFileName; // Store the selected file's name or path
  String? _selectedScore; // Declare in the state class
  String? _selectedQuestionText;

  void _pickFile() async {
    // Open file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Restrict to image files
    );

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name; // Get the file name
      });
    }
  }

  void _updateParent() {
    if (_selectedExam != null && _selectedYear != null) {
      widget.onUpdate(
        widget.questionModel,
        _selectedExam!,
        _selectedYear!,
        _selectedMonth ?? '',
        _selectedQuestionNumber?? '',
        _selectedScore?? '',
        _selectedQuestionText?? ''
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "시험 선택",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16), // Add spacing after Markdown input
        // First set of radio buttons for exam type
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: examList.keys.map((exam) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: exam,
                  groupValue: _selectedExam,
                  onChanged: (value) {
                    setState(() {
                      _selectedExam = value;
                      _selectedYear = null; // Reset the year selection
                    });
                    _updateParent();
                  },
                ),
                Text(exam),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 16), // Add spacing after Markdown input
        // Second set of radio buttons for years or sub-items
        if (_selectedExam != null && examList[_selectedExam!] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "세부 연도 / 월 선택: $_selectedExam",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16), // Add spacing after Markdown input
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: examList[_selectedExam!]!.map((year) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: year,
                        groupValue: _selectedYear,
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value;
                          });
                          _updateParent();
                        },
                      ),
                      Text(year),
                    ],
                  );
                }).toList(),
              ),
              if (_selectedExam == "모의고사") ...[
                const SizedBox(height: 16),
                Text(
                  "월 선택:",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _selectedMonth,
                  hint: const Text("월 선택"),
                  items: List<String>.generate(12, (index) => "${index+1}월").map((month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                    });
                    _updateParent();
                    // Handle month selection logic if needed
                  },
                ),
              ],
            ],
          ),
        Column(
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
            Text(
              "(Optional) 사진",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text("사진 선택"),
                  ),
                  if (_selectedFileName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "선택된 파일: $_selectedFileName",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}