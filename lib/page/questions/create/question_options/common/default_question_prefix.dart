import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../question_model/question_model.dart';
import '../../util/question_types.dart';



class DefaultQuestionPrefix extends StatefulWidget {
  final QuestionModel questionModel;
  final Function(QuestionModel, String, String, String, String, String) onUpdate;

  const DefaultQuestionPrefix({
    Key? key,
    required this.questionModel,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _DefaultQuestionPrefixState createState() => _DefaultQuestionPrefixState();
}

class _DefaultQuestionPrefixState extends State<DefaultQuestionPrefix> {
  String? _selectedExam; // Selected exam type (e.g., "수능" or "모의고사")
  String? _selectedYear; // Selected year or sub-item
  String? _selectedMonth;
  String? _selectedGrade;
  String ? _selectedFilePath;
  String? _selectedFileName; // Store the selected file's name or path
  Uint8List? _selectedFileBytes; // File bytes for web platforms

  void _fileSelectRouter() async {
    if (_selectedFilePath != null || _selectedFileBytes != null) {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("사진 삭제"),
          content: const Text("사진을 삭제하시겠습니까?"),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("취소"),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("확인"),
              onPressed: () {
                setState(() {
                  _selectedFileBytes = null;
                  _selectedFilePath = null;
                  _selectedFileName = null;
                });
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        ),
      );
    } else {
      return _pickFile();
    }
  }

  void _pickFile() async {
    // Open file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Restrict to image files
    );

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name; // Get the file name


        if (kIsWeb) {
          // Web: Use bytes as no path is available
          _selectedFileBytes = result.files.single.bytes;
          _selectedFilePath = null; // Explicitly set to null for clarity
        } else {
          // Non-web platforms: Use the file path
          _selectedFilePath = result.files.single.path;
          _selectedFileBytes = null; // Explicitly set to null for clarity
        }
      });
      widget.questionModel.defaultQuestionInfo.selectedFileBytes = _selectedFileBytes;
    }
  }

  void _updateParent() {
    if (_selectedExam != null && _selectedYear != null) {
      widget.onUpdate(
        widget.questionModel,
        _selectedExam!,
        _selectedYear!,
        _selectedMonth ?? '',
        _selectedGrade ?? '',
        _selectedFilePath?? ''
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              if (_selectedExam == "모의고사")
                Row(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "학년 선택",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: _selectedGrade,
                          hint: const Text("학년 선택"),
                          items: List<String>.generate(3, (index) => "고${index+1}").map((month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(month),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGrade = value!;
                            });
                            _updateParent();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "월 선택",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<String>(
                          value: _selectedMonth,
                          hint: const Text("월 선택"),
                          items: List<String>.generate(12, (index) => "${index+1}").map((month) {
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
                    ),
                  ],
                )
              ],
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "(Optional) 사진",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _fileSelectRouter,
                    child: (_selectedFileBytes == null && _selectedFilePath == null)
                        ? const Text("사진 선택")
                        : const Text("사진 삭제"),
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
            const SizedBox(height: 16),
          ],
        )
      ],
    );
  }
}