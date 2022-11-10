// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class RosterEvent {
  /// The model used for a single event in the [RosterWidget].
  /// RosterEvent can be multiple days long.
  RosterEvent({
    required this.start,
    required this.end,
    this.id,
    this.content,
    this.childDimension,
  }) : assert(start.isBefore(end), 'start must be before end');

  /// The start  time of the event.
  final DateTime start;

  /// The end time of the event.
  final DateTime end;

  /// The [Widget] displayed inside the roster at the event time
  final Widget? content;

  /// The dimension of the child in the axis of the timetable which it expands.
  /// Only needed when child is not null and the horizontalvariant is used.
  /// This is used to make the timetable background as large as all the blocks.
  final double? childDimension;

  /// The identifier of the event that is used to combine events
  /// with the same id. Leave empty or 0 if you don't want to combine events.
  final int? id;
}
