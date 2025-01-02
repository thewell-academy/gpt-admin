import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import '../question_model/question_model.dart';



class MarkdownInputAndRender extends StatefulWidget {
  final QuestionModel questionModel;
  final String title;
  final Function(QuestionModel, String, String) onUpdate;

  const MarkdownInputAndRender({
    super.key,
    required this.questionModel,
    required this.title,
    required this.onUpdate
  });

  @override
  State<StatefulWidget> createState() => _MarkdownInputAndRenderState();
}

class _MarkdownInputAndRenderState extends State<MarkdownInputAndRender> {
  String questionText = '';

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
            style: const TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
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
                        const SizedBox(width: 7,),
                        TextButton(
                            onPressed: () {
                              showHtmlGuideDialog(context);
                            },
                            child: const Text(
                              "HTML 사용 방법",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                              ),
                            )
                        ),
                        const SizedBox(width: 7,),
                        TextButton(
                            onPressed: () {
                              showMathGuideDialog(context);
                            },
                            child: const Text(
                              "수학 공식 작성 방법",
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
                      maxLines: 10,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "HTML 입력하기",
                        contentPadding: EdgeInsets.all(16),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                flex: 1,
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
                        data: questionText,
                        style: {
                          "body": Style(
                            fontSize: FontSize.large,
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
          const SizedBox(height: 16),
        ],
      )
    );
  }
}

Future<void> showHtmlGuideDialog(BuildContext context) async {
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "HTML 사용 가이드",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: htmlContent,
                    style: {
                      "body": Style(
                        fontSize: FontSize.large,
                      ),
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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

Future<void> showMathGuideDialog(BuildContext context) async {
  String htmlContent = await rootBundle.loadString("assets/math_tutorial.html");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final double dialogWidth = MediaQuery.of(context).size.width * 0.8;
      final double dialogHeight = MediaQuery.of(context).size.height * 0.9;

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "HTML 수학 공식 작성 가이드",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: htmlContent,
                    style: {
                      "body": Style(
                        fontSize: FontSize.large,
                        padding: const EdgeInsets.all(10),
                      ),
                    },
                    customRender: {
                      "pre": (RenderContext context, Widget child) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          child: SelectableText(
                            context.tree.element?.text ?? "",
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                      "math": (RenderContext context, Widget child) {
                        return SelectableText(
                          context.tree.element?.outerHtml ?? "",
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                          ),
                        );
                      },
                    },
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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