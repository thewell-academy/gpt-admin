import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/export/naesin_question_exporter.dart';

import 'suneung_question_exporter.dart';

class ExportQuestionPage extends StatefulWidget {
  const ExportQuestionPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExportQuestionPage();
}

class _ExportQuestionPage extends State<ExportQuestionPage> {

  List<String> options = ["수능/모의고사", "내신"];
  String? selectedOption;

  @override
  Widget build(BuildContext context) {

    Widget getWidgetForOption(String? selectedOption) {
      if (selectedOption == options[0]) {
        return const SuneungQuestionExporter();
      } else if (selectedOption == options[1]) {
        return const NaesinQuestionExporter();
      }
      else {
        return Container(); // Default empty widget
      }
    }

    return Center(
      child: SizedBox(
        width: 1300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 150,
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Makes buttons fill the width
                children: options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0), // Adds vertical margin between buttons
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = option;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50), // Sets the button's width and height
                        padding: EdgeInsets.zero, // Removes internal padding
                      ),
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Add this Expanded widget to display the selected widget on the right
            Expanded(
              child: getWidgetForOption(selectedOption),
            ),
          ],
        ),
      ),
    );

  }

}