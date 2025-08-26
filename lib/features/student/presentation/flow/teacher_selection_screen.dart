import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../application/student_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/tutor.dart';
import '../../../../shared/widgets/tutor_card.dart';

class TeacherSelectionScreen extends ConsumerStatefulWidget {
  const TeacherSelectionScreen({super.key});

  @override
  ConsumerState<TeacherSelectionScreen> createState() => _TeacherSelectionScreenState();
}

class _TeacherSelectionScreenState extends ConsumerState<TeacherSelectionScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a teacher')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: mockTutors.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final t = mockTutors[index];
            final selected = t.id == _selectedId;
            return Stack(
              children: [
                TutorCard(tutor: t, onTap: () => setState(() => _selectedId = t.id)),
                if (selected)
                  const Positioned(top: 8, right: 8, child: Icon(Icons.check_circle, color: Colors.green))
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _selectedId == null
              ? null
              : () async {
                  await ref.read(studentPrefsProvider.notifier).setTeacher(_selectedId!);
                  if (!mounted) return;
                  context.go('/student/onboarding/budget');
                },
          child: const Text('Continue'),
        ),
      ),
    );
  }
}


