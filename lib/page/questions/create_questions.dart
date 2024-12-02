import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateQuestionPdfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateQuestionPdfPage();
}

class _CreateQuestionPdfPage extends State<CreateQuestionPdfPage> {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

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
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: Text("수능/모의고사"),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero), // Removes internal padding
                      minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)), // Adjusts the button size
                    ),
                  ),
                ],
              )
            ),
            Container(
              width: 500,
              margin: EdgeInsets.all(10),
              child: Text("Right"),
              color: Color.fromARGB(50, 50, 50, 50),
            )
          ],
        ),
      ),
    ) ;

  }

}