import 'package:flutter/material.dart';

class RosterEvent {
  /// The model used for a single event in the [RosterWidget].
  /// RosterEvent can be multiple days long.
  RosterEvent({
    required this.start,
    required this.end,
    this.id,
    this.content,
  }) : assert(start.isBefore(end), 'start must be before end');

  /// The start  time of the event.
  final DateTime start;

  /// The end time of the event.
  final DateTime end;

  /// The [Widget] displayed inside the roster at the event time
  final Widget? content;

  /// The identifier of the event that is used to combine events
  /// with the same id. Leave empty or 0 if you don't want to combine events.
  final int? id;
}
