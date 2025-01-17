import 'package:flutter/cupertino.dart';
import 'package:thewell_gpt_admin/page/questions/create/util/create_question_option_selector.dart';

class SuneungQuestionCreator extends StatefulWidget {
  const SuneungQuestionCreator({super.key});

  @override
  State<StatefulWidget> createState() => _SuneungQuestionCreatorState();

}

class _SuneungQuestionCreatorState extends State<SuneungQuestionCreator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 50),
      width: double.infinity, // Full width
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "수능/모의고사 기출문제 만들기",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: CreateQuestionOptionSelector(),
          ),
        ],
      ),
    );
  }

}