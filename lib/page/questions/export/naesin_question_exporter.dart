import 'package:flutter/cupertino.dart';

class NaesinQuestionExporter extends StatefulWidget {
  const NaesinQuestionExporter({super.key});

  @override
  State<StatefulWidget> createState() => NaesinQuestionExporterState();
}

class NaesinQuestionExporterState extends State<NaesinQuestionExporter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 50),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
                "내신 기출문제 만들기",
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