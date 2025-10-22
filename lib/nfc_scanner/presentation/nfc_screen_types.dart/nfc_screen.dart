import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NfcScreen extends ConsumerWidget {
  const NfcScreen({
    super.key,
    this.onCancel,
    required this.backgroundColors,
    required this.body,
    required this.primaryColor,
    this.actionButton,
    this.header,
    this.onTryAgain,
  });
  final void Function()? onCancel;
  final Color primaryColor;
  final List<Color> backgroundColors;
  final Widget? header;
  final Widget body;
  final void Function()? onTryAgain;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: backgroundColors.isNotEmpty
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: backgroundColors,
                  ),
                )
              : null,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 24.0),
              child: Column(
                children: [
                  if (header != null) ...[
                    header!,
                    const SizedBox(height: 32),
                  ],
                  body,
                  if (actionButton != null) ...[
                    SizedBox(width: double.infinity, child: actionButton),
                    const SizedBox(height: 12),
                  ],
                  if (onTryAgain != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          onTryAgain!();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text(
                          'Try again',
                        ),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          backgroundColor: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (onCancel != null) ...[
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onCancel,
                          borderRadius: BorderRadius.circular(12),
                          splashColor: colorScheme.outline.withValues(
                            alpha: 0.1,
                          ),
                          highlightColor: colorScheme.outline.withValues(
                            alpha: 0.05,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 16,
                                  color: colorScheme.outline.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.outline.withValues(
                                      alpha: 0.7,
                                    ),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
