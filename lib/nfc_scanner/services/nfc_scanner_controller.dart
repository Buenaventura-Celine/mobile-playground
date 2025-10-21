import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_playground/nfc_scanner/domains/nfc_scanner_state.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';

// ignore: constant_identifier_names
const NFC_CODE_UNSUPPORTED = 'not_supported';

class NfcScannerController extends Notifier<NfcScannerState> {
  @override
  NfcScannerState build() {
    ref.onDispose(() {
      NfcManager.instance.stopSession();
    });

    _checkNfcAvailability();
    return const NfcScannerState.checking();
  }

  Future<void> _checkNfcAvailability() async {
    try {
      final isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        state = const NfcScannerState.disabled();
        return;
      }

      state = const NfcScannerState.scanning();
      startScanning();
    } catch (e) {
      if (e is PlatformException) {
        final notSupported = e.code == NFC_CODE_UNSUPPORTED;
        if (notSupported) {
          state = const NfcScannerState.unavailable();
          return;
        }
      }

      state = NfcScannerState.error(e.toString());
    }
  }

  void startScanning() {
    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso15693,
        NfcPollingOption.iso14443,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          if (Platform.isAndroid) {
            final nfcv = NfcVAndroid.from(tag);
            if (nfcv == null) {
              _decodeOtherTagType(tag);
              return;
            }

            final identifier = nfcv.tag.id;
            final value = identifier.reversed
                .map((b) => b.toRadixString(16).padLeft(2, '0'))
                .join()
                .toUpperCase();
            await NfcManager.instance.stopSession();
            state = NfcScannerState.success(value);
            return;
          }

          final iso15693 = Iso15693Ios.from(tag);
          if (iso15693 == null) {
            _decodeOtherTagType(tag);
            return;
          }

          final identifier = iso15693.identifier;
          final value = identifier
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join()
              .toUpperCase();
          await NfcManager.instance.stopSession();
          state = NfcScannerState.success(value);
          return;
        } catch (e, _) {
          state = NfcScannerState.error(e.toString());
        } finally {
          NfcManager.instance.stopSession();
        }
      },
    );
  }

  void tryAgain() {
    state = const NfcScannerState.checking();
    _checkNfcAvailability();
  }
 
  void _decodeOtherTagType(NfcTag tag) {
    try {
      final details = <String, String>{};

      // Try to extract UID from different tag types
      String? uid;
      final technologies = <String>[];

      // Check for NFC-A (Android)
      final nfcAAndroid = NfcAAndroid.from(tag);
      if (nfcAAndroid != null) {
        technologies.add('NFC-A');
        uid = nfcAAndroid.tag.id
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['Technology'] = 'NFC-A (ISO 14443-A)';
        details['ATQA'] = nfcAAndroid.atqa
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['SAK'] =
            '0x${nfcAAndroid.sak.toRadixString(16).padLeft(2, '0').toUpperCase()}';
      }

      // Check for NFC-B (Android)
      final nfcBAndroid = NfcBAndroid.from(tag);
      if (nfcBAndroid != null) {
        technologies.add('NFC-B');
        uid ??= nfcBAndroid.tag.id
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['Technology'] = 'NFC-B (ISO 14443-B)';
        details['Application Data'] = nfcBAndroid.applicationData
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['Protocol Info'] = nfcBAndroid.protocolInfo
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
      }

      // Check for NFC-F (Android)
      final nfcFAndroid = NfcFAndroid.from(tag);
      if (nfcFAndroid != null) {
        technologies.add('NFC-F');
        uid ??= nfcFAndroid.tag.id
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['Technology'] = 'NFC-F (FeliCa)';
        details['Manufacturer'] = nfcFAndroid.manufacturer
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['System Code'] = nfcFAndroid.systemCode
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
      }

      // Check for NFC-V (Android)
      final nfcVAndroid = NfcVAndroid.from(tag);
      if (nfcVAndroid != null) {
        technologies.add('NFC-V');
        uid ??= nfcVAndroid.tag.id
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['Technology'] = 'NFC-V (ISO 15693)';
        details['Response Flags'] =
            '0x${nfcVAndroid.responseFlags.toRadixString(16).padLeft(2, '0').toUpperCase()}';
        details['DSFID'] =
            '0x${nfcVAndroid.dsfId.toRadixString(16).padLeft(2, '0').toUpperCase()}';
      }

      // Check for MIFARE Classic (Android)
      final mifareClassicAndroid = MifareClassicAndroid.from(tag);
      if (mifareClassicAndroid != null) {
        technologies.add('MIFARE Classic');
        uid ??= mifareClassicAndroid.tag.id
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['Technology'] = 'MIFARE Classic';
        details['MIFARE Type'] = mifareClassicAndroid.type.toString();
        details['Memory Size'] = '${mifareClassicAndroid.size} bytes';
        details['Block Count'] = '${mifareClassicAndroid.blockCount}';
        details['Sector Count'] = '${mifareClassicAndroid.sectorCount}';
      }

      // Check for MIFARE Ultralight (Android)
      final mifareUltralightAndroid = MifareUltralightAndroid.from(tag);
      if (mifareUltralightAndroid != null) {
        technologies.add('MIFARE Ultralight');
        uid ??= mifareUltralightAndroid.tag.id
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        details['Technology'] = 'MIFARE Ultralight';
        details['MIFARE Type'] = mifareUltralightAndroid.type.toString();
      }

      // Check for NDEF (Android)
      final ndefAndroid = NdefAndroid.from(tag);
      if (ndefAndroid != null) {
        technologies.add('NDEF');
        details['NDEF Support'] = 'Yes';
        details['NDEF Writable'] = ndefAndroid.isWritable.toString();
        details['NDEF Max Size'] = '${ndefAndroid.maxSize} bytes';
        details['NDEF Type'] = ndefAndroid.type;
        details['NDEF Message'] = 'Available';
      } else {
        details['NDEF Support'] = 'No';
      }

      // Set UID and other details
      if (uid != null) {
        details['UID'] = uid;
        details['UID Length'] = '${uid.length ~/ 2} bytes';
      } else {
        details['UID'] = 'Unknown';
        details['UID Length'] = 'Unknown';
      }

      details['Technologies'] = technologies.join(', ');

      state = NfcScannerState.unsupported(details);
    } catch (e, _) {
      state = NfcScannerState.error(e.toString());
    }
  }
}

final nfcScannerControllerProvider =
    NotifierProvider.autoDispose<NfcScannerController, NfcScannerState>(
  NfcScannerController.new,
);
