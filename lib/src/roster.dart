// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_date_time_picker/flutter_date_time_picker.dart';
import 'package:flutter_roster/src/models/roster_event.dart';
import 'package:flutter_roster/src/models/roster_theme.dart';
import 'package:flutter_timetable/timetable.dart';

class RosterWidget extends StatefulWidget {
  /// [RosterWidget] is a widget that displays a timetable with events.
  /// It is stateful and sorts the events based on the selected date.
  /// All styling can be configured through the [RosterTheme] class.
  const RosterWidget({
    required this.blocks,
    this.tableDirection = Axis.vertical,
    this.size,
    this.highlightedDates = const [],
    this.disabledDates = const [],
    this.initialDate,
    this.alwaysUse24HourFormat,
    this.header,
    this.childIfEmptyRoster,
    this.initialScrollTime,
    this.scrollController,
    this.scrollPhysics,
    this.onTapDay,
    this.tableTopPadding = 0,
    this.datePickerExpansion = 0,
    this.hoursOffset = 0,
    this.startHour = 0,
    this.endHour = 24,
    this.hourDimension = 80,
    this.highlightToday = true,
    this.updateEmptyChildPosition = true,
    this.blockDimension = 50,
    this.blockColor = const Color(0x80FF0000),
    this.theme = const RosterTheme(),
    this.enableBorderScroll = false,
    this.scrollTriggerOffset = 120,
    this.scrollJumpToOffset = 115,
    super.key,
  });

  /// The [Axis] along which the timetable markings are lined out
  final Axis tableDirection;

  /// Header widget that is displayed above the datepicker
  final Widget? header;

  /// The Widget displayed instead of the timetable when no events are available
  final Widget? childIfEmptyRoster;

  /// Whether to change the position of the Empty Child Widget
  /// when the datepicker is opened
  final bool updateEmptyChildPosition;

  /// The blocks that are displayed in the roster
  final List<RosterEvent> blocks;

  /// The highlighted dates that are displayed in the roster
  final List<DateTime> highlightedDates;

  /// The disabled dates that are displayed in the roster
  final List<DateTime> disabledDates;

  /// The date that is initially selected.
  final DateTime? initialDate;

  /// Function called when the user taps on a day in the datepicker.
  final Future<void> Function(DateTime)? onTapDay;

  /// Whether to highlight the current date in the roster.
  final bool highlightToday;

  /// Hour at which the timetable starts.
  final int startHour;

  /// Hour at which the timetable ends.
  final int endHour;

  /// The time offset to increase all hour labels with
  /// this is used to make the timetable start at a different time and go past midnight.
  final int hoursOffset;

  /// The amount of pixels above the timetable
  final double tableTopPadding;

  /// The extra height of the datePicker when it is expanded
  final double datePickerExpansion;

  /// [bool] to set the clock on [TimePickerDialog] to a fixed 24 format.
  /// By default this gets determined by the settings on the user device.
  final bool? alwaysUse24HourFormat;

  /// The dimension in pixels of one hour in the timetable.
  final double hourDimension;

  /// The dimension in pixels of the rosterItem if there is no child
  final double blockDimension;

  /// The color of the rosterItem if there is no child
  final Color blockColor;

  /// The theme used by the roster.
  /// The [TableTheme] used by the timetable is included.
  final RosterTheme theme;

  /// The [Size] of the timetable.
  final Size? size;

  /// The initial time to scroll to if there are no rosterevents. If nothing is provided it will scroll to the current time or to the first block if there is one.
  final TimeOfDay? initialScrollTime;

  /// The scroll controller to control the scrolling of the timetable.
  final ScrollController? scrollController;

  /// The scroll physics used for the SinglechildScrollView.
  final ScrollPhysics? scrollPhysics;

  /// Enable the ability to scroll to the next day.
  final bool enableBorderScroll;

  /// The offset which trigger the jump to either the previous or next page. Can't be lower then [scrollJumpToOffset].
  final double scrollTriggerOffset;

  /// When the jump is triggered this offset will be jumped outside of the min or max offset. Can't be higher then [scrollTriggerOffset].
  final double scrollJumpToOffset;

  @override
  State<RosterWidget> createState() => _RosterWidgetState();
}

class _RosterWidgetState extends State<RosterWidget> {
  late DateTime _selectedDate = widget.initialDate ?? DateTime.now();
  double _scrollOffset = 0.0;

  late var timeTableKey = ValueKey(widget.blocks.length);

  late final dateTimePickerController = DateTimePickerController(
    onTapDayCallBack: (selected) async {
      await widget.onTapDay?.call(selected);
      setState(() {
        _selectedDate = selected;
        timeTableKey = ValueKey(widget.blocks.length);
      });
    },
    onBorderScrollCallback: widget.enableBorderScroll
        ? (selected) {
            widget.onTapDay?.call(selected);
            setState(() {
              _selectedDate = selected;
            });
          }
        : null,
    initialDate: widget.initialDate ?? DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    var events = _filterEventsOnDay(widget.blocks, _selectedDate);
    return DragDownDateTimePicker(
      controller: dateTimePickerController,
      configuration: DateTimePickerConfiguration(
        highlightToday: widget.highlightToday,
        alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
        pickTime: false,
        theme: widget.theme.timePickerTheme,
        header: widget.header,
        markedDates: widget.highlightedDates,
        disabledDates: widget.disabledDates,
      ),
      onTimerPickerSheetChange: (p0) {
        if (widget.updateEmptyChildPosition) {
          setState(() {
            _scrollOffset = p0 - widget.tableTopPadding;
          });
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: widget.tableTopPadding,
          ),
          SizedBox(
            height: (widget.size != null)
                ? widget.size!.height - widget.tableTopPadding
                : null,
            width: (widget.size != null) ? widget.size!.width : null,
            child: (widget.childIfEmptyRoster != null && events.isEmpty)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // add empty space between the top of the widget
                      //and the child if the datepicker is expanded
                      SizedBox(
                        height: _scrollOffset,
                      ),
                      widget.childIfEmptyRoster!,
                    ],
                  )
                : Timetable(
                    key: timeTableKey,
                    tableDirection: widget.tableDirection,
                    initialScrollTime: widget.initialScrollTime,
                    scrollPhysics: widget.scrollPhysics,
                    scrollController: widget.scrollController,
                    blockColor: widget.blockColor,
                    blockDimension: widget.blockDimension,
                    hourDimension: widget.hourDimension,
                    hoursOffset: widget.hoursOffset,
                    startHour: widget.startHour,
                    endHour: widget.endHour,
                    timeBlocks: events,
                    theme: widget.theme.tableTheme,
                    combineBlocks: true,
                    mergeBlocks: false,
                    scrollTriggerOffset: widget.scrollTriggerOffset,
                    scrollJumpToOffset: widget.scrollJumpToOffset,
                    onOverScroll: widget.enableBorderScroll
                        ? () {
                            setState(() {
                              _selectedDate =
                                  _selectedDate.add(const Duration(days: 1));
                            });

                            dateTimePickerController
                                .onBorderScroll(_selectedDate);
                          }
                        : null,
                    onUnderScroll: widget.enableBorderScroll
                        ? () {
                            setState(() {
                              _selectedDate = _selectedDate
                                  .subtract(const Duration(days: 1));
                            });

                            dateTimePickerController
                                .onBorderScroll(_selectedDate);
                          }
                        : null,
                    size: (widget.size != null)
                        ? Size(
                            widget.size!.width,
                            widget.size!.height - widget.tableTopPadding,
                          )
                        : null,
                  ),
          ),
        ],
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
