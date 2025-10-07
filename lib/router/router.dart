import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_playground/home/presentation/home_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_error_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_scanned_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_scanner_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_waiting_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'nfc',
          builder: (BuildContext context, GoRouterState state) {
            return const NfcScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'nfc-waiting',
              name: 'nfc-waiting',
              builder: (BuildContext context, GoRouterState state) {
                return const NfcWaitingScreen();
              },
            ),
            GoRoute(
              path: 'nfc-success',
              name: 'nfc-success',
              builder: (BuildContext context, GoRouterState state) {
                return const NfcScannedScreen(
                  scannedData: '',
                );
              },
            ),
            GoRoute(
              path: 'nfc-error',
              name: 'nfc-error',
              builder: (BuildContext context, GoRouterState state) {
                return const NfcErrorScreen(
                  errorMessage: '',
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);