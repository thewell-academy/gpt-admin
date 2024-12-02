import 'package:flutter/cupertino.dart';

class SuneungQuestionExporter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SuneungQuestionExporterState();
}

class SuneungQuestionExporterState extends State<SuneungQuestionExporter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "수능/모의고사 기출문제 PDF 만들기",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
        ]
      )
    );
  }

}