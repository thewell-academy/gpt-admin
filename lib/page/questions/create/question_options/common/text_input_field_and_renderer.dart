import 'package:flutter/material.dart';
import 'package:thewell_gpt_admin/page/questions/create/util/rich_text_field.dart';

import '../../question_model/question_model.dart';



class TextInputFieldAndRenderer extends StatefulWidget {
  final QuestionModel questionModel;
  final String title;
  final Function(String) onUpdate;
  final double height;

  const TextInputFieldAndRenderer({
    super.key,
    required this.questionModel,
    required this.title,
    required this.onUpdate,
    required this.height
  });

  @override
  State<StatefulWidget> createState() => _TextInputFieldAndRendererState();
}

class _TextInputFieldAndRendererState extends State<TextInputFieldAndRenderer> {
  String deltaText = '';

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
                child: SizedBox(
                  height: widget.height,
                  child: RichTextField(
                      alignHorizontal: true,
                      height: widget.height,
                      onContentChanged: (String updatedRichText) {
                        setState(() {
                          deltaText = updatedRichText;
                        });
                        widget.onUpdate(deltaText);
                      }
                  ),
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