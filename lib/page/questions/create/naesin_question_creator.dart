import 'package:flutter/cupertino.dart';

class NaesinQuestionCreator extends StatefulWidget {
  const NaesinQuestionCreator({super.key});

  @override
  State<StatefulWidget> createState() => _NaesinQuestionCreatorState();

}

class _NaesinQuestionCreatorState extends State<NaesinQuestionCreator> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 50),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "내신 기출문제 추가하기",
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