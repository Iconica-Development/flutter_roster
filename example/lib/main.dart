import 'package:flutter/material.dart';
import 'package:roster/roster.dart';

void main() {
  runApp(const MaterialApp(home: RosterDemo()));
}

class RosterDemo extends StatelessWidget {
  const RosterDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RosterWidget(
        blocks: [],
      ),
    );
  }
}
