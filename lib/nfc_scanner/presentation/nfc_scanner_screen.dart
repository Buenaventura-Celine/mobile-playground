import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_playground/nfc_scanner/domains/nfc_scanner_state.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_checking_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_error_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_scanning_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_success_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_turned_off_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_screen_types.dart/nfc_unsupported_screen.dart';
import 'package:mobile_playground/nfc_scanner/services/nfc_scanner_controller.dart';

class NfcScannerScanner extends ConsumerWidget {
  const NfcScannerScanner({super.key});

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nfcState = ref.watch(nfcScannerControllerProvider);

    void handleTryAgain() {
      ref.read(nfcScannerControllerProvider.notifier).tryAgain();
    }

    void handleCancel() {
      Navigator.of(context).pop();
    }

    return nfcState.when(
      checking: () => NfcCheckingScreen(onCancel: handleCancel),
      unavailable: () => NfcErrorScreen(
        title: 'NFC Scanner is Unsupported',
        subtitle: 'This device does not support NFC scanning.',
        onCancel: handleCancel,
      ),
      disabled: () => NfcTurnedOffScreen(
        title: 'NFC Scanner is Turned Off',
        subtitle: 'Please enable NFC in your device settings to continue scanning.s',
        onTurnedOn: () async {
          await AppSettings.openAppSettings(type: AppSettingsType.nfc);
        },
        onCancel: handleCancel,
      ),
      scanning: () =>
          NfcScanningScreen(onCancel: handleCancel),
      success: (_) => const NfcSuccessScreen(),
      error: (message) => NfcErrorScreen(
        title: 'Scan Failed',
        subtitle: message,
        onTryAgain: handleTryAgain,
        onCancel: handleCancel,
      ),
      unsupported: (details) => NfcUnsupportedScreen(
        tagDetails: details,
        onTryAgain: handleTryAgain,
        onCancel: handleCancel,
      ),
    );
  }
}
