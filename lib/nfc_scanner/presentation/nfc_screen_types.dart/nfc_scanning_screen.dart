import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_screen.dart';

class PhoneNfcPainter extends CustomPainter {
  final Color phoneColor;
  final Color nfcAreaColor;
  final Color tagColor;
  final double tagProgress;
  final double pulseProgress;

  PhoneNfcPainter({
    required this.phoneColor,
    required this.nfcAreaColor,
    required this.tagColor,
    required this.tagProgress,
    required this.pulseProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Phone shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 2, center.dy + 4),
        width: size.width * 0.5,
        height: size.height * 0.8,
      ),
      const Radius.circular(25),
    );
    canvas.drawRRect(shadowRect, shadowPaint);

    // Phone body (back)
    final phoneBodyPaint = Paint()
      ..color = phoneColor
      ..style = PaintingStyle.fill;

    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.5,
        height: size.height * 0.8,
      ),
      const Radius.circular(25),
    );
    canvas.drawRRect(phoneRect, phoneBodyPaint);

    // Phone outline/border
    final phoneBorderPaint = Paint()
      ..color = phoneColor.withValues(alpha: 0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(phoneRect, phoneBorderPaint);

    // Camera module (back of phone - left side)
    final cameraPaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.fill;

    // Simple single camera lens
    canvas.drawCircle(
      Offset(
        center.dx - size.width * 0.15,
        center.dy - size.height * 0.28,
      ),
      12,
      cameraPaint,
    );

    // Camera lens ring
    final lensRingPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(
        center.dx - size.width * 0.15,
        center.dy - size.height * 0.28,
      ),
      12,
      lensRingPaint,
    );

    // Brand logo area (back of phone)
    final logoPaint = Paint()
      ..color = Colors.grey.shade400.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + size.height * 0.25),
          width: 60,
          height: 15,
        ),
        const Radius.circular(3),
      ),
      logoPaint,
    );

    // Side buttons
    final buttonPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    // Volume buttons (left side)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            center.dx - size.width * 0.26,
            center.dy - size.height * 0.1,
          ),
          width: 4,
          height: 25,
        ),
        const Radius.circular(2),
      ),
      buttonPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(
            center.dx - size.width * 0.26,
            center.dy + size.height * 0.05,
          ),
          width: 4,
          height: 25,
        ),
        const Radius.circular(2),
      ),
      buttonPaint,
    );

    // Power button (right side)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + size.width * 0.26, center.dy),
          width: 4,
          height: 30,
        ),
        const Radius.circular(2),
      ),
      buttonPaint,
    );

    // NFC area with dotted border and icon
    final nfcAreaPaint = Paint()
      ..color = nfcAreaColor.withValues(
        alpha: 0.15 + (pulseProgress * 0.1),
      )
      ..style = PaintingStyle.fill;

    final nfcAreaRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - size.height * 0.05),
        width: size.width * 0.3,
        height: size.height * 0.18,
      ),
      const Radius.circular(15),
    );
    canvas.drawRRect(nfcAreaRect, nfcAreaPaint);

    // NFC area dotted border
    final nfcBorderPaint = Paint()
      ..color = nfcAreaColor.withValues(alpha: 0.7 + (pulseProgress * 0.3))
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw dotted border
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final rect = nfcAreaRect.outerRect;

    // Top border
    for (
      double x = rect.left;
      x < rect.right;
      x += dashWidth + dashSpace
    ) {
      canvas.drawLine(
        Offset(x, rect.top),
        Offset((x + dashWidth).clamp(rect.left, rect.right), rect.top),
        nfcBorderPaint,
      );
    }

    // Bottom border
    for (
      double x = rect.left;
      x < rect.right;
      x += dashWidth + dashSpace
    ) {
      canvas.drawLine(
        Offset(x, rect.bottom),
        Offset((x + dashWidth).clamp(rect.left, rect.right), rect.bottom),
        nfcBorderPaint,
      );
    }

    // Left border
    for (
      double y = rect.top;
      y < rect.bottom;
      y += dashWidth + dashSpace
    ) {
      canvas.drawLine(
        Offset(rect.left, y),
        Offset(rect.left, (y + dashWidth).clamp(rect.top, rect.bottom)),
        nfcBorderPaint,
      );
    }

    // Right border
    for (
      double y = rect.top;
      y < rect.bottom;
      y += dashWidth + dashSpace
    ) {
      canvas.drawLine(
        Offset(rect.right, y),
        Offset(rect.right, (y + dashWidth).clamp(rect.top, rect.bottom)),
        nfcBorderPaint,
      );
    }

    // NFC tag animation
    if (tagProgress > 0) {
      // Tag position animates from right side to the NFC area
      final startX = center.dx + size.width * 0.4;
      final endX = center.dx;
      final currentX = startX + (endX - startX) * tagProgress;
      final tagY = center.dy - size.height * 0.05;

      // Tag shadow
      final tagShadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: tagProgress * 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(
        Offset(currentX + 1, tagY + 2),
        22,
        tagShadowPaint,
      );

      // Tag body (simple circular design)
      final tagBodyPaint = Paint()
        ..color = Colors.white.withValues(alpha: tagProgress)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(currentX, tagY), 20, tagBodyPaint);

      // Tag border
      final tagBorderPaint = Paint()
        ..color = tagColor.withValues(alpha: tagProgress)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(Offset(currentX, tagY), 20, tagBorderPaint);

      // NFC icon (simplified and clear)
      if (tagProgress > 0.3) {
        final iconOpacity = ((tagProgress - 0.3) / 0.7).clamp(0.0, 1.0);
        final iconPaint = Paint()
          ..color = tagColor.withValues(alpha: iconOpacity)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        final iconCenter = Offset(currentX, tagY);

        // Draw NFC symbol (3 concentric arcs)
        for (int i = 0; i < 3; i++) {
          final radius = 6.0 + (i * 3.5);
          canvas.drawArc(
            Rect.fromCenter(
              center: iconCenter,
              width: radius * 2,
              height: radius * 2,
            ),
            -1.57, // Start from top
            3.14, // Half circle
            false,
            iconPaint,
          );
        }

        // NFC center dot
        final dotPaint = Paint()
          ..color = tagColor.withValues(alpha: iconOpacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(iconCenter, 2, dotPaint);
      }
    }

    // Instruction arrow with pulse effect
    if (tagProgress < 0.8) {
      final arrowOpacity = 1.0 - (tagProgress * 0.5);
      final pulseOffset = pulseProgress * 3.0;

      final arrowPaint = Paint()
        ..color = nfcAreaColor.withValues(alpha: arrowOpacity * 0.8)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final arrowStart = Offset(
        center.dx + size.width * 0.22 - pulseOffset,
        center.dy - size.height * 0.05,
      );
      final arrowEnd = Offset(
        center.dx + size.width * 0.08 - pulseOffset,
        center.dy - size.height * 0.05,
      );

      // Arrow line
      canvas.drawLine(arrowStart, arrowEnd, arrowPaint);

      // Arrow head (filled triangle)
      final arrowHeadPaint = Paint()
        ..color = nfcAreaColor.withValues(alpha: arrowOpacity * 0.8)
        ..style = PaintingStyle.fill;

      const arrowHeadSize = 10.0;
      final arrowPath = Path()
        ..moveTo(arrowEnd.dx, arrowEnd.dy)
        ..lineTo(
          arrowEnd.dx + arrowHeadSize,
          arrowEnd.dy - arrowHeadSize / 2,
        )
        ..lineTo(
          arrowEnd.dx + arrowHeadSize,
          arrowEnd.dy + arrowHeadSize / 2,
        )
        ..close();
      canvas.drawPath(arrowPath, arrowHeadPaint);

      // Arrow text label
      final labelPaint = Paint()
        ..color = nfcAreaColor.withValues(alpha: arrowOpacity * 0.6)
        ..style = PaintingStyle.fill;

      // Simple "PLACE HERE" indicator (as rectangles)
      final labelY = center.dy + size.height * 0.02;
      for (int i = 0; i < 3; i++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(center.dx + (i - 1) * 12, labelY),
              width: 8,
              height: 3,
            ),
            const Radius.circular(1),
          ),
          labelPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(PhoneNfcPainter oldDelegate) =>
      phoneColor != oldDelegate.phoneColor ||
      nfcAreaColor != oldDelegate.nfcAreaColor ||
      tagColor != oldDelegate.tagColor ||
      tagProgress != oldDelegate.tagProgress ||
      pulseProgress != oldDelegate.pulseProgress;
}

class NfcScanningScreen extends ConsumerStatefulWidget {
  const NfcScanningScreen({
    super.key,
    required this.onCancel,
  });
  final void Function() onCancel;

  @override
  ConsumerState<NfcScanningScreen> createState() =>
      _NfcScanningScreenState();
}

class _NfcScanningScreenState extends ConsumerState<NfcScanningScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _tagController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _tagController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _pulseController.repeat();
    _tagController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return NfcScreen(
      primaryColor: colorScheme.primary,
      backgroundColors: [
        colorScheme.primary.withValues(alpha: 0.1),
        colorScheme.surface,
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ],
      onCancel: widget.onCancel,
      header: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.nfc_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Scanning',      
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              // Instructional phone and NFC tag animation
              AnimatedBuilder(
                animation: Listenable.merge([
                  _pulseController,
                  _tagController,
                ]),
                builder: (context, child) {
                  return SizedBox(
                    width: 300,
                    height: 350,
                    child: CustomPaint(
                      painter: PhoneNfcPainter(
                        phoneColor: Colors.grey.shade200,
                        nfcAreaColor: colorScheme.primary,
                        tagColor: colorScheme.primary,
                        tagProgress: _tagController.value,
                        pulseProgress: _pulseController.value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                'Place NFC tag at the back of your phone. Keep it steady until scanning completes.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
