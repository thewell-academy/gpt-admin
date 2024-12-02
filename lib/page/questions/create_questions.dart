import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/export/naesin_question_exporter.dart';

import 'export/suneung_question_exporter.dart';

class CreateQuestionPdfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateQuestionPdfPage();
}

class _CreateQuestionPdfPage extends State<CreateQuestionPdfPage> {

  List<String> options = ["수능/모의고사", "내신"];
  String? selectedOption;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    Widget _getWidgetForOption(String? selectedOption) {
      if (selectedOption == options[0]) {
        return SuneungQuestionExporter();
      } else if (selectedOption == options[1]) {
        return NaesinQuestionExporter();
      }
      else {
        return Container(); // Default empty widget
      }
    }

    return Center(
      child: Container(
        width: 1300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 150,
              padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Makes buttons fill the width
                children: options.map((option) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0), // Adds vertical margin between buttons
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedOption = option;
                        });
                      },
                      child: Text(option),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Sets the button's width and height
                        padding: EdgeInsets.zero, // Removes internal padding
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Add this Expanded widget to display the selected widget on the right
            Expanded(
              child: _getWidgetForOption(selectedOption),
            ),
          ],
        ),
      ),
    ) ;

  }

}