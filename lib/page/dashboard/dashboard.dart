import 'package:flutter/cupertino.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoardState();

}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Dashboard to be updated"),);
  }

}