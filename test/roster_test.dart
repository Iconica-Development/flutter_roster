import 'package:flutter/material.dart';
import 'package:flutter_roster/flutter_roster.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('header is shown', (tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RosterWidget(
            header: Text('Roster'),
            blocks: [],
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Roster'), findsOneWidget);
  });

  testWidgets('blocks are shown', (tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RosterWidget(
            blocks: [
              RosterEvent(
                start: DateTime.now().subtract(const Duration(days: 3)),
                end: DateTime.now().subtract(const Duration(days: 2)),
                content: const Text('not shown'),
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
            ],
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('event 4'), findsOneWidget);
    expect(find.text('event 5'), findsOneWidget);
    expect(find.text('not shown'), findsNothing);
  });

  testWidgets('event is removed on tap', (tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RosterWidget(
            initialDate: DateTime.now(),
            blocks: [
              RosterEvent(
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(days: 1)),
                content: const Text('single day event'),
              ),
            ],
          ),
        ),
      ),
    );
    var firstDay = find.text('single day event');
    expect(firstDay, findsOneWidget);

    var nextDay = DateTime.now().add(const Duration(days: 2));
    // if nextDay is monday or tuesday we need to go back 4 days
    if (nextDay.weekday == DateTime.tuesday ||
        nextDay.weekday == DateTime.monday) {
      nextDay = nextDay.subtract(const Duration(days: 4));
    }
    await tester.tap(find.text(nextDay.day.toString()));
    await tester.pump();
    expect(find.text('single day event'), findsNothing);
  });
}
