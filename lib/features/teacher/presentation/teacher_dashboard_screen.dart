import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.go('/teacher/signin'),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.brandGradient),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _ActionTile(icon: Icons.schedule, label: 'Manage Availability'),
                _ActionTile(icon: Icons.event_available, label: 'View Bookings'),
                _ActionTile(icon: Icons.video_call, label: 'Start Session'),
                _ActionTile(icon: Icons.payments, label: 'Payments'),
                _ActionTile(icon: Icons.rate_review, label: 'Reviews'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('Math with Ali (Online)'),
                    subtitle: Text('10:00 - 11:00 AM'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    title: Text('Physics with Sara (Physical)'),
                    subtitle: Text('2:00 - 3:00 PM'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 80,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}


