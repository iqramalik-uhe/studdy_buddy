import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _method;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose payment method')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RadioListTile<String>(
              value: 'card',
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v),
              title: const Text('Credit / Debit Card'),
              subtitle: const Text('Pay securely in-app'),
            ),
            RadioListTile<String>(
              value: 'cash',
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v),
              title: const Text('Cash (for physical sessions)'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _method == null ? null : () => context.go('/student'),
              child: const Text('Finish & Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}


