import 'dart:collection';
import 'dart:math';
import 'package:church_volunteer_scheduler/data/data_source.dart';
import 'package:church_volunteer_scheduler/data/struct/assignment.dart';
import 'package:church_volunteer_scheduler/data/struct/role.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Activity {
  RecurrenceProperties
      recurrenceProperties;
  final String name;
  final List<Role> roles = [];
  final DateTime startDate;
  late DateTime endDate;
  Duration duration = Duration(hours: 2);
  final SplayTreeMap<DateTime, Map<Role, Assignment>> _assignments =
      SplayTreeMap();
  Activity(this.name, this.recurrenceProperties, this.startDate,
      [DateTime? optionalEndDate]) {
    endDate = optionalEndDate ?? startDate.copyWith(year: startDate.year + 1);
  }

  void addAssignment(DateTime date, Assignment assignment,
      {overwrite = false}) {
    if (!roles.contains(assignment.role)) {
      throw Exception(
          "Role (${assignment.role}) not found in activity ($name)");
    }
    _assignments[date] ??= {};

    if (!overwrite && _assignments[date]!.containsKey(assignment.role)) {
      //TODO log refusal to overwrite assignment
      return;
    }

    _assignments[date]![assignment.role] = assignment;
  }

  void addAssignments(DateTime date, List<Assignment> assignments) {
    for (var assignment in assignments) {
      addAssignment(date, assignment);
    }
  }

  Map<Role, Assignment> getAssignmentsForDate(DateTime date) {
    return _assignments[date] ?? {};
  }

  SplayTreeMap<DateTime, Map<Role, Assignment>> getAssignments() {
    return _assignments;
  }

  Assignment getAssignment(DateTime date, Role role) {
    if (_assignments[date] == null || _assignments[date]![role] == null) {
      return Assignment.na(date, role);
    } else {
      return _assignments[date]![role]!;
    }
  }

  /// removeAssignment Docs here
  /// _assignments Provide either an assignment or role object so role can be determined for assignment removal
  void removeAssignment(DateTime date, {Assignment? assignment, Role? role}) {
    if (!_assignments.containsKey(date)) {
      return;
    }
    if (assignment != null) {
      _assignments[date]!.remove(assignment.role);
    } else if (role != null) {
      _assignments[date]!.remove(role);
    } else {
      throw Exception("Must provide either an assignment or role to remove");
    }
  }

  void removeAssignments(DateTime date) {
    _assignments.remove(date);
  }

  void generateFalseAssignments() {
    fillDates();
    for (var date in _assignments.keys) {
      for (var role in roles) {
        if (_assignments[date]![role] == null) {
          var fakers = [
            "Alice",
            "Bob",
            "Charlie",
            "David",
            "Eve",
            "Frank",
            "Grace",
            "Heidi",
            "Ivan",
            "Judy",
            "Karl",
            "Liam",
            "Mona",
            "Nina",
            "Omar",
            "Pam",
            "Quinn",
            "Ruth",
            "Sam",
            "Tina",
            "Uma",
            "Vera",
            "Wendy",
            "Xander",
            "Yara",
            "Zane"
          ];
          addAssignment(date,
              Assignment(date, role, fakers[Random().nextInt(fakers.length)]));
        }
      }
    }
  }

  void fillDates() {
      var filteredEndDate = DataSource().connector.rowFilter.endDate();
      if (recurrenceProperties.endDate != null &&
          recurrenceProperties.endDate!.isBefore(filteredEndDate!)) {
        filteredEndDate = recurrenceProperties.endDate!;
      }
    if (_assignments.isNotEmpty) {
      var prependEndDate =
          _assignments.firstKey()!.subtract(Duration(seconds: 1));
      var postpendStartDate = _assignments.lastKey()!.add(Duration(seconds: 1));
      var prependRecRule = SfCalendar.generateRRule(
          recurrenceProperties..endDate = prependEndDate,
          startDate,
          startDate.add(Duration(hours: 2)));
      var postpendRecRule = SfCalendar.generateRRule(
          recurrenceProperties..startDate = postpendStartDate,
          postpendStartDate,
          postpendStartDate.add(Duration(hours: 2)));
      SfCalendar.getRecurrenceDateTimeCollection(prependRecRule, startDate,
              specificEndDate: filteredEndDate)
          .forEach((date) {
        _assignments.putIfAbsent(date, () => {});
      });
      SfCalendar.getRecurrenceDateTimeCollection(postpendRecRule, startDate,
              specificEndDate: filteredEndDate)
          .forEach((date) {
        _assignments.putIfAbsent(date, () => {});
      });
    } else {
      var recRule = SfCalendar.generateRRule(
          recurrenceProperties,
          startDate,
          startDate.add(Duration(hours: 2)));
      SfCalendar.getRecurrenceDateTimeCollection(recRule, startDate,
              specificEndDate: filteredEndDate)
          .forEach((date) {
        _assignments.putIfAbsent(date, () => {});
      });
    }
  }
}
