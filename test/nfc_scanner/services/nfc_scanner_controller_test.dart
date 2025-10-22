import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_playground/nfc_scanner/domains/nfc_scanner_state.dart';
import 'package:mobile_playground/nfc_scanner/services/nfc_scanner_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock NFC channel
  const nfcChannel = MethodChannel('dev.flutter.pigeon.nfc_manager.HostApiPigeon.isAvailable');
  const readerModeChannel = MethodChannel('dev.flutter.pigeon.nfc_manager.HostApiPigeon.nfcAdapterEnableReaderMode');
  const disableReaderModeChannel = MethodChannel('dev.flutter.pigeon.nfc_manager.HostApiPigeon.nfcAdapterDisableReaderMode');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      nfcChannel,
      (MethodCall methodCall) async {
        return false; // NFC not available
      },
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      readerModeChannel,
      (MethodCall methodCall) async {
        return null;
      },
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      disableReaderModeChannel,
      (MethodCall methodCall) async {
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      nfcChannel,
      null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      readerModeChannel,
      null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      disableReaderModeChannel,
      null,
    );
  });

  group('NfcScannerController', () {
    group('Initialization', () {
      test('should initialize with checking state', () async {
        // Arrange
        final container = ProviderContainer();

        // Act
        final controller = container.read(nfcScannerControllerProvider);

        // Assert - Should start in checking state
        expect(controller, isA<NfcScannerState>());
        expect(
          controller.maybeWhen(checking: () => true, orElse: () => false),
          true,
        );

        // Wait for async operations to complete
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Cleanup
        container.dispose();
      });
    });

    group('State Transitions', () {
      test('checking state should have correct type', () {
        // Arrange
        const state = NfcScannerState.checking();

        // Assert
        expect(state, isA<NfcScannerState>());
        state.when(
          checking: () => expect(true, true),
          unavailable: () => fail('Should be checking state'),
          disabled: () => fail('Should be checking state'),
          scanning: () => fail('Should be checking state'),
          success: (_) => fail('Should be checking state'),
          error: (_) => fail('Should be checking state'),
        );
      });

      test('unavailable state should have correct type', () {
        // Arrange
        const state = NfcScannerState.unavailable();

        // Assert
        expect(state, isA<NfcScannerState>());
        state.when(
          checking: () => fail('Should be unavailable state'),
          unavailable: () => expect(true, true),
          disabled: () => fail('Should be unavailable state'),
          scanning: () => fail('Should be unavailable state'),
          success: (_) => fail('Should be unavailable state'),
          error: (_) => fail('Should be unavailable state'),
        );
      });

      test('disabled state should have correct type', () {
        // Arrange
        const state = NfcScannerState.disabled();

        // Assert
        expect(state, isA<NfcScannerState>());
        state.when(
          checking: () => fail('Should be disabled state'),
          unavailable: () => fail('Should be disabled state'),
          disabled: () => expect(true, true),
          scanning: () => fail('Should be disabled state'),
          success: (_) => fail('Should be disabled state'),
          error: (_) => fail('Should be disabled state'),
        );
      });

      test('scanning state should have correct type', () {
        // Arrange
        const state = NfcScannerState.scanning();

        // Assert
        expect(state, isA<NfcScannerState>());
        state.when(
          checking: () => fail('Should be scanning state'),
          unavailable: () => fail('Should be scanning state'),
          disabled: () => fail('Should be scanning state'),
          scanning: () => expect(true, true),
          success: (_) => fail('Should be scanning state'),
          error: (_) => fail('Should be scanning state'),
        );
      });

      test('success state should have correct type and contain details', () {
        // Arrange
        final details = {
          'UID': 'AABBCCDD',
          'Technology': 'NFC-A',
        };
        final state = NfcScannerState.success(details);

        // Assert
        expect(state, isA<NfcScannerState>());
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails, equals(details));
            expect(receivedDetails['UID'], equals('AABBCCDD'));
            expect(receivedDetails['Technology'], equals('NFC-A'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('error state should have correct type and contain message', () {
        // Arrange
        const errorMessage = 'NFC scan failed';
        const state = NfcScannerState.error(errorMessage);

        // Assert
        expect(state, isA<NfcScannerState>());
        state.when(
          checking: () => fail('Should be error state'),
          unavailable: () => fail('Should be error state'),
          disabled: () => fail('Should be error state'),
          scanning: () => fail('Should be error state'),
          success: (_) => fail('Should be error state'),
          error: (message) => expect(message, equals(errorMessage)),
        );
      });
    });

    group('State Equality', () {
      test('checking states should be equal', () {
        // Arrange
        const state1 = NfcScannerState.checking();
        const state2 = NfcScannerState.checking();

        // Assert
        expect(state1, equals(state2));
      });

      test('unavailable states should be equal', () {
        // Arrange
        const state1 = NfcScannerState.unavailable();
        const state2 = NfcScannerState.unavailable();

        // Assert
        expect(state1, equals(state2));
      });

      test('disabled states should be equal', () {
        // Arrange
        const state1 = NfcScannerState.disabled();
        const state2 = NfcScannerState.disabled();

        // Assert
        expect(state1, equals(state2));
      });

      test('scanning states should be equal', () {
        // Arrange
        const state1 = NfcScannerState.scanning();
        const state2 = NfcScannerState.scanning();

        // Assert
        expect(state1, equals(state2));
      });

      test('success states with same details should be equal', () {
        // Arrange
        final details = {'UID': 'AABBCCDD'};
        final state1 = NfcScannerState.success(details);
        final state2 = NfcScannerState.success(details);

        // Assert
        expect(state1, equals(state2));
      });

      test('success states with different details should not be equal', () {
        // Arrange
        final details1 = {'UID': 'AABBCCDD'};
        final details2 = {'UID': 'EEFFGGHH'};
        final state1 = NfcScannerState.success(details1);
        final state2 = NfcScannerState.success(details2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('error states with same message should be equal', () {
        // Arrange
        const message = 'Error message';
        const state1 = NfcScannerState.error(message);
        const state2 = NfcScannerState.error(message);

        // Assert
        expect(state1, equals(state2));
      });

      test('error states with different messages should not be equal', () {
        // Arrange
        const message1 = 'Error message 1';
        const message2 = 'Error message 2';
        const state1 = NfcScannerState.error(message1);
        const state2 = NfcScannerState.error(message2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });
    });

    group('maybeWhen', () {
      test('maybeWhen should handle checking state', () {
        // Arrange
        const state = NfcScannerState.checking();

        // Act
        final result = state.maybeWhen(
          checking: () => 'checking',
          orElse: () => 'other',
        );

        // Assert
        expect(result, equals('checking'));
      });

      test('maybeWhen should handle success state', () {
        // Arrange
        final details = {'UID': 'AABBCCDD'};
        final state = NfcScannerState.success(details);

        // Act
        final result = state.maybeWhen(
          success: (d) => 'success: ${d['UID']}',
          orElse: () => 'other',
        );

        // Assert
        expect(result, equals('success: AABBCCDD'));
      });

      test('maybeWhen should fall back to orElse', () {
        // Arrange
        const state = NfcScannerState.disabled();

        // Act
        final result = state.maybeWhen(
          checking: () => 'checking',
          orElse: () => 'other',
        );

        // Assert
        expect(result, equals('other'));
      });
    });

    group('map', () {
      test('map should handle all states', () {
        // Arrange
        const states = [
          NfcScannerState.checking(),
          NfcScannerState.unavailable(),
          NfcScannerState.disabled(),
          NfcScannerState.scanning(),
          NfcScannerState.success({'UID': 'test'}),
          NfcScannerState.error('error'),
        ];

        // Act & Assert
        for (final state in states) {
          final result = state.map(
            checking: (_) => 'checking',
            unavailable: (_) => 'unavailable',
            disabled: (_) => 'disabled',
            scanning: (_) => 'scanning',
            success: (_) => 'success',
            error: (_) => 'error',
          );

          expect(result, isA<String>());
        }
      });
    });

    group('Constants', () {
      test('NFC_CODE_UNSUPPORTED should be correct', () {
        // Assert
        expect(NFC_CODE_UNSUPPORTED, equals('not_supported'));
      });
    });

    group('Error Handling', () {
      test('error state should preserve error message', () {
        // Arrange
        const errorMessage = 'Platform exception occurred';
        const state = NfcScannerState.error(errorMessage);

        // Act
        String? receivedMessage;
        state.when(
          checking: () {},
          unavailable: () {},
          disabled: () {},
          scanning: () {},
          success: (_) {},
          error: (message) => receivedMessage = message,
        );

        // Assert
        expect(receivedMessage, equals(errorMessage));
      });

      test('should handle PlatformException correctly', () {
        // Arrange
        final exception = PlatformException(
          code: NFC_CODE_UNSUPPORTED,
          message: 'NFC not supported',
        );

        // Assert
        expect(exception.code, equals(NFC_CODE_UNSUPPORTED));
        expect(exception.message, equals('NFC not supported'));
      });
    });

    group('Tag Details', () {
      test('success state should handle empty details', () {
        // Arrange
        const state = NfcScannerState.success({});

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (details) {
            expect(details, isEmpty);
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle multiple details', () {
        // Arrange
        final details = {
          'UID': 'AABBCCDD',
          'Technology': 'NFC-A (ISO 14443-A)',
          'ATQA': '0044',
          'SAK': '0x08',
          'UID Length': '4 bytes',
          'Technologies': 'NFC-A',
          'NDEF Support': 'No',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails.length, equals(7));
            expect(receivedDetails['UID'], equals('AABBCCDD'));
            expect(receivedDetails['Technology'], equals('NFC-A (ISO 14443-A)'));
            expect(receivedDetails['ATQA'], equals('0044'));
            expect(receivedDetails['SAK'], equals('0x08'));
            expect(receivedDetails['UID Length'], equals('4 bytes'));
            expect(receivedDetails['Technologies'], equals('NFC-A'));
            expect(receivedDetails['NDEF Support'], equals('No'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle NFC-B details', () {
        // Arrange
        final details = {
          'Technology': 'NFC-B (ISO 14443-B)',
          'UID': '11223344',
          'Application Data': 'AABBCCDD',
          'Protocol Info': '0011',
          'Technologies': 'NFC-B',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails['Technology'], equals('NFC-B (ISO 14443-B)'));
            expect(receivedDetails['Application Data'], equals('AABBCCDD'));
            expect(receivedDetails['Protocol Info'], equals('0011'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle NFC-F (FeliCa) details', () {
        // Arrange
        final details = {
          'Technology': 'NFC-F (FeliCa)',
          'UID': '0102030405060708',
          'Manufacturer': 'AABB',
          'System Code': '12FC',
          'Technologies': 'NFC-F',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails['Technology'], equals('NFC-F (FeliCa)'));
            expect(receivedDetails['Manufacturer'], equals('AABB'));
            expect(receivedDetails['System Code'], equals('12FC'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle NFC-V (ISO 15693) details', () {
        // Arrange
        final details = {
          'Technology': 'NFC-V (ISO 15693)',
          'UID': 'E0040102030405',
          'Response Flags': '0x00',
          'DSFID': '0x00',
          'Technologies': 'NFC-V',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails['Technology'], equals('NFC-V (ISO 15693)'));
            expect(receivedDetails['Response Flags'], equals('0x00'));
            expect(receivedDetails['DSFID'], equals('0x00'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle MIFARE Classic details', () {
        // Arrange
        final details = {
          'Technology': 'MIFARE Classic',
          'UID': 'AABBCCDD',
          'MIFARE Type': 'MifareType.classic1k',
          'Memory Size': '1024 bytes',
          'Block Count': '64',
          'Sector Count': '16',
          'Technologies': 'MIFARE Classic',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails['Technology'], equals('MIFARE Classic'));
            expect(receivedDetails['Memory Size'], equals('1024 bytes'));
            expect(receivedDetails['Block Count'], equals('64'));
            expect(receivedDetails['Sector Count'], equals('16'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle MIFARE Ultralight details', () {
        // Arrange
        final details = {
          'Technology': 'MIFARE Ultralight',
          'UID': 'AABBCCDD',
          'MIFARE Type': 'MifareType.ultralight',
          'Technologies': 'MIFARE Ultralight',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails['Technology'], equals('MIFARE Ultralight'));
            expect(receivedDetails['MIFARE Type'], equals('MifareType.ultralight'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle NDEF details', () {
        // Arrange
        final details = {
          'UID': 'AABBCCDD',
          'Technology': 'NFC-A (ISO 14443-A)',
          'NDEF Support': 'Yes',
          'NDEF Writable': 'true',
          'NDEF Max Size': '716 bytes',
          'NDEF Type': 'android.nfc.tech.Ndef',
          'NDEF Message': 'Available',
          'Technologies': 'NFC-A, NDEF',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails['NDEF Support'], equals('Yes'));
            expect(receivedDetails['NDEF Writable'], equals('true'));
            expect(receivedDetails['NDEF Max Size'], equals('716 bytes'));
            expect(receivedDetails['NDEF Message'], equals('Available'));
          },
          error: (_) => fail('Should be success state'),
        );
      });

      test('success state should handle unknown UID', () {
        // Arrange
        final details = {
          'UID': 'Unknown',
          'UID Length': 'Unknown',
          'Technologies': '',
        };
        final state = NfcScannerState.success(details);

        // Act & Assert
        state.when(
          checking: () => fail('Should be success state'),
          unavailable: () => fail('Should be success state'),
          disabled: () => fail('Should be success state'),
          scanning: () => fail('Should be success state'),
          success: (receivedDetails) {
            expect(receivedDetails['UID'], equals('Unknown'));
            expect(receivedDetails['UID Length'], equals('Unknown'));
          },
          error: (_) => fail('Should be success state'),
        );
      });
    });
  });
}
