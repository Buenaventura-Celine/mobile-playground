
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
      appBar: AppBar(title: const Text('NFC Scanner')),
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
                                  'Tap "Scan tag" to read an NFC tag',
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
                            child: const Text('Scan tag'),
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
        final nfcv = NfcV.from(tag);
        if (nfcv == null) {
          throw Exception('Tag is not compatible with NfcV.');
        }

        final nfcTagId = nfcv.identifier
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join(':')
              .toUpperCase();
        final identifier = nfcv.identifier.reversed
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join()
            .toUpperCase();
         
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
