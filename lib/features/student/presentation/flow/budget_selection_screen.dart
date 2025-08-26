import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../application/student_prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetSelectionScreen extends ConsumerStatefulWidget {
  const BudgetSelectionScreen({super.key});

  @override
  ConsumerState<BudgetSelectionScreen> createState() => _BudgetSelectionScreenState();
}

class _BudgetSelectionScreenState extends ConsumerState<BudgetSelectionScreen> {
  double _budget = 4000; // PKR per hour

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set your budget (PKR)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hourly budget: Rs ${_budget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18)),
            Slider(
              min: 500,
              max: 15000,
              divisions: 29,
              value: _budget,
              label: 'Rs ${_budget.toStringAsFixed(0)}',
              onChanged: (v) => setState(() => _budget = v),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await ref.read(studentPrefsProvider.notifier).setBudget(_budget);
                if (!mounted) return;
                context.go('/student/onboarding/payment');
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}


