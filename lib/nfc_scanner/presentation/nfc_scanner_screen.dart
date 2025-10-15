import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({super.key});

  @override
  State<StatefulWidget> createState() => NfcScreenState();
}

class NfcScreenState extends State<NfcScreen> {
  ValueNotifier<Map<String, dynamic>?> scanResult = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Scanner'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
              : Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            ValueListenableBuilder<Map<String, dynamic>?>(
                          valueListenable: scanResult,
                          builder: (context, data, _) {
                            if (data == null) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.nfc,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tap "Scan tag" to read an NFC tag',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _buildDataRow(
                                      'Supratag ID', data['identifier']),
                                  const SizedBox(height: 8),
                                  _buildDataRow(
                                      'NFC Tag ID', data['nfcTagId']),
                                  const SizedBox(height: 8),
                                  _buildDataRow(
                                      'Tag Type', data['tagType']),
                                  const SizedBox(height: 8),
                                  _buildDataRow('Memory Size',
                                      '${data['memorySize']} bytes'),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Note: Product details require API lookup',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: GridView.count(
                        padding: const EdgeInsets.all(4),
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: [
                          FilledButton.icon(
                            onPressed: _tagRead,
                            icon: const Icon(Icons.nfc),
                            label: const Text('Scan Tag'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => scanResult.value = null,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        final nfcv = NfcV.from(tag);
        if (nfcv == null) {
          throw Exception('Tag is not compatible with NfcV.');
        }

        final nfcTagId = nfcv.identifier
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(':')
            .toUpperCase();

        /// Why You Must Reverse NfcV Identifier Bytes?
        /// When you read nfcv.identifier on Android,
        /// you get the bytes in LSB-first order (as transmitted).
        /// But for display and comparison purposes,
        /// UIDs are conventionally shown in MSB-first order (reverse).
        ///
        /// Reference: https://en.wikipedia.org/wiki/ISO/IEC_15693
        /// According to the ISO 15693 protocol, multi-byte fields including the UID
        /// (Unique Identifier) are transmitted least significant byte (LSB) first over the ai
        ///
        /// Reference: https://github.com/chariotsolutions/phonegap-nfc/issues/446#issuecomment-1622738307
        /// https://github.com/chariotsolutions/phonegap-nfc/issues/446#issuecomment-1622738307
        ///
        /// iOS Raw: [224, 4, 1, 80, 118, 210, 129, 5]
        ///Hex: e004015076d28105 (MSB-first)
        ///Android Raw: [5, -127, -46, 118, 80, 1, 4, -32]
        ///Hex: 0581d276500104e0 (LSB-first as received)
        String identifier = nfcv.identifier.reversed
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
        if (Platform.isIOS) {
          identifier = nfcv.identifier
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join()
              .toUpperCase();
        }

        scanResult.value = {
          'identifier': identifier,
          'nfcTagId': nfcTagId,
          'scannedAt': DateTime.now().toString().substring(0, 19),
          'tagType': 'NFCV',
          'memorySize': nfcv.maxTransceiveLength,
        };
      } catch (e) {
        scanResult.value = {
          'identifier': 'Error: $e',
          'nfcTagId': 'N/A',
          'tagType': 'Error',
          'memorySize': 0,
        };
      } finally {
        NfcManager.instance.stopSession();
      }
    });
  }
}
