// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_roster/src/models/roster_event.dart';
import 'package:flutter_roster/src/models/roster_theme.dart';
import 'package:timetable/timetable.dart';

class RosterWidget extends StatefulWidget {
  /// [RosterWidget] is a widget that displays a timetable with events.
  /// It is stateful and sorts the events based on the selected date.
  /// All styling can be configured through the [RosterTheme] class.
  const RosterWidget({
    required this.blocks,
    this.tableDirection = Axis.vertical,
    this.highlightedDates = const [],
    this.disabledDates = const [],
    this.initialDate,
    this.header,
    this.scrollController,
    this.scrollPhysics,
    this.onTapDay,
    this.startHour = 0,
    this.endHour = 24,
    this.hourDimension = 80,
    this.highlightToday = true,
    this.blockWidth = 50,
    this.blockColor = const Color(0x80FF0000),
    this.theme = const RosterTheme(),
    super.key,
  });

  /// The [Axis] along which the timetable markings are lined out
  final Axis tableDirection;

  /// Header widget that is displayed above the datepicker
  final Widget? header;

  /// The blocks that are displayed in the roster
  final List<RosterEvent> blocks;

  /// The highlighted dates that are displayed in the roster
  final List<DateTime> highlightedDates;

  /// The disabled dates that are displayed in the roster
  final List<DateTime> disabledDates;

  /// The date that is initially selected.
  final DateTime? initialDate;

  /// Function called when the user taps on a day in the datepicker.
  final Function(DateTime)? onTapDay;

  /// Whether to highlight the current date in the roster.
  final bool highlightToday;

  /// Hour at which the timetable starts.
  final int startHour;

  /// Hour at which the timetable ends.
  final int endHour;

  /// The dimension in pixels of one hour in the timetable.
  final double hourDimension;

  /// The width of the rosterItem if there is no child
  final double blockWidth;

  /// The color of the rosterItem if there is no child
  final Color blockColor;

  /// The theme used by the roster.
  /// The [TableTheme] used by the timetable is included.
  final RosterTheme theme;

  /// The scroll controller to control the scrolling of the timetable.
  final ScrollController? scrollController;

  /// The scroll physics used for the SinglechildScrollView.
  final ScrollPhysics? scrollPhysics;

  @override
  State<RosterWidget> createState() => _RosterWidgetState();
}

class _RosterWidgetState extends State<RosterWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    var events = _filterEventsOnDay(widget.blocks, _selectedDate);
    return DateTimePicker(
      initialDate: _selectedDate,
      pickTime: false,
      highlightToday: widget.highlightToday,
      header: widget.header,
      onTapDay: (selected) {
        if (widget.onTapDay != null) {
          widget.onTapDay!(selected);
        }

        setState(() {
          _selectedDate = selected;
        });
      },
      disabledDates: widget.disabledDates,
      markedDates: widget.highlightedDates,
      dateTimePickerTheme: widget.theme.timePickerTheme,
      child: Timetable(
        tableDirection: widget.tableDirection,
        scrollPhysics: widget.scrollPhysics,
        scrollController: widget.scrollController,
        blockColor: widget.blockColor,
        blockWidth: widget.blockWidth,
        hourDimension: widget.hourDimension,
        startHour: widget.startHour,
        endHour: widget.endHour,
        timeBlocks: events,
        theme: widget.theme.tableTheme,
        combineBlocks: true,
        mergeBlocks: false,
      ),
    );
  }

  List<TimeBlock> _filterEventsOnDay(List<RosterEvent> events, DateTime day) {
    return events
        .where(
          (e) =>
              (e.start.day == day.day &&
                  e.start.month == day.month &&
                  e.start.year == day.year) ||
              (e.end.day == day.day &&
                  e.end.month == day.month &&
                  e.end.year == day.year),
        )
        .map(
          (e) => TimeBlock(
            start: (e.start.day != day.day)
                ? TimeOfDay(hour: widget.startHour, minute: 0)
                : TimeOfDay(
                    hour: e.start.hour,
                    minute: e.start.minute,
                  ),
            end: (e.end.day != day.day)
                ? TimeOfDay(hour: widget.endHour, minute: 0)
                : TimeOfDay(
                    hour: e.end.hour,
                    minute: e.end.minute,
                  ),
            id: e.id ?? 0,
            childDimension: e.childDimension,
            child: e.content,
          ),
        )
        .toList();
  }
}
