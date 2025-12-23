import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reusable template for document scanner screens.
/// Provides consistent layout and styling across all states.
///
/// Similar to NfcScreen from the NFC Scanner feature, this template ensures
/// a unified visual experience and reduces code duplication.
class DocumentScreenTemplate extends ConsumerWidget {
  /// Background gradient colors
  final List<Color> backgroundColors;

  /// Primary action button color
  final Color primaryColor;

  /// Optional header widget (above body)
  final Widget? header;

  /// Main body content (typically Expanded to fill space)
  final Widget body;

  /// Optional action buttons (below body)
  final List<Widget>? actionButtons;

  /// Optional dismiss/close callback
  final VoidCallback? onDismiss;

  const DocumentScreenTemplate({
    required this.backgroundColors,
    required this.primaryColor,
    this.header,
    required this.body,
    this.actionButtons,
    this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Header (optional)
                if (header != null) ...[
                  header!,
                  const SizedBox(height: 32),
                ],

                // Body (main content)
                body,

                const Spacer(),

                // Action buttons (optional)
                if (actionButtons != null) ...[
                  const SizedBox(height: 24),
                  ...actionButtons!,
                ],

                // Dismiss button (optional)
                if (onDismiss != null) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onDismiss,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Color scheme presets for document scanner screens
class DocumentScreenColors {
  /// Default primary colors for document scanner
  static const List<Color> defaultGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
  ];

  /// Success state colors (green gradient)
  static const List<Color> successGradient = [
    Color(0xFF1B3A1B),
    Color(0xFF2D5A2D),
  ];

  /// Error state colors (red gradient)
  static const List<Color> errorGradient = [
    Color(0xFF2D1B1B),
    Color(0xFF3E1616),
  ];

  /// Primary action color
  static const Color primary = Colors.white;

  /// Success action color
  static const Color success = Color(0xFF4CAF50);

  /// Error action color
  static const Color error = Color(0xFFFF5252);

  /// Warning action color
  static const Color warning = Color(0xFFFFB74D);
}

/// Helper widget for centered icon headers
class DocumentScreenHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;

  const DocumentScreenHeader({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}

/// Helper widget for action buttons
class DocumentActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? icon;

  const DocumentActionButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF1A1A2E),
    this.isFullWidth = true,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: buttonChild,
      ),
    );
  }
}

/// Helper widget for secondary action button (outlined style)
class DocumentSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final bool isFullWidth;
  final IconData? icon;

  const DocumentSecondaryButton({
    required this.label,
    required this.onPressed,
    this.borderColor = Colors.grey,
    this.textColor = Colors.white,
    this.isFullWidth = true,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget for displaying information cards
class DocumentInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const DocumentInfoCard({
    required this.label,
    required this.value,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
