import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/create/question_router.dart';
import 'package:thewell_gpt_admin/page/questions/create/util/question_types.dart';
import 'package:thewell_gpt_admin/page/questions/create/util/save_questions.dart';

import 'question_model/default_question_info_model.dart';
import 'question_model/question_model.dart';

class CreateQuestionPage extends StatefulWidget {
  const CreateQuestionPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestionPage> {
  String? _selectedSubject; // State variable for selected subject
  final List<QuestionPageState> _questionPages = []; // List of question page states

  final _questionTypes = questionTypes;
  late final List<int?> questionAddResponseCodeList = [];

  void _addQuestionPage() {
    setState(() {
      if (_selectedSubject != null) {
        _questionPages.add(QuestionPageState(
          questionId: _questionPages.length,
          selectedSubject: _selectedSubject!,
          questionModel: QuestionModel(
              subject: _selectedSubject!,
            defaultQuestionInfo: DefaultQuestionInfoModel(),
            answerOptionInfoList: [],
          ),
          selectedQuestionType: null,
        ));
      }
    });
  }

  void _removeQuestionPage(int id) {
    setState(() {
      _questionPages.removeWhere((page) => page.questionId == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the left
            children: [
              // Dropdown for subject selection
              DropdownButton<String>(
                value: _selectedSubject,
                hint: const Text("과목 선택"),
                items: _questionTypes.keys
                    .map((subject) => DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                    _questionPages.clear(); // Clear existing question pages
                  });
                },
              ),
              const SizedBox(height: 16),

              // Render each question page dynamically
              if (_selectedSubject != null)
                ..._questionPages.map(
                      (pageState) => QuestionPage(
                        key: ValueKey(pageState),
                        pageState: pageState,
                        questionTypes: _questionTypes[_selectedSubject!]!,
                        onDelete: _removeQuestionPage,
                  ),
                ),

              // "문제 추가" Button
              if (_selectedSubject != null)
                Align(
                  alignment: Alignment.centerLeft, // Moves the button to the left
                  child:
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent, // Red color to indicate a delete action
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    onPressed: _addQuestionPage,
                    child: const Text("+ 문제 추가"),
                  ),

                ),

              const SizedBox(height: 16),

              // Save button displayed only at the bottom
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) {
                          return _buildSaveConfirmationDialog(context, setState);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("저장하기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveConfirmationDialog(
      BuildContext context, void Function(void Function()) setState) {
    bool isSaving = false;
    bool isSuccess = false;

    List<QuestionModel> notValidQuestionModelList = [];
    for (var element in _questionPages) {
      if (!element.questionModel.isValid()) {
        notValidQuestionModelList.add(element.questionModel);
      }
    }

    // 문제 데이터가 정확히 입력되지 않은 경우
    if (notValidQuestionModelList.isNotEmpty || _questionPages.isEmpty) {
      return CupertinoAlertDialog(
        title: Text("문제 데이터 검증 필요"),
        content: Column(
          children: const [
            Text("문제 데이터를 모두 입력했는지 다시 확인해주세요."),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("확인"),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
          ),
        ],
      );
    }

    // 문제 데이터가 정확히 입력된 경우 서버에 전달 후 결과 받기
    // 중복되는 문제 있으면 어떻게 할건지 물어보기
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
            child: Text("취소"),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
          ),
        if (!isSaving && !isSuccess)
          CupertinoDialogAction(
            child: Text("저장하기"),
            isDestructiveAction: false,
            onPressed: () async {
              // Indicate that saving is in progress
              setState(() {
                isSaving = true;
              });
              List<int?> responseCodes = await getQuestionSaveResult(_questionPages, false);
              setState(() {
                isSaving = false;
                isSuccess = responseCodes.every((code) => code == 200); // Check if all requests succeeded
              });
              Navigator.pop(context);
              Future.microtask(() {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return _buildSecondSaveConfirmationDialog(
                      context,
                      _questionPages,
                      responseCodes,
                      setState,
                    );
                  },
                );
              });
            },
          ),
      ],
    );
  }

  Widget _buildSecondSaveConfirmationDialog(
      BuildContext context,
      List<QuestionPageState> questionPages,
      List<int?> responseCodes,
      void Function(void Function()) setState,
      ) {
    bool isSaving = false;
    bool isSuccess = responseCodes.every((code) => code == 200);

    if (isSuccess) {
      // resetQuestionPages([]);

      return CupertinoAlertDialog(
        content: Text("저장되었습니다."),
        actions: [
          CupertinoDialogAction(
            child: Text("확인"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    } else {

      List<int> successIndexList = responseCodes
          .asMap()
          .entries
          .where((entry) => entry.value == 200)
          .map((entry) => entry.key)
          .toList();

      // resetQuestionPages(successIndexList);

      List<int> replaceCandidateIndexList = responseCodes
          .asMap()
          .entries
          .where((entry) => entry.value == 203)
          .map((entry) => entry.key)
          .toList();

      List<QuestionPageState> replaceCandidatesList = replaceCandidateIndexList
          .map((index) => questionPages[index])
          .toList();

      Map<int, String> userSelections = {
        for (var index in replaceCandidateIndexList) index: "덮어쓰기",
      };

      return StatefulBuilder(
        builder: (context, localSetState) {
          return CupertinoAlertDialog(
            title: Text("중복된 문제 처리"),
            content: Column(
              children: [
                Text("다음 문제들이 중복되었습니다. 처리 방법을 선택해주세요:"),
                SizedBox(height: 16),
                ...replaceCandidatesList.map((page) {
                  int questionId = page.questionId;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "문제 ID: $questionId",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      CupertinoSegmentedControl<String>(
                        groupValue: userSelections[questionId],
                        children: const {
                          "덮어쓰기": Text("덮어쓰기"),
                          "기존 문제 유지": Text("기존 문제 유지"),
                        },
                        onValueChanged: (value) {
                          localSetState(() {
                            userSelections[questionId] = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: isSaving ? CupertinoActivityIndicator() : Text("저장"),
                onPressed: () async {
                  localSetState(() {
                    isSaving = true;
                  });

                  // Filter for "덮어쓰기" selection
                  List<QuestionPageState> replaceSelectedList = replaceCandidatesList
                      .where((page) {
                    int questionId = page.questionId;
                    return userSelections[questionId] == "덮어쓰기";
                  })
                      .toList();

                  if (replaceSelectedList.isEmpty) {
                    // All questions are marked as "기존 문제 유지"
                    localSetState(() {
                      isSaving = false;
                    });

                    Navigator.pop(context); // Close the current dialog

                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          content: Text("중복을 제외한 모든 문제가 저장되었습니다."),
                          actions: [
                            CupertinoDialogAction(
                              child: Text("확인"),
                              onPressed: () {
                                Navigator.pop(context); // Close the result dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                    // resetQuestionPages([]);
                    return;
                  }

                  // Send the replace requests for selected questions
                  List<int?> replaceRequestResponseList =
                  await getQuestionSaveResult(replaceSelectedList, true);

                  localSetState(() {
                    isSaving = false;
                  });

                  Navigator.pop(context); // Close the current dialog

                  // Show the result dialog based on the replace result
                  bool replaceSuccess =
                  replaceRequestResponseList.every((code) => code == 200);

                  List<int> successIndexList = replaceRequestResponseList
                      .asMap()
                      .entries
                      .where((entry) => entry.value == 200)
                      .map((entry) => entry.key)
                      .toList();

                  // resetQuestionPages(successIndexList);

                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        content: Text(
                          replaceSuccess
                              ? "덮어쓰기에 성공했습니다."
                              : "덮어쓰기에 실패했습니다. 다시 시도해주세요.",
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("확인"),
                            onPressed: () {
                              Navigator.pop(context); // Close the result dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }
}