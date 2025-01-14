import 'package:church_volunteer_scheduler/data/struct/activity.dart';
import 'package:church_volunteer_scheduler/data/struct/role.dart';

enum RowFilterBeginType {
  today,
  thisWeek,
  thisMonth,
  thisYear,
  lastWeek,
  lastMonth,
  lastYear,
  allTime,
}

enum RowFilterEndType {
  thisWeek,
  thisMonth,
  thisYear,
  nextWeek,
  nextMonth,
  nextYear,
  allTime,
}

class RowFilter {
  RowFilterBeginType beginType;
  RowFilterEndType endType;
  RowFilter(
      {this.beginType = RowFilterBeginType.thisMonth,
      this.endType = RowFilterEndType.allTime});

  bool test(DateTime testDate) {
    var now = DateTime.now().copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    switch (beginType) {
      case RowFilterBeginType.today:
        if (testDate.isBefore(now)) {
          return false;
        }
        break;
      case RowFilterBeginType.thisWeek:
        if (testDate.isBefore(now.subtract(Duration(days: now.weekday - 1)))) {
          return false;
        }
        break;
      case RowFilterBeginType.thisMonth:
        if (testDate.isBefore(now.copyWith(day: 1))) {
          return false;
        }
        break;
      case RowFilterBeginType.thisYear:
        if (testDate.isBefore(now.copyWith(month: 1, day: 1))) {
          return false;
        }
        break;
      case RowFilterBeginType.lastWeek:
        if (testDate.isBefore(now.subtract(Duration(days: now.weekday - 8)))) {
          return false;
        }
        break;
      case RowFilterBeginType.lastMonth:
        if (testDate.isBefore(now.copyWith(month: 0, day: 1))) {
          return false;
        }
        break;
      case RowFilterBeginType.lastYear:
        if (testDate.isBefore(now.copyWith(year: 0, month: 1, day: 1))) {
          return false;
        }
        break;
      case RowFilterBeginType.allTime:
        break;
    }

    switch (endType) {
      case RowFilterEndType.thisWeek:
        if (testDate.isAfter(now.add(Duration(days: 7 - now.weekday)))) {
          return false;
        }
        break;
      case RowFilterEndType.thisMonth:
        if (testDate.isAfter(now.copyWith(month: now.month + 1, day: 0))) {
          return false;
        }
        break;
      case RowFilterEndType.thisYear:
        if (testDate
            .isAfter(now.copyWith(year: now.year + 1, month: 0, day: 0))) {
          return false;
        }
        break;
      case RowFilterEndType.nextWeek:
        if (testDate.isAfter(now.add(Duration(days: 14 - now.weekday)))) {
          return false;
        }
        break;
      case RowFilterEndType.nextMonth:
        if (testDate.isAfter(now.copyWith(month: now.month + 2, day: 0))) {
          return false;
        }
        break;
      case RowFilterEndType.nextYear:
        if (testDate
            .isAfter(now.copyWith(year: now.year + 2, month: 0, day: 0))) {
          return false;
        }
        break;
      case RowFilterEndType.allTime:
        break;
    }

    return true;
  }
DateTime endDate(){
  var now = DateTime.now().copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    switch (endType) {
      case RowFilterEndType.thisWeek:
        return now.add(Duration(days: 7 - now.weekday));
      case RowFilterEndType.thisMonth:
        return now.copyWith(month: now.month + 1, day: 0);
      case RowFilterEndType.thisYear:
        return now.copyWith(year: now.year + 1, month: 0, day: 0);
      case RowFilterEndType.nextWeek:
        return now.add(Duration(days: 14 - now.weekday));
      case RowFilterEndType.nextMonth:
        return now.copyWith(month: now.month + 2, day: 0);
      case RowFilterEndType.nextYear:
        return now.copyWith(year: now.year + 2, month: 0, day: 0);
      case RowFilterEndType.allTime:
        return now.copyWith(year: now.year + 120, month: 0, day: 0);

    }

}

}

class ColumnFilter {
  final List<Activity> _activitiesToHide = [];
  final List<Role> _rolesToHide = [];
  ColumnFilter({List<Activity>? activities, List<Role>? roles}) {
    if (activities != null) {
      addActivitiesToHide(activities);
    }
    if (roles != null) {
      addRolesToHide(roles);
    }
  }

  bool test({Activity? activity, Role? role}) {
    assert(activity != null || role != null);
    if (_activitiesToHide.contains(activity) || _activitiesToHide.contains(role?.activity) || _rolesToHide.contains(role)) {
      return false;
    }
    return true;
  }

  void addActivitiesToHide(List<Activity> activities) {
    for (var activity in activities) {
      if (!_activitiesToHide.contains(activity)) {
        _activitiesToHide.add(activity);
      }
    }
  }

  void addRolesToHide(List<Role> roles) {
    for (var role in roles) {
      if (!_rolesToHide.contains(role)) {
        _rolesToHide.add(role);
      }
    }
  }

  void setActivitiesToHide(List<Activity> activities) {
    _activitiesToHide.clear();
    addActivitiesToHide(activities);
  }

  void setRolesToHide(List<Role> roles) {
    _rolesToHide.clear();
    addRolesToHide(roles);
  }

  void clearActivitiesToHide() {
    _activitiesToHide.clear();
  }

  void clearRolesToHide() {
    _rolesToHide.clear();
  }

  bool isHidden({Activity? act, Role? rol}){
    return _activitiesToHide.contains(act) || _rolesToHide.contains(rol);
  }
}
