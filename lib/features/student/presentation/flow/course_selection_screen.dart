import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../application/student_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseSelectionScreen extends ConsumerStatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  ConsumerState<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends ConsumerState<CourseSelectionScreen> {
  String? _selected;
  static const _courses = [
    'Math', 'Physics', 'Chemistry', 'English', 'IELTS', 'Computer Science',
    'Biology', 'Statistics', 'Accounting', 'Economics', 'Urdu', 'Islamiyat',
    'History', 'Geography', 'Programming (Flutter)', 'Programming (Java)',
    'Programming (Python)', 'Data Science', 'Graphic Design', 'SAT Prep',
    'GRE Prep', 'O/A Levels Prep', 'Pak Studies', 'Sindhi'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose your course')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _courses.map((c) => ChoiceChip(
                label: Text(c),
                selected: _selected == c,
                onSelected: (_) => setState(() => _selected = c),
              )).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selected == null
                  ? null
                  : () async {
                      await ref.read(studentPrefsProvider.notifier).setCourse(_selected!);
                      // clear any previous teacher selection when course changes
                      await ref.read(studentPrefsProvider.notifier).setTeacher('');
                      if (!mounted) return;
                      context.go('/student/onboarding/teacher');
                    },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}


