import 'package:flutter/material.dart';

class ExportOptionSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExportOptionSelectorState();
}

class _ExportOptionSelectorState extends State<ExportOptionSelector> {
  String _selectedExam = "수능"; // Initialize with a default value
  final List<int> years = List.generate(11, (index) => 2015 + index); // Generate years from 2015 to 2025
  final Set<int> selectedYears = {}; // Store selected years
  final List<String> months = List.generate(12, (index) => "${index + 1}월"); // Generate months as strings
  final Set<String> selectedMonths = {}; // Store selected months

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: DropdownButton<String>(
                value: _selectedExam,
                items: ["수능", "모의고사"]
                    .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedExam = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 2, // Adjust flex to control widths
              child: _buildMultiSelectDropdown<int>(
                title: "연도",
                items: ["Select All", ...years],
                selectedItems: selectedYears,
                onSelectionChanged: () => setState(() {}),
                displaySelected: selectedYears.isEmpty
                    ? "연도 선택"
                    : selectedYears.join(", "),
              ),
            ),
            const SizedBox(width: 16),
            if (_selectedExam == "모의고사")
              Flexible(
                flex: 2, // Adjust flex to control widths
                child: _buildMultiSelectDropdown<String>(
                  title: "월",
                  items: ["Select All", ...months],
                  selectedItems: selectedMonths,
                  onSelectionChanged: () => setState(() {}),
                  displaySelected: selectedMonths.isEmpty
                      ? "월 선택"
                      : selectedMonths.join(", "),
                ),
              ),
          ],
        )
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
    return DropdownButtonHideUnderline(
      child: DropdownButton<dynamic>(
        isExpanded: true, // Ensure dropdown expands to fit text
        hint: Text(
          displaySelected,
          overflow: TextOverflow.ellipsis, // Handle text overflow gracefully
        ),
        items: items.map((item) {
          return DropdownMenuItem<dynamic>(
            value: item,
            child: StatefulBuilder(
              builder: (context, setState) {
                final isSelectAll = item == "Select All";
                return Row(
                  children: [
                    Checkbox(
                      value: isSelectAll
                          ? selectedItems.length == items.length - 1 // All items selected
                          : selectedItems.contains(item),
                      onChanged: (isChecked) {
                        setState(() {
                          if (isSelectAll) {
                            // Toggle Select All
                            if (selectedItems.length == items.length - 1) {
                              selectedItems.clear(); // Deselect all
                            } else {
                              selectedItems.addAll(
                                  items.where((i) => i != "Select All").cast<T>()); // Select all
                            }
                          } else {
                            // Toggle individual item
                            if (isChecked == true) {
                              selectedItems.add(item as T);
                            } else {
                              selectedItems.remove(item);
                            }
                          }
                        });
                        onSelectionChanged(); // Notify parent to update text
                      },
                    ),
                    Flexible(
                      child: Text(
                        _formatText(item.toString(), 24), // Break text into 24-character lines
                        style: const TextStyle(fontSize: 14),
                        maxLines: null, // Allow multiple lines
                        softWrap: true, // Enable text wrapping
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }).toList(),
        onChanged: (_) {}, // Required but not used
      ),
    );
  }

  /// Helper function to split text into lines of [maxChars] characters
  String _formatText(String text, int maxChars) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i += maxChars) {
      if (i + maxChars < text.length) {
        buffer.write('${text.substring(i, i + maxChars)}\n');
      } else {
        buffer.write(text.substring(i));
      }
    }
    return buffer.toString();
  }
}