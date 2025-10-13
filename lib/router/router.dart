import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_playground/home/presentation/home_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_scanner_screen.dart';

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
        ),
      ],
    ),
  ],
);