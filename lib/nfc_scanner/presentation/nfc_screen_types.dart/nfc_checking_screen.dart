import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_screen.dart';

class NfcCheckingScreen extends ConsumerWidget {
  const NfcCheckingScreen({super.key, required this.onCancel});
  final void Function() onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return NfcScreen(
      backgroundColors: [
        colorScheme.primary.withValues(alpha: 0.1),
        colorScheme.surface,
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ],
      primaryColor: colorScheme.primary,
      onCancel: onCancel,
      body: Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Checking NFC availability...',
                style: TextStyle(color: colorScheme.primary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
