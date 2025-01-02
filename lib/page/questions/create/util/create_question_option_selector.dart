import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/create/question_router.dart';
import 'package:thewell_gpt_admin/page/questions/create/util/save_questions.dart';

import '../../../../util/util.dart';
import '../question_model/default_question_info_model.dart';
import '../question_model/question_model.dart';
import '../question_model/question_router_state.dart';

class CreateQuestionOptionSelector extends StatefulWidget {
  const CreateQuestionOptionSelector({super.key});

  @override
  State<StatefulWidget> createState() => _CreateQuestionOptionSelectorState();
}

class _CreateQuestionOptionSelectorState extends State<CreateQuestionOptionSelector> {
  String? _selectedSubject;
  String? _selectedExamType;
  Map<String, dynamic>? subjectDetails;
  List<Map<String, String>> dynamicSelections = [];
  bool isLastSelection = false;
  bool isLoading = false;

  final List<int> years = List.generate(11, (index) => 2015 + index).reversed.toList();
  int? selectedYear;
  final List<int> months = List.generate(12, (index) => index + 1);
  int? selectedMonth;
  final List<String> grades = List.generate(3, (index) => "고${index+1}");
  String? selectedGrade;

  QuestionRouterState? _questionRouterState;

  bool replaceSuccess = false;

  void _initQuestionRouterState() {

    setState(() {
      _questionRouterState = QuestionRouterState(
        questionId: 1,
        selectedSubject: _selectedSubject!,
        questionModel: QuestionModel(
          subject: _selectedSubject!,
          defaultQuestionInfo: DefaultQuestionInfoModel(
            exam: _selectedExamType!,
          ),
          answerOptionInfoList: [],
        ),
        selectedQuestionType: dynamicSelections.map(
                (e) => e["selected"]!
        ).toList().join(" > ")
      );
    });
  }

  void _resetQuestionRouterState() {
    setState(() {
      _questionRouterState = null;
    });
  }

  Widget _buildSaveConfirmationDialog(BuildContext context, void Function(void Function()) setState)
  {
    bool isSaving = false;
    bool isSuccess = false;

    // 문제 데이터가 정확히 입력되지 않은 경우
    if (_questionRouterState == null || !_questionRouterState!.questionModel.isValid()) {
      return CupertinoAlertDialog(
        title: const Text("문제 데이터 검증 필요"),
        content: Column(
          children: const [
            Text("문제 데이터를 모두 입력했는지 다시 확인해주세요."),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("확인"),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
          ),
        ],
      );
    }


    return CupertinoAlertDialog(
      title: const Text("문제 저장하기"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
           Text("문제를 저장하시겠습니까?"),
          SizedBox(height: 16),
        ],
      ),
      actions: [
        if (!isSaving && !isSuccess)
          CupertinoDialogAction(
            child: const Text("취소"),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
          ),
        if (!isSaving && !isSuccess)
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () async {
              setState(() {
                isSaving = true;
              });
              int? responseCodes = await getQuestionSaveResult(_questionRouterState!, false);
              setState(() {
                isSaving = false;
                isSuccess = responseCodes == 200;
              });
              Navigator.pop(context);
              Future.microtask(() {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return _buildSecondSaveConfirmationDialog(
                      context,
                      _questionRouterState!,
                      responseCodes,
                      setState,
                    );
                  },
                );
              });
            },
            child: const Text("저장하기"),
          ),
      ],
    );
  }

    Widget _buildSecondSaveConfirmationDialog(
      BuildContext context,
      QuestionRouterState questionRouterState,
      int? responseCode,
      void Function(void Function()) contextSetState,
      )
    {
      if (responseCode == 200) {
        return CupertinoAlertDialog(
          content: const Text("저장되었습니다."),
          actions: [
            CupertinoDialogAction(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      } else if (responseCode == 203) {
        return CupertinoAlertDialog(
          title: const Text("중복된 문제 처리"),
          content: !replaceSuccess
              ? const Text("문제가 중복되었습니다. 처리 방법을 선택해주세요.")
              : const Text("중복 처리가 완료되었습니다."),
          actions: [
            if (!replaceSuccess)
            CupertinoDialogAction(
              child: const Text("덮어쓰기"),
              onPressed: () async {
                  await getQuestionSaveResult(questionRouterState, true) == 200;
                  Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text("닫기"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
      else {
        return CupertinoAlertDialog(
          content: const Text("오류가 발생했습니다. 다시 시도해주세요.."),
          actions: [
            CupertinoDialogAction(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    }

  Widget _buildDynamicSelection(Map<String, dynamic> data) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(dynamicSelections.length + 1, (level) {
        Map<String, dynamic>? currentLevel = data;

        // Traverse through levels
        for (int i = 0; i < level && i < dynamicSelections.length; i++) {
          final selectedKey = dynamicSelections[i]["selected"];
          if (currentLevel != null && selectedKey != null) {
            currentLevel = currentLevel[selectedKey] as Map<String, dynamic>?;
          }
        }

        final options = currentLevel?.keys.toList() ?? [];
        if (options.isEmpty) return const SizedBox.shrink();

        final selectedItem = level < dynamicSelections.length
            ? dynamicSelections[level]["selected"]
            : null;

        final displaySelected = selectedItem ?? "유형 ${level + 1} 선택";

        return DropdownButton<String>(
          value: selectedItem,
          hint: Text(displaySelected),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (selectedOption) {
            setState(() {
              // Update selection
              if (level < dynamicSelections.length) {
                dynamicSelections[level]["selected"] = selectedOption!;
                dynamicSelections = dynamicSelections.sublist(0, level + 1);
              } else {
                dynamicSelections.add({"selected": selectedOption!});
              }

              final selectedValue = currentLevel?[selectedOption];
              if (selectedValue == null || selectedValue is! Map || selectedValue.isEmpty) {
                isLastSelection = true;
              } else {
                isLastSelection = false;
              }
            });
            if (isLastSelection) {
              _initQuestionRouterState();
            } else {
              _resetQuestionRouterState();
            }
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: DropdownButton<String>(
                    value: _selectedSubject,
                    hint: const Text("과목 선택"),
                    items: ["수학", "영어", "과학"].map((subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(subject),
                      );
                    }).toList(),
                    onChanged: (subject) async {
                      setState(() {
                        _selectedSubject = subject;
                        _selectedExamType = null;
                        isLoading = true;
                        subjectDetails = null;
                        dynamicSelections.clear();
                      });

                      final details = await fetchSubjectDetails(subject!);

                      setState(() {
                        subjectDetails = details;
                        isLoading = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                if (_selectedSubject != null)
                  Flexible(
                    flex: 2,
                    child: DropdownButton<String>(
                      value: _selectedExamType,
                      hint: const Text("시험 유형 선택"),
                      items: ["수능", "모의고사"].map((examType) {
                        return DropdownMenuItem<String>(
                          value: examType,
                          child: Text(examType),
                        );
                      }).toList(),
                      onChanged: (examType) {
                        setState(() {
                          _selectedExamType = examType;
                        });
                      },
                    ),
                  ),
                if (isLoading) ...[
                  const SizedBox(width: 10),
                  const CircularProgressIndicator(),
                ]
              ],
            ),
            const SizedBox(height: 16),

            // Year and Month Selection
            if (_selectedExamType != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: DropdownButton<int>(
                      value: selectedYear,
                      hint: const Text("연도 선택"),
                      items: years.map((year) {
                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }).toList(),
                      onChanged: (year) {
                        setState(() {
                          selectedYear = year;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (_selectedExamType == "모의고사")
                    Flexible(
                      flex: 2,
                      child: DropdownButton<int>(
                        value: selectedMonth,
                        hint: const Text("월 선택"),
                        items: months.map((month) {
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text("$month"),
                          );
                        }).toList(),
                        onChanged: (month) {
                          setState(() {
                            selectedMonth = month;
                          });
                        },
                      ),
                    ),
                  const SizedBox(width: 16),
                  if (_selectedExamType == "모의고사")
                    Flexible(
                      flex: 2,
                      child: DropdownButton<String>(
                        value: selectedGrade,
                        hint: const Text("학년"),
                        items: grades.map((grade) {
                          return DropdownMenuItem<String>(
                            value: grade,
                            child: Text(grade),
                          );
                        }).toList(),
                        onChanged: (grade) {
                          setState(() {
                            selectedGrade = grade;
                          });
                        },
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 20),

            if (subjectDetails != null && _selectedExamType != null)
              _buildDynamicSelection(subjectDetails!),


            if (isLastSelection && _questionRouterState != null)
              QuestionRouter(
                  key: ValueKey(_questionRouterState),
                  pageState: _questionRouterState!,
                  onDelete: _resetQuestionRouterState
              ),

            const SizedBox(height: 20),
            if (_selectedSubject != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    setState(() {
                      _questionRouterState!.questionModel.defaultQuestionInfo.examMonth = selectedMonth?? 0;
                      _questionRouterState!.questionModel.defaultQuestionInfo.examYear = selectedYear!;
                      _questionRouterState!.questionModel.defaultQuestionInfo.exam = _selectedExamType!;
                      _questionRouterState!.questionModel.defaultQuestionInfo.grade = selectedGrade ?? "";
                    });

                    showCupertinoDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(
                            builder: (context, setState) {
                              return _buildSaveConfirmationDialog(context, setState);
                            }
                        )
                    );
                  },
                  child: const Text("문제 저장하기"),
                ),
              ),

          ],
        )
    );

  }
}