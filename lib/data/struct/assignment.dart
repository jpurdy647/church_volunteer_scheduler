import 'package:church_volunteer_scheduler/data/struct/activity.dart';
import 'package:church_volunteer_scheduler/data/struct/role.dart';

class Assignment {
  static const String NA = "NOT APPLICABLE";
  DateTime date;
  Role role;
  String assigneeName;
  Assignment(this.date, this.role, this.assigneeName)
      : assert(assigneeName != NA);
  Assignment.na(this.date, this.role) : assigneeName = NA;
  @override
  String toString() {
    if (assigneeName == "UNASSIGNED") {
      return "";
    } else if (assigneeName == "NOT APPLICABLE") {
      return "";
    } else {
      return assigneeName;
    }
  }
}
