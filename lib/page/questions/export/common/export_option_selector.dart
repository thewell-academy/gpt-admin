import 'package:flutter/material.dart';

import '../../../../util/util.dart';

class ExportQuestionOptionSelector extends StatefulWidget {
  const ExportQuestionOptionSelector({super.key});

  @override
  State<StatefulWidget> createState() => _ExportQuestionOptionSelectorState();
}

class _ExportQuestionOptionSelectorState extends State<ExportQuestionOptionSelector> {
  String? _selectedSubject;
  String? _selectedExamType;
  Map<String, dynamic>? subjectDetails;
  List<Map<String, dynamic>> dynamicSelections = [];
  bool isLoading = false;

  final List<int> years = List
      .generate(11, (index) => 2015 + index)
      .reversed
      .toList();
  final Set<int> selectedYears = {};
  final List<String> months = List.generate(12, (index) => "${index + 1}월");
  final Set<String> selectedMonths = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: DropdownButton<String>(
                value: _selectedSubject,
                hint: const Text("과목 선택하기"),
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

        if (subjectDetails != null && _selectedExamType != null)
          _buildDynamicSelection(subjectDetails!),

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
                                  selectedItems.addAll(
                                      items.where((i) => i != "전체 선택").cast<
                                          T>());
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
            currentLevel =
                selectedKeys.fold<Map<String, dynamic>>({}, (acc, key) {
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
        if (options.length == 1 && options.contains("전체 선택"))
          return const SizedBox.shrink();

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
                                    if (selectedItems.length ==
                                        options.length - 1) {
                                      selectedItems.clear();
                                    } else {
                                      selectedItems.addAll(
                                          options.where((i) => i != "전체 선택")
                                              .cast<
                                              String>());
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
                                _updateDynamicSelections(
                                    level, options, selectedItems);
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

  void _updateDynamicSelections(int level, List<dynamic> options,
      Set<String> selectedItems) {
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
}