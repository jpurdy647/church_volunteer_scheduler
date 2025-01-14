import 'package:church_volunteer_scheduler/data/struct/activity.dart';

class Role {
  final String roleName;
  final Activity activity;
  const Role(this.roleName, this.activity);
  @override
  String toString() {
    return "${activity.name} - $roleName";
  }

  @override
  bool operator ==(Object other) {
    if (other is Role) {
      return roleName == other.roleName && activity == other.activity;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(activity, roleName);
}
