import 'package:flutter/material.dart';

class ExportOptionSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExportOptionSelectorState();
}

class _ExportOptionSelectorState extends State<ExportOptionSelector> {
  String? _selectedSubject;
  String? _selectedExamType;
  Map<String, dynamic>? subjectDetails;
  List<Map<String, dynamic>> dynamicSelections = [];
  bool isLoading = false;

  final List<int> years = List.generate(11, (index) => 2015 + index).reversed.toList();
  final Set<int> selectedYears = {};
  final List<String> months = List.generate(12, (index) => "${index + 1}월");
  final Set<String> selectedMonths = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subject and Exam Type Selection
        Row(
          children: [
            Flexible(
              flex: 2,
              child: DropdownButton<String>(
                value: _selectedSubject,
                hint: Text("Select Subject"),
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

                  final details = await _fetchSubjectDetails(subject!);

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
                  hint: Text("Select Exam Type"),
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
              SizedBox(width: 10),
              CircularProgressIndicator(),
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
                child: _buildMultiSelectDropdown<int>(
                  title: "연도",
                  items: ["전체 선택", ...years],
                  selectedItems: selectedYears,
                  onSelectionChanged: () => setState(() {}),
                  displaySelected: selectedYears.isEmpty
                      ? "연도 선택"
                      : selectedYears.join(", "),
                ),
              ),
              const SizedBox(width: 16),
              if (_selectedExamType == "모의고사")
                Flexible(
                  flex: 2,
                  child: _buildMultiSelectDropdown<String>(
                    title: "월",
                    items: ["전체 선택", ...months],
                    selectedItems: selectedMonths,
                    onSelectionChanged: () => setState(() {}),
                    displaySelected: selectedMonths.isEmpty
                        ? "월 선택"
                        : selectedMonths.join(", "),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 20),

        // Dynamic Selection for Subject Details
        if (subjectDetails != null && _selectedExamType != null)
          _buildDynamicSelection(subjectDetails!),

        // 문제 출력하기 Button
        const SizedBox(height: 20),
        if (_selectedSubject != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add the action for the button
              },
              child: const Text("문제 출력하기"),
            ),
          ),
      ],
    );
  }

  Widget _buildMultiSelectDropdown<T>({
    required String title,
    required List<dynamic> items,
    required Set<T> selectedItems,
    required VoidCallback onSelectionChanged,
    required String displaySelected,
  }) {
    return StatefulBuilder(
      builder: (context, setStateDropdown) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            isExpanded: true,
            hint: Text(displaySelected),
            items: items.map((item) {
              final isSelectAll = item == "전체 선택";
              return DropdownMenuItem<dynamic>(
                value: item,
                child: Row(
                  children: [
                    StatefulBuilder(
                      builder: (context, setStateCheckbox) {
                        return Checkbox(
                          value: isSelectAll
                              ? selectedItems.length == items.length - 1
                              : selectedItems.contains(item),
                          onChanged: (isChecked) {
                            setState(() {
                              if (isSelectAll) {
                                if (selectedItems.length == items.length - 1) {
                                  selectedItems.clear();
                                } else {
                                  selectedItems.addAll(items.where((i) => i != "전체 선택").cast<T>());
                                }
                              } else {
                                if (isChecked == true) {
                                  selectedItems.add(item as T);
                                } else {
                                  selectedItems.remove(item);
                                }
                              }
                            });
                            setStateDropdown(() {}); // Update dropdown state
                            setStateCheckbox(() {}); // Update checkbox state
                            onSelectionChanged();
                          },
                        );
                      },
                    ),
                    Flexible(
                      child: Text(item.toString()),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        );
      },
    );
  }

  Widget _buildDynamicSelection(Map<String, dynamic> data) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(dynamicSelections.length + 1, (level) {
        Map<String, dynamic>? currentLevel = data;

        for (int i = 0; i < level && i < dynamicSelections.length; i++) {
          final selectedKeys = dynamicSelections[i]["selected"] as Set<String>;
          if (currentLevel != null) {
            currentLevel = selectedKeys.fold<Map<String, dynamic>>({}, (acc, key) {
              if (currentLevel![key] is Map<String, dynamic>) {
                acc.addAll(currentLevel[key]);
              }
              return acc;
            });
          }
        }

        final options = currentLevel != null
            ? ["전체 선택", ...currentLevel.keys.toList()]
            : [];
        if (options.length == 1 && options.contains("전체 선택")) return const SizedBox.shrink();

        final selectedItems = level < dynamicSelections.length
            ? dynamicSelections[level]["selected"] as Set<String>
            : <String>{};

        final displaySelected = selectedItems.isEmpty
            ? "Level ${level + 1} 선택"
            : selectedItems.join(", ");

        return StatefulBuilder(
          builder: (context, setStateDropdown) {
            return DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                isExpanded: true,
                hint: Text(displaySelected),
                items: options.map((item) {
                  final isSelectAll = item == "전체 선택";
                  return DropdownMenuItem<dynamic>(
                    value: item,
                    child: StatefulBuilder(
                      builder: (context, setStateCheckbox) {
                        return Row(
                          children: [
                            Checkbox(
                              value: isSelectAll
                                  ? selectedItems.length == options.length - 1
                                  : selectedItems.contains(item),
                              onChanged: (isChecked) {
                                setState(() {
                                  if (isSelectAll) {
                                    if (selectedItems.length == options.length - 1) {
                                      selectedItems.clear();
                                    } else {
                                      selectedItems.addAll(options.where((i) => i != "전체 선택").cast<String>());
                                    }
                                  } else {
                                    if (isChecked == true) {
                                      selectedItems.add(item);
                                    } else {
                                      selectedItems.remove(item);
                                    }
                                  }
                                });
                                setStateDropdown(() {});
                                setStateCheckbox(() {});
                                _updateDynamicSelections(level, options, selectedItems);
                              },
                            ),
                            Flexible(
                              child: Text(item.toString()),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            );
          },
        );
      }),
    );
  }

  void _updateDynamicSelections(int level, List<dynamic> options, Set<String> selectedItems) {
    setState(() {
      if (level < dynamicSelections.length) {
        dynamicSelections[level]["selected"] = selectedItems;
        dynamicSelections = dynamicSelections.sublist(0, level + 1);
      } else {
        dynamicSelections.add({
          "options": options,
          "selected": selectedItems,
        });
      }
    });
  }

  Future<Map<String, dynamic>> _fetchSubjectDetails(String subject) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return {
      "1학년": {
        "고등수학(상)": {
          "다항식": [],
          "방정식과 부등식": [],
          "도형의 방정식": []
        },
        "고등수학(하)": {
          "집합과 명제": [],
          "함수와 그래프": [],
          "경우의 수": []
        }
      },
      "2학년": {
        "수학1": {
          "지수함수와 로그함수": [],
          "삼각함수": [],
          "수열": []
        },
        "수학2": {
          "함수의 극한과 연속": [],
          "미분": [],
          "적분": []
        }
      }
    };
  }
}