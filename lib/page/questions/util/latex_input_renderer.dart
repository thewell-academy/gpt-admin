import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import '../question_model/question_model.dart';

class MarkdownInputAndRender extends StatefulWidget {
  final QuestionModel questionModel;
  final String title;
  // util/question_data_handler.dart -> updateHTMLRenderedText()
  final Function(QuestionModel, String, String) onUpdate;

  MarkdownInputAndRender({
    Key? key,
    required this.questionModel,
    required this.title,
    required this.onUpdate
  });

  @override
  State<StatefulWidget> createState() => _MarkdownInputAndRenderState();
}

class _MarkdownInputAndRenderState extends State<MarkdownInputAndRender> {
  String questionText = ''; // Holds the input text for Markdown/HTML code

  void _updateParent() {
    widget.onUpdate(
      widget.questionModel,
      widget.title,
      questionText
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
          ),
          Row(
            children: [
              // Left side: TextField for Markdown/HTML input
              Expanded(
                flex: 1, // Give equal space to both widgets
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "HTML 입력하기",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 7,),
                        TextButton(
                            onPressed: () {
                              showHtmlDialog(context);
                            },
                            child: Text(
                              "HTML 사용 방법 보기",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                              ),
                            )
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          questionText = value;
                        });
                        _updateParent();
                      },
                      maxLines: 10, // Allow multi-line input
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), // Add a border around the text field
                        hintText: "HTML 입력하기",
                        contentPadding: EdgeInsets.all(16), // Add padding inside the text field
                      ),
                      style: const TextStyle(
                        fontSize: 14, // Adjust font size for readability
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16), // Space between the two widgets

              // Right side: Rendered HTML output
              Expanded(
                flex: 1, // Give equal space to both widgets
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "실제로 보이는 지문",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: questionText.isEmpty
                          ? const Text(
                        "HTML 변환된 지문",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      )
                          : Html(
                        data: questionText, // Render HTML content
                        style: {
                          "body": Style(
                            fontSize: FontSize.large, // Adjust font size for readability
                            fontFamily: "TimesTen",
                            fontStyle: FontStyle.normal
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      )
    );
  }
}

Future<void> showHtmlDialog(BuildContext context) async {
  // Load the HTML file content
  String htmlContent = await rootBundle.loadString("assets/html_tutorial.html");

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final double dialogWidth = MediaQuery.of(context).size.width * 0.5;
      final double dialogHeight = MediaQuery.of(context).size.height * 0.8;

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Optional: Add rounded corners
        ),
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title of the dialog
              const Text(
                "HTML 사용 가이드",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16), // Add spacing below the title

              // Render the HTML content
              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: htmlContent, // Render the HTML content loaded from the file
                    style: {
                      "body": Style(
                        fontSize: FontSize.large, // Adjust font size for readability
                      ),
                    },
                  ),
                ),
              ),

              // Close button at the bottom
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("닫기"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}