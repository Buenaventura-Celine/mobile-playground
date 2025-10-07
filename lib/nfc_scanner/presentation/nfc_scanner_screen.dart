
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
      appBar: AppBar(title: const Text('Supratag NFC Scanner')),
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
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ValueListenableBuilder<Map<String, dynamic>?>(
                          valueListenable: scanResult,
                          builder: (context, data, _) {
                            if (data == null) {
                              return const Center(
                                child: Text(
                                  'Tap "Scan Supratag" to read an NFC tag',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDataRow('Supratag ID', data['identifier']),
                                  const SizedBox(height: 8),
                                  _buildDataRow('NFC Tag ID', data['nfcTagId']),
                                  const SizedBox(height: 8),
                                  _buildDataRow('Scanned At', data['scannedAt']),
                                  const SizedBox(height: 8),
                                  _buildDataRow('Tag Type', data['tagType']),
                                  const SizedBox(height: 8),
                                  _buildDataRow('Memory Size', '${data['memorySize']} bytes'),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Note: Product details require API lookup',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
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
                        padding: EdgeInsets.all(4),
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: [
                          ElevatedButton(
                            onPressed: _tagRead,
                            child: const Text('Scan Supratag'),
                          ),
                          ElevatedButton(
                            onPressed: () => scanResult.value = null,
                            child: const Text('Clear'),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        final ndef = Ndef.from(tag);
        String? identifier;
        
        if (ndef != null) {
          final message = await ndef.read();
          if (message.records.isNotEmpty) {
            final record = message.records.first;
            if (record.payload.isNotEmpty && record.payload[0] == 3) {
              // Skip URI prefix byte, extract identifier
              identifier = String.fromCharCodes(record.payload.sublist(1));
            }
          }
        }

        // Extract NFC tag ID
        final tagIdentifier = tag.data['nfcv']?['identifier'] ?? 
                             tag.data['ndef']?['identifier'] ?? 
                             tag.data['nfca']?['identifier'];
        
        String nfcTagId = 'Unknown';
        if (tagIdentifier != null) {
          nfcTagId = (tagIdentifier as List<int>)
              .map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join(':')
              .toUpperCase();
        }

        // Get tag type info
        final tagTypes = tag.data.keys.join(', ');
        final maxSize = ndef?.maxSize ?? 0;

        // Update UI with decoded data
        scanResult.value = {
          'identifier': identifier ?? 'Could not decode',
          'nfcTagId': nfcTagId,
          'scannedAt': DateTime.now().toString().substring(0, 19),
          'tagType': tagTypes.toUpperCase(),
          'memorySize': maxSize,
        };

        print('===== Supratag Decoded =====');
        print('Identifier: $identifier');
        print('NFC Tag ID: $nfcTagId');
        print('Tag Types: $tagTypes');
        
      } catch (e) {
        print('Error reading tag: $e');
        scanResult.value = {
          'identifier': 'Error: $e',
          'nfcTagId': 'N/A',
          'scannedAt': DateTime.now().toString().substring(0, 19),
          'tagType': 'Error',
          'memorySize': 0,
        };
      } finally {
        NfcManager.instance.stopSession();
      }
    });
  }
}
