import 'dart:collection';
import 'dart:math';
import 'package:church_volunteer_scheduler/data/struct/activity.dart';
import 'package:church_volunteer_scheduler/data/struct/role.dart';
import 'package:church_volunteer_scheduler/views/dialogs/select_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:church_volunteer_scheduler/views/sched_sheet.dart';
import 'package:collection/collection.dart';

import 'grid_to_data_connector.dart';
  

class DataSource {
  
  static final DataSource _instance = DataSource._dataSource();

  final List<Activity> activities = [];
  late final GridToDataConnector connector = GridToDataConnector(activities);

  DataSource._dataSource();

  factory DataSource() {
    return _instance;
  }
  
  void generatePlaceholderActivities() {
    var now = DateTime.now().copyWith(hour: 0,minute: 0, second: 0, millisecond: 0, microsecond: 0);
    Activity amService = Activity("AM Service", RecurrenceProperties(
      startDate: now,
      recurrenceType: RecurrenceType.weekly,
      weekDays: [WeekDays.sunday],
      interval: 1,
      recurrenceRange: RecurrenceRange.endDate,
      endDate: DateTime.now().add(Duration(days: 365))
      ), 
      now.subtract(Duration(days: 90)),
      now.add(Duration(seconds: 1)));

    amService.roles.addAll([
      Role("Song Leader", amService),
      Role("Announcements", amService),
      Role("Opening Prayer", amService),
      Role("Communion Lead", amService),
      Role("Communion Side 1", amService),
      Role("Communion Side 2", amService),
      Role("Closing Prayer", amService),
      Role("Tech", amService),
    ]);
    
    Activity pmService = Activity("PM Service", RecurrenceProperties(
      startDate: now,
      recurrenceType: RecurrenceType.weekly,
      weekDays: [WeekDays.sunday],
      interval: 1,
      recurrenceRange: RecurrenceRange.endDate,
      endDate: now.add(Duration(days: 365))
      ), 
      now.subtract(Duration(days: 90)),
      now.add(Duration(hours: 1)));

    pmService.roles.addAll([
      Role("Song Leader", pmService),
      Role("Announcements", pmService),
      Role("Opening Prayer", pmService),
      Role("Communion Lead", pmService),
      Role("Communion Side 1", pmService),
      Role("Communion Side 2", pmService),
      Role("Closing Prayer", pmService),
    ]);
    
    Activity extraService = Activity("extra Service", RecurrenceProperties(
      startDate: now,
      recurrenceType: RecurrenceType.weekly,
      weekDays: [WeekDays.sunday],
      interval: 2,
      recurrenceRange: RecurrenceRange.endDate,
      endDate: now.add(Duration(days: 365))
      ), 
      now.subtract(Duration(days: 90)),
      now.add(Duration(hours: 2)));

    extraService.roles.addAll([
      Role("BiWeekly Leader", extraService)]);


    amService.generateFalseAssignments();
    pmService.generateFalseAssignments();
    extraService.generateFalseAssignments();

    activities.addAll([amService, pmService, extraService]);
  }

}
