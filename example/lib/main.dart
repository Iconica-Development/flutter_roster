import 'package:flutter/material.dart';
import 'package:flutter_roster/flutter_roster.dart';

void main() {
  runApp(const MaterialApp(home: RosterDemo()));
}

class RosterDemo extends StatelessWidget {
  const RosterDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RosterWidget(
          header: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Row(
              children: [
                Text(
                  'Team Rooster',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                Text(
                  'Persoonlijk Rooster',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          blockWidth: 50,
          highlightToday: false,
          blocks: [
            RosterEvent(
              start: DateTime.now().subtract(const Duration(hours: 3)),
              end: DateTime.now().add(const Duration(hours: 2)),
            ),
            RosterEvent(
              start: DateTime.now().subtract(const Duration(hours: 2)),
              end: DateTime.now().add(const Duration(hours: 3)),
            ),
            RosterEvent(
              start: DateTime.now().subtract(const Duration(hours: 1)),
              end: DateTime.now().add(const Duration(hours: 4)),
            ),
            RosterEvent(
              start: DateTime.now().add(const Duration(hours: 3)),
              end: DateTime.now().add(const Duration(hours: 4)),
              id: 4,
              content: const Text('event 4'),
            ),
            RosterEvent(
              start: DateTime.now().add(const Duration(hours: 3)),
              end: DateTime.now().add(const Duration(hours: 4)),
              id: 4,
              content: const Text('event 5'),
            ),
            RosterEvent(
              start: DateTime.now().add(const Duration(hours: 3)),
              end: DateTime.now().add(const Duration(hours: 4)),
              id: 4,
              content: const Text('event 6'),
            ),
            RosterEvent(
              start: DateTime.now().add(const Duration(days: 1)),
              end: DateTime.now()
                  .add(const Duration(days: 1))
                  .add(const Duration(hours: 2)),
            ),
            RosterEvent(
              start: DateTime.now().subtract(const Duration(hours: 2)),
              end: DateTime.now().add(const Duration(hours: 1)),
            ),
            RosterEvent(
              start: DateTime.now().add(const Duration(days: 2)),
              end: DateTime.now().add(const Duration(days: 3)),
            ),
          ],
          disabledDates: [
            // yesterday
            DateTime.now().subtract(const Duration(days: 1)),
          ],
          highlightedDates: [
            // tomorrow
            DateTime.now().add(const Duration(days: 1)),
          ],
          theme: const RosterTheme(
            tableTheme: TableTheme(
              blockPaddingBetween: 10,
            ),
          ),
        ),
      ),
    );
  }
}
