import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfc_scanner_state.freezed.dart';

@freezed
sealed class NfcScannerState with _$NfcScannerState {
  const factory NfcScannerState.checking() = _Checking;
  const factory NfcScannerState.unavailable() = _Unavailable;
  const factory NfcScannerState.disabled() = _Disabled;
  const factory NfcScannerState.scanning() = _Scanning;
  const factory NfcScannerState.success(String value) = _Success;
  const factory NfcScannerState.error(String message) = _Error;
  const factory NfcScannerState.unsupported(Map<String, String> details) =
      _Unsupported;
}
