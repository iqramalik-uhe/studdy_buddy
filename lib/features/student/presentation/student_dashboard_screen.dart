import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/models/tutor.dart';
import '../../../shared/widgets/tutor_card.dart';
import '../../../main.dart';
import '../../student/application/student_prefs.dart';

final _searchQueryProvider = StateProvider<String>((ref) => '');
final _modeFilterProvider = StateProvider<String?>((ref) => null);
final _subjectFilterProvider = StateProvider<String?>((ref) => null);
final _maxRateProvider = StateProvider<double>((ref) => 50);

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final query = ref.watch(_searchQueryProvider);
    final mode = ref.watch(_modeFilterProvider);
    final subject = ref.watch(_subjectFilterProvider);
    final maxRate = ref.watch(_maxRateProvider);

    final tutors = mockTutors.where((t) {
      final matchesQuery = query.isEmpty || t.name.toLowerCase().contains(query.toLowerCase());
      final matchesMode = mode == null || t.mode == mode || (mode == 'physical' && t.mode == 'hybrid') || (mode == 'online' && t.mode == 'hybrid');
      final matchesSubject = subject == null || t.subjects.contains(subject);
      final matchesRate = t.hourlyRate <= maxRate;
      return matchesQuery && matchesMode && matchesSubject && matchesRate;
    }).toList();

    final selections = ref.watch(studentPrefsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find your Tutor'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              // reset role to force sign-in flow
              ref.read(roleProvider.notifier).state = null;
              context.go('/student/signin');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.brandGradient),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selections.course != null || selections.teacherId != null || selections.budgetPkr != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Enrolled: '
                          '${selections.course ?? '—'} • '
                          'Teacher: ${selections.teacherId ?? '—'} • '
                          'Budget: ${selections.budgetPkr != null ? 'Rs ${selections.budgetPkr!.toStringAsFixed(0)}' : '—'}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            _SearchBar(),
            const SizedBox(height: 12),
            _FiltersRow(scheme: scheme),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: tutors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => TutorCard(tutor: tutors[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (v) => ref.read(_searchQueryProvider.notifier).state = v,
      decoration: const InputDecoration(
        hintText: 'Search tutors, subjects... ',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class _FiltersRow extends ConsumerWidget {
  const _FiltersRow({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(_modeFilterProvider);
    final subject = ref.watch(_subjectFilterProvider);
    final maxRate = ref.watch(_maxRateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _Chip(
                label: 'All',
                selected: mode == null,
                onSelected: () => ref.read(_modeFilterProvider.notifier).state = null,
              ),
              const SizedBox(width: 8),
              _Chip(
                label: 'Online',
                selected: mode == 'online',
                onSelected: () => ref.read(_modeFilterProvider.notifier).state = 'online',
              ),
              const SizedBox(width: 8),
              _Chip(
                label: 'Physical',
                selected: mode == 'physical',
                onSelected: () => ref.read(_modeFilterProvider.notifier).state = 'physical',
              ),
              const SizedBox(width: 8),
              _Chip(
                label: 'Hybrid',
                selected: mode == 'hybrid',
                onSelected: () => ref.read(_modeFilterProvider.notifier).state = 'hybrid',
              ),
              const SizedBox(width: 8),
              _SubjectDropdown(subject: subject),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Max Rate:'),
            Expanded(
              child: Slider(
                min: 10,
                max: 80,
                divisions: 14,
                value: maxRate,
                label: '\$${maxRate.toStringAsFixed(0)}',
                onChanged: (v) => ref.read(_maxRateProvider.notifier).state = v,
                activeColor: AppTheme.primary,
                inactiveColor: AppTheme.primary.withOpacity(0.2),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onSelected});
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _SubjectDropdown extends ConsumerWidget {
  const _SubjectDropdown({required this.subject});
  final String? subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const subjects = <String>['Math', 'Physics', 'Chemistry', 'English', 'IELTS', 'Computer Science'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7E7EF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: subject,
          hint: const Text('Subject'),
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('All subjects')),
            ...subjects.map((s) => DropdownMenuItem<String?>(value: s, child: Text(s))),
          ],
          onChanged: (v) => ref.read(_subjectFilterProvider.notifier).state = v,
        ),
      ),
    );
  }
}



