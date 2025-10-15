import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_playground/home/presentation/home_screen.dart';
import 'package:mobile_playground/nfc_scanner/presentation/nfc_scanner_screen.dart';

enum AppRoute { nfc }

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoute.nfc.name,
          builder: (BuildContext context, GoRouterState state) {
            return const NfcScreen();
          },
        ),
      ],
    ),
  ],
);

final routerProvider = Provider<GoRouter>((ref) {
  return router;
});
