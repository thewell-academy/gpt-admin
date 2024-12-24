import 'package:flutter/cupertino.dart';

import 'common/export_option_selector.dart';

class SuneungQuestionExporter extends StatefulWidget {
  const SuneungQuestionExporter({super.key});

  @override
  State<StatefulWidget> createState() => SuneungQuestionExporterState();
}

class SuneungQuestionExporterState extends State<SuneungQuestionExporter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 50),
      width: double.infinity, // Full width
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "수능/모의고사 기출문제 만들기",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ExportOptionSelector(),
          ),
        ],
      ),
    );
  }

}