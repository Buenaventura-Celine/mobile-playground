import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NfcScreen extends StatelessWidget {
  const NfcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('NFC Scanner'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            context.goNamed('nfc-waiting');
          },
          child: const Text('Scan NFC'),
        ),
      ),
    );
  }
}
