import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSelections {
  const StudentSelections({this.course, this.teacherId, this.budgetPkr});
  final String? course;
  final String? teacherId;
  final double? budgetPkr;

  Map<String, Object?> toJson() => {
        'course': course,
        'teacherId': teacherId,
        'budgetPkr': budgetPkr,
      };
}

class StudentPrefsController extends Notifier<StudentSelections> {
  @override
  StudentSelections build() => const StudentSelections();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_email');
    state = StudentSelections(
      course: prefs.getString('sel_course_${email ?? ''}'),
      teacherId: prefs.getString('sel_teacherId_${email ?? ''}'),
      budgetPkr: prefs.getDouble('sel_budgetPkr_${email ?? ''}'),
    );
  }

  Future<void> setCourse(String value) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_email') ?? '';
    await prefs.setString('sel_course_$email', value);
    state = StudentSelections(course: value, teacherId: state.teacherId, budgetPkr: state.budgetPkr);
  }

  Future<void> setTeacher(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_email') ?? '';
    await prefs.setString('sel_teacherId_$email', id);
    state = StudentSelections(course: state.course, teacherId: id, budgetPkr: state.budgetPkr);
  }

  Future<void> setBudget(double pkr) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_email') ?? '';
    await prefs.setDouble('sel_budgetPkr_$email', pkr);
    state = StudentSelections(course: state.course, teacherId: state.teacherId, budgetPkr: pkr);
  }
}

final studentPrefsProvider = NotifierProvider<StudentPrefsController, StudentSelections>(
  StudentPrefsController.new,
);


