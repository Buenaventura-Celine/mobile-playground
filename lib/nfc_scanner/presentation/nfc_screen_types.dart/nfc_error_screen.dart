import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_screen.dart';

class NfcErrorScreen extends ConsumerWidget {
  const NfcErrorScreen({
    super.key,
    required this.onCancel,
    this.onTryAgain,
    required this.title,
    required this.subtitle,
  });
  final void Function() onCancel;
  final void Function()? onTryAgain;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return NfcScreen(
      primaryColor: colorScheme.error,
      backgroundColors: [
        colorScheme.error.withValues(alpha: 0.1),
        colorScheme.surface,
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ],
      onCancel: onCancel,
      onTryAgain: onTryAgain,
      body: Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.errorContainer.withValues(alpha: 0.3),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 60,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
